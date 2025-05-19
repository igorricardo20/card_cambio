import 'package:flutter/material.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/features/home/service/exchangerateservice.dart';

class RateProvider with ChangeNotifier {
  Map<String, List<Rate>> _rates = {};

  Map<String, List<Rate>> get rates => _rates;

  List<String> get banks => ['nubank', 'itau', 'c6', 'bb'];

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
      _rates[bank] = uniqueRates;
    }).toList();

    await Future.wait(futures);
    notifyListeners();
  }

  bool get hasData => _rates.isNotEmpty;

  bool get hasFetchedEverything => _rates.length == banks.length;
}