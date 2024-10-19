import 'package:flutter/material.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/features/home/service/exchangerateservice.dart';

class RateProvider with ChangeNotifier {
  Map<String, List<Rate>> _rates = {};

  Map<String, List<Rate>> get rates => _rates;

  Future<void> fetchAllRates() async {
    final banks = ['nubank', 'itau', 'c6'];
    for (var bank in banks) {
      final data = await ExchangeRateService().fetchExchangeRatesForBank(bank);
      _rates[bank] = data.historicoTaxas;
      notifyListeners();
    }
  }

  bool get hasData => _rates.isNotEmpty;
}