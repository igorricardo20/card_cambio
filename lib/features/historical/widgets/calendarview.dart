import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/providers/locale_provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// New CalendarView widget
class CalendarView extends StatelessWidget {
  final List<Rate> rates;
  final Color? highlightColor;

  CalendarView(this.rates, {this.highlightColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    final today = DateTime.now();

    // Performance: Precompute the 3 lowest values for each month
    final Map<String, Set<double>> monthCheapestRates = {};
    for (final rate in rates) {
      if (rate.taxaConversao > 0) {
        final d = DateTime.parse(rate.taxaDivulgacaoDataHora);
        final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
        monthCheapestRates.putIfAbsent(key, () => <double>{});
        monthCheapestRates[key]!.add(rate.taxaConversao);
      }
    }
    // Only keep the 3 lowest for each month
    monthCheapestRates.updateAll((key, values) {
      final sorted = values.toList()..sort();
      return sorted.take(3).toSet();
    });

    return TableCalendar(
      locale: locale,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: today,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: isDark ? Colors.white : Colors.black,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.white : Colors.black, size: 24),
        rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.white : Colors.black, size: 24),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : Colors.grey[700], fontSize: 13),
        weekendStyle: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : Colors.grey[500], fontSize: 13),
      ),
      calendarStyle: CalendarStyle(
        cellMargin: EdgeInsets.all(2),
        cellPadding: EdgeInsets.zero,
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        weekendTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        todayDecoration: BoxDecoration(), // We'll handle today below
        todayTextStyle: TextStyle(),
        selectedDecoration: BoxDecoration(),
        selectedTextStyle: TextStyle(),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final rate = rates.firstWhere(
            (rate) => DateFormat('yyyy-MM-dd').format(DateTime.parse(rate.taxaDivulgacaoDataHora)) == DateFormat('yyyy-MM-dd').format(day),
            orElse: () => Rate.blank(),
          );
          final isToday = DateTime(day.year, day.month, day.day) == DateTime(today.year, today.month, today.day);
          final Color? color = isToday ? highlightColor : null;

          // Use precomputed cheapest for this month
          final monthKey = '${day.year}-${day.month.toString().padLeft(2, '0')}';
          final cheapestRates = monthCheapestRates[monthKey] ?? const <double>{};
          final isCheapest = cheapestRates.contains(rate.taxaConversao) && rate.taxaConversao > 0;

          return AnimatedContainer(
            duration: Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: isToday && color != null
                ? BoxDecoration(
                    color: color.withOpacity(isDark ? 0.22 : 0.16),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.18),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(day),
                    style: TextStyle(
                      color: isToday && color != null ? color : (isDark ? Colors.grey[300] : Colors.grey[700]),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  if (rate.taxaConversao != 0.0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'R\$ ${rate.taxaConversao.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isCheapest 
                            ? (isDark ? Color(0xFF69F0AE) : Color(0xFF1B5E20))
                            : (isToday && color != null ? color : (isDark ? Colors.white : Colors.black)),
                          fontSize: 11.5,
                          fontWeight: isCheapest ? FontWeight.bold : (isToday ? FontWeight.bold : FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// New CalendarViewPlaceholder widget
class CalendarViewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return TableCalendar(
      locale: locale,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Hide the "2 weeks" button
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                color: Colors.grey[300],
              ),
              SizedBox(height: 4),
              Container(
                width: 40,
                height: 10,
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
    );
  }
}