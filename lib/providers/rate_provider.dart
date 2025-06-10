import 'package:flutter/material.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/features/home/service/exchangerateservice.dart';

class RateProvider with ChangeNotifier {
  Map<String, List<Rate>> _rates = {};

  Map<String, List<Rate>> get rates => _rates;

  List<String> get banks => ['nubank', 'itau', 'c6', 'bb', 'caixa', 'safra'];

  Future<void> fetchAllRates() async {
    final futures = banks.map((bank) async {
      final data = await ExchangeRateService().fetchExchangeRatesForBank(bank);
      // Filter for "Crédito" for all banks and remove rates with invalid date
      final filtered = data.historicoTaxas
        .where((rate) => rate.taxaTipoGasto == 'Crédito')
        .toList();
      // Remove duplicates based on taxaDivulgacaoDataHora
      final seen = <String>{};
      final uniqueRates = filtered.where((rate) => seen.add(rate.taxaDivulgacaoDataHora)).toList();
      // Fill missing days with previous day's rate
      final filledRates = _fillMissingDays(uniqueRates);
      _rates[bank] = filledRates;
    }).toList();

    await Future.wait(futures);
    notifyListeners();
  }

  List<Rate> _fillMissingDays(List<Rate> rates) {
    if (rates.isEmpty) return rates;
    // Sort rates by date ascending
    rates.sort((a, b) => a.taxaDivulgacaoDataHora.compareTo(b.taxaDivulgacaoDataHora));
    final result = <Rate>[];
    DateTime? prevDate;
    Rate? prevRate;
    for (final rate in rates) {
      final date = DateTime.parse(rate.taxaDivulgacaoDataHora);
      if (prevDate != null) {
        var nextDate = prevDate.add(const Duration(days: 1));
        while (nextDate.isBefore(date)) {
          // Only fill if missing day (no entry for that date) or if the rate is null/zero
          // Check if there is a rate for this date and if its taxaConversao is null or zero
          final existing = rates.firstWhere(
            (r) => DateTime.parse(r.taxaDivulgacaoDataHora).year == nextDate.year &&
                   DateTime.parse(r.taxaDivulgacaoDataHora).month == nextDate.month &&
                   DateTime.parse(r.taxaDivulgacaoDataHora).day == nextDate.day,
            orElse: () => Rate.blank(),
          );
          if (existing.taxaConversao == 0.0) {
            if (prevRate != null) {
              result.add(prevRate.copyWith(taxaDivulgacaoDataHora: nextDate.toIso8601String()));
            }
          }
          nextDate = nextDate.add(const Duration(days: 1));
        }
      }
      result.add(rate);
      prevDate = date;
      prevRate = rate;
    }
    return result;
  }

  bool get hasData => _rates.isNotEmpty;

  bool get hasFetchedEverything => _rates.length == banks.length;
}