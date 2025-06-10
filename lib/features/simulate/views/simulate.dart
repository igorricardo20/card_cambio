import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:card_cambio/utils/rate_utils.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../widgets/bank_tile.dart';
import 'package:flutter/services.dart';
import 'package:card_cambio/features/simulate/providers/ptax_provider.dart';
import 'package:shimmer/shimmer.dart';

class Simulate extends StatefulWidget {
  const Simulate({super.key});

  @override
  State<Simulate> createState() => _SimulateState();
}

class _SimulateState extends State<Simulate> {
  late MoneyMaskedTextController moneyController;

  @override
  void initState() {
    super.initState();
    moneyController = MoneyMaskedTextController();
    moneyController.addListener(_onValueChanged);
  }

  @override
  void dispose() {
    moneyController.removeListener(_onValueChanged);
    moneyController.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    setState(() {}); // Triggers rebuild for real-time update
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RateProvider>(context);
    final rates = provider.rates;
    final recentRates = getRecentRates(rates);
    final rateList = sortRatesByValue(recentRates);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // Determine if user has typed a value
    final hasInput = moneyController.text.isNotEmpty && moneyController.numberValue > 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ChangeNotifierProvider(
        create: (_) => PtaxProvider()..fetchPtaxForToday(),
        child: Builder(
          builder: (context) {
            final ptaxProvider = Provider.of<PtaxProvider>(context);
            final ptax = ptaxProvider.ptax;
            final ptaxLoading = ptaxProvider.loading;
            final ptaxError = ptaxProvider.error;
            final iof = 3.38; // Fixed IOF value

            return Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    children: [
                      Text(AppLocalizations.of(context)!.purchase_calculator_title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 20),
                      // Instead of AnimatedSize, use a fixed minHeight for the card and let it grow only downward
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (hasInput)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          minHeight: 180,
                          // Increase maxHeight to fit all tiles comfortably (e.g., 90% of screen height)
                          maxHeight: MediaQuery.of(context).size.height * 0.92,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Improved input section
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    AppLocalizations.of(context)?.purchase_value ?? 'Purchase Value',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                ptaxLoading
                                    ? Shimmer.fromColors(
                                        baseColor: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                                        highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                                        period: const Duration(milliseconds: 900),
                                        child: Container(
                                          width: double.infinity,
                                          height: 54,
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              return TextField(
                                                controller: moneyController,
                                                keyboardType: Theme.of(context).platform == TargetPlatform.iOS
                                                    ? TextInputType.text
                                                    : const TextInputType.numberWithOptions(decimal: true, signed: false), // Better mobile keyboard
                                                autofocus: false, // Do not focus by default
                                                textInputAction: TextInputAction.done, // Ensures 'Done' or 'Close' on keyboard
                                                inputFormatters: [
                                                  // Limit to 99_999_999.99
                                                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9,.]*')),
                                                ],
                                                onChanged: (value) {
                                                  final parsed = moneyController.numberValue;
                                                  if (parsed > 99999999.99) {
                                                    moneyController.updateValue(99999999.99);
                                                  }
                                                  setState(() {});
                                                },
                                                decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                                                  filled: true,
                                                  fillColor: isDark
                                                      ? Colors.grey[900] // Much darker for contrast in dark mode
                                                      : Colors.grey[50], // Always use default for light mode
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  suffixIcon: moneyController.numberValue != 0
                                                      ? IconButton(
                                                          icon: const Icon(Icons.clear, size: 20),
                                                          onPressed: () {
                                                            setState(() {
                                                              moneyController.text = '';
                                                              moneyController.updateValue(0);
                                                            });
                                                          },
                                                        )
                                                      : null,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                onSubmitted: (_) => FocusScope.of(context).unfocus(), // Dismiss keyboard on done
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0, left: 2.0, bottom: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)?.purchase_value_hint ?? 'Enter the value you want to simulate',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  switchInCurve: Curves.easeOutBack,
                                  switchOutCurve: Curves.easeIn,
                                  child: hasInput
                                      ? Column(
                                          key: const ValueKey('tiles'),
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Divider(height: 1, color: Theme.of(context).dividerColor),
                                            const SizedBox(height: 20),
                                            Text(
                                              '${AppLocalizations.of(context)!.you_would_pay} *',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 10),
                                            ...rateList.asMap().entries.map((entry) {
                                              final bankName = entry.value.key;
                                              final rate = entry.value.value;
                                              final bankInfo = getBankInfo(bankName, isDark);
                                              final inputValue = moneyController.text.isEmpty ? 0.0 : moneyController.numberValue;

                                              // Use the most recent rate for calculation
                                              final double baseRate = rate.taxaConversao;
                                              final double iof = 3.38; // Use the IOF for simulation
                                              final double valueWithIof = inputValue * baseRate * (1 + iof / 100);

                                              // For reference only
                                              double spread = 4.0;
                                              double ptax = 0.0;
                                              switch (bankName) {
                                                case 'nubank':
                                                  spread = 4.0;
                                                case 'itau':
                                                  spread = 5.5;
                                                case 'c6':
                                                  spread = 5.25;
                                                case 'bb':
                                                  spread = 4.0;
                                                case 'caixa':
                                                  spread = 4.0;
                                                case 'safra':
                                                  spread = 7.0;
                                                default:
                                                  spread = 4.0;
                                              }
                                              ptax = rate.taxaConversao / (1 + spread / 100);

                                              return TweenAnimationBuilder<Offset>(
                                                key: ValueKey(bankName),
                                                tween: Tween(
                                                  begin: const Offset(0, 0.15),
                                                  end: Offset.zero,
                                                ),
                                                duration: Duration(milliseconds: 350 + entry.key * 60),
                                                curve: Curves.easeOut,
                                                builder: (context, offset, child) {
                                                  return Opacity(
                                                    opacity: 1 - offset.dy * 3,
                                                    child: Transform.translate(
                                                      offset: Offset(0, offset.dy * 40),
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: BankTile(
                                                  name: bankInfo['name']!,
                                                  finalValue: valueWithIof,
                                                  ptaxRate: ptax,
                                                  bankSpread: spread,
                                                  iof: iof,
                                                  color: bankInfo['color'] as Color,
                                                  isDark: isDark,
                                                  isBest: entry.key == 0,
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        )
                                      : SizedBox(key: const ValueKey('empty'), height: 0),
                                ),
                                if (ptaxLoading)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0, bottom: 2.0, right: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                          child: Shimmer.fromColors(
                                            baseColor: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                                            highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                                            period: const Duration(milliseconds: 900),
                                            child: Container(
                                              width: 70,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (ptaxError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0, bottom: 2.0, right: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('PTAX error', style: TextStyle(color: Colors.red, fontSize: 13)),
                                      ],
                                    ),
                                  )
                                else if (ptax != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14.0, bottom: 2.0, right: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InfoChip(
                                          label: 'PTAX',
                                          value: '${ptax.toStringAsFixed(2)}%',
                                          isDark: isDark,
                                          dense: true,
                                        ),
                                        const SizedBox(width: 4),
                                        InfoChip(
                                          label: 'IOF',
                                          value: '${iof.toStringAsFixed(2)}%',
                                          isDark: isDark,
                                          dense: true,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (hasInput) ...[
                        const SizedBox(height: 40),
                        Text(
                          AppLocalizations.of(context)?.calculationDisclaimer ??
                            '* Calculations are based on the formulas and rates currently used by each bank. Actual purchase values may differ due to changes in bank policies, fees, or exchange rates. Always confirm with your bank before making a purchase.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)?.spreadDisclaimer ??
                            '** Spreads may not update immediately after a bank changes its rate. For banks like Safra that do not disclose their spread, a fair and transparent estimate is used based on recent market data.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Map<String, dynamic> getBankInfo(String bankName, bool isDark) {
  final Map<String, String> bankNames = {
    'nubank': 'Nubank',
    'itau': 'Itaú',
    'c6': 'C6 Bank',
    'bb': 'Banco do Brasil',
    'caixa': 'Caixa',
  };

  final Map<String, Color> bankColors = {
    'nubank': Colors.purple,
    'itau': Colors.orange,
    'c6': Colors.black,
    'bb': Color(0xFFFFCC29),
    'caixa': Color(0xFF005CA9), // Caixa blue
  };

  final String fallbackName = bankName.isNotEmpty ? bankName : 'Unknown';
  final Color fallbackColor = isDark ? Colors.white : Colors.black;

  return {
    'name': bankNames[bankName] ?? fallbackName,
    'color': bankColors[bankName] ?? fallbackColor,
  };
}