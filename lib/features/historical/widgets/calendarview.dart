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

  CalendarView(this.rates);

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
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
          final rate = rates.firstWhere(
            (rate) => DateFormat('yyyy-MM-dd').format(DateTime.parse(rate.taxaDivulgacaoDataHora)) == DateFormat('yyyy-MM-dd').format(day),
            orElse: () => Rate.blank(),
          );
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d').format(day),
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                rate.taxaConversao != 0.0 ? 'R\$ ${rate.taxaConversao.toStringAsFixed(2)}' : '',
                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 11),
              ),
            ],
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