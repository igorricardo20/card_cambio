import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:card_cambio/utils/rate_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class Simulate extends StatelessWidget {
  const Simulate({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RateProvider>(context);
    final rates = provider.rates;
    final rateList = sortRatesByValue(getRecentRates(rates));
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: ListView(
              children: [
                Text(AppLocalizations.of(context)!.purchase_calculator_title, style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 20),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Purchase Value',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.grey[700] : Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Divider(height: 1, color: Theme.of(context).dividerColor),
                        SizedBox(height: 20),
                        Text(
                          'Results',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rateList.length,
                          itemBuilder: (context, index) {
                            final rate = rateList[index].value;
                            final bankName = rateList[index].key;
                            final bankInfo = getBankInfo(bankName, isDark);

                            return BankTile(
                              name: bankInfo['name']!,
                              finalValue: 10, // to be calculated
                              ptaxRate: rate.taxaConversao, // Placeholder
                              bankSpread: 4, // Placeholder
                              iof: 0.38, // Placeholder
                              color: bankInfo['color'] as Color,
                              isDark: isDark,
                            );
                          },
                        ),
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

class BankTile extends StatefulWidget {
  final String name;
  final double finalValue;
  final double ptaxRate;
  final double bankSpread;
  final double iof;
  final Color color;
  final bool isDark;

  const BankTile({
    required this.name,
    required this.finalValue,
    required this.ptaxRate,
    required this.bankSpread,
    required this.iof,
    required this.color,
    required this.isDark,
  });

  @override
  _BankTileState createState() => _BankTileState();
}

class _BankTileState extends State<BankTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isDark ? Colors.grey[700] : Colors.white,
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            minTileHeight: 60,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name), // Bank name
                Text(
                  'R\$ ${widget.finalValue.toStringAsFixed(2)}', // Final value
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PTAX rate: ${widget.ptaxRate}'),
                  Text('Bank spread: ${widget.bankSpread}%'),
                  Text('IOF: ${widget.iof}%'),
                  // Add more details here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> getBankInfo(String bankName, bool isDark) {
  final Map<String, String> bankNames = {
    'nubank': 'Nubank',
    'itau': 'Itaú',
    'c6': 'C6 Bank',
  };

  final Map<String, Color> bankColors = {
    'nubank': Colors.purple,
    'itau': Colors.orange,
    'c6': Colors.black,
  };

  return {
    'name': bankNames[bankName]!,
    'color': bankColors[bankName]!,
  };
}