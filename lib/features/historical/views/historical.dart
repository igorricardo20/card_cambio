import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:card_cambio/features/historical/widgets/calendarview.dart';
import '../widgets/tableview.dart';

class Historical extends StatefulWidget {
  const Historical({super.key});

  @override
  State<Historical> createState() => _HistoricalState();
}

class _HistoricalState extends State<Historical> {
  String? selectedBank = 'nubank';
  bool showCalendar = true; // New state variable
  int? _rowsPerPage;

  @override
  Widget build(BuildContext context) {
    final rateProvider = Provider.of<RateProvider>(context);
    final shimmerColors = Theme.of(context).extension<ShimmerColors>()!;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ListView(
            cacheExtent: 1000,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.historical, style: Theme.of(context).textTheme.headlineSmall),
                    Text(AppLocalizations.of(context)!.historical_data),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 340, // Slightly wider for better spacing
                      height: 54,
                      child: Row(
                        children: [
                          Card(
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.18), width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedBank,
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white : Colors.grey[700]),
                                  dropdownColor: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500, // Less bold
                                    letterSpacing: 0.1,
                                  ),
                                  items: [
                                    DropdownMenuItem(value: 'bb', child: Row(children: [Icon(Icons.account_balance, size: 18, color: isDark ? Colors.grey[200] : Color(0xFFFFCC29)), SizedBox(width: 7), Text('Banco do Brasil', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                    DropdownMenuItem(value: 'c6', child: Row(children: [Icon(Icons.credit_card, size: 18, color: isDark ? Colors.grey[200] : Colors.black), SizedBox(width: 7), Text('C6 Bank', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                    DropdownMenuItem(value: 'caixa', child: Row(children: [Icon(Icons.account_balance, size: 18, color: isDark ? Colors.blue[200] : Color(0xFF005CA9)), SizedBox(width: 7), Text('Caixa', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                    DropdownMenuItem(value: 'itau', child: Row(children: [Icon(Icons.account_balance, size: 18, color: isDark ? Colors.orange[200] : Colors.orange), SizedBox(width: 7), Text('Itaú', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                    DropdownMenuItem(value: 'nubank', child: Row(children: [Icon(Icons.account_balance_wallet, size: 18, color: isDark ? Color(0xFFB388FF) : Color(0xFF820AD1)), SizedBox(width: 7), Text('NuBank', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                    DropdownMenuItem(value: 'safra', child: Row(children: [Icon(Icons.account_balance, size: 18, color: isDark ? Colors.grey[300] : Color(0xFF2B2D42)), SizedBox(width: 7), Text('Safra', style: TextStyle(fontWeight: FontWeight.w500))],)),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBank = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 100, // Match dropdown width for toggle
                            height: 54,
                            child: Card(
                              elevation: 0,
                              color: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.18), width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(CupertinoIcons.calendar_today),
                                      color: showCalendar ? Theme.of(context).primaryColor : Colors.grey,
                                      onPressed: () {
                                        setState(() {
                                          showCalendar = true;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(CupertinoIcons.square_list),
                                      color: !showCalendar ? Theme.of(context).primaryColor : Colors.grey,
                                      onPressed: () {
                                        setState(() {
                                          showCalendar = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: showCalendar
                    ? FutureBuilder<Widget>(
                        future: _buildCalendar(rateProvider.rates[selectedBank!] ?? []),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: shimmerColors.baseColor,
                              highlightColor: shimmerColors.highlightColor,
                              child: CalendarViewPlaceholder(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: \\${snapshot.error}');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      )
                    : rateProvider.hasData
                        ? _buildTable(rateProvider.rates[selectedBank!] ?? [], bankColors[selectedBank!] ?? Colors.blue, isDark)
                        : Shimmer.fromColors(
                            baseColor: shimmerColors.baseColor,
                            highlightColor: shimmerColors.highlightColor,
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(top: 8, bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.13), width: 1),
                              ),
                              child: SizedBox(height: 180),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _buildCalendar(List<Rate> rates) async {
    await Future.delayed(Duration(milliseconds: 250)); // Simulate delay
    final color = bankColors[selectedBank!] ?? Colors.blue;
    return CalendarView(rates, highlightColor: color);
  }

  Widget _buildTable(List<Rate> rates, Color highlightColor, bool isDark) {
    return TableView(
      rates: rates,
      highlightColor: highlightColor,
      isDark: isDark,
      initialRowsPerPage: _rowsPerPage,
    );
  }
}

final Map<String, Color> bankColors = {
  'nubank': Colors.purple,
  'itau': Colors.orange,
  'c6': Colors.black,
  'bb': Color(0xFFFFCC29),
  'caixa': Color(0xFF005CA9), // Caixa blue
};
final Map<String, String> bankNames = {
  'nubank': 'Nubank',
  'itau': 'Itaú',
  'c6': 'C6 Bank',
  'bb': 'Banco do Brasil',
  'caixa': 'Caixa',
};