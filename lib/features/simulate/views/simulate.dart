import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:card_cambio/utils/rate_utils.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../widgets/bank_tile.dart';
import 'package:flutter/services.dart';

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
    final rateList = sortRatesByValue(getRecentRates(rates));
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              children: [
                Text(AppLocalizations.of(context)!.purchase_calculator_title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
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
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Builder(
                              builder: (context) {
                                return TextField(
                                  controller: moneyController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false), // Better mobile keyboard
                                  autofocus: false, // Do not focus by default
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    // Limit to 99_999_999.99
                                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9,.]*')),
                                  ],
                                  onChanged: (value) {
                                    final parsed = moneyController.numberValue;
                                    if (parsed > 99999999.99) {
                                      moneyController.updateValue(99999999.99);
                                    }
                                    setState(() {}); // Ensure UI updates for suffixIcon
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
                                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
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
                        const SizedBox(height: 30),
                        Divider(height: 1, color: Theme.of(context).dividerColor),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.you_would_pay,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        ...rateList.asMap().entries.map((entry) {
                          final rate = entry.value.value;
                          final bankName = entry.value.key;
                          final bankInfo = getBankInfo(bankName, isDark);
                          final inputValue = moneyController.text.isEmpty ? 0.0 : moneyController.numberValue;

                          double spread;
                          double iof;
                          switch (bankName) {
                            case 'nubank':
                              spread = 4.0;
                              iof = 4.38;
                            case 'itau':
                              spread = 5.5;
                              iof = 4.38;
                            case 'c6':
                              spread = 2.5;
                              iof = 4.38;
                            case 'bb':
                              spread = 5.0;
                              iof = 4.38;
                            default:
                              spread = 4.0;
                              iof = 4.38;
                          }

                          final double ptax = rate.taxaConversao;
                          final double spreadValue = ptax * (spread / 100);
                          final double totalRate = ptax + spreadValue;
                          final double valueWithRate = inputValue * totalRate;
                          final double valueWithIof = valueWithRate * (1 + iof / 100);

                          return BankTile(
                            name: bankInfo['name']!,
                            finalValue: valueWithIof,
                            ptaxRate: ptax,
                            bankSpread: spread,
                            iof: iof,
                            color: bankInfo['color'] as Color, // Pass full opacity color
                            isDark: isDark,
                            isBest: entry.key == 0,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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