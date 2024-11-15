import 'package:card_cambio/features/home/model/rate.dart';

Map<String, Rate> getRecentRates(Map<String, List<Rate>> rates) {
  return rates.map((bankName, rateList) {
    final mostRecentRate = rateList.reduce((a, b) {
      final dateTimeA = DateTime.parse(a.taxaDivulgacaoDataHora);
      final dateTimeB = DateTime.parse(b.taxaDivulgacaoDataHora);
      return dateTimeA.isAfter(dateTimeB) ? a : b;
    });
    return MapEntry(bankName, mostRecentRate);
  });
}

List<MapEntry<String, Rate>> sortRatesByValue(Map<String, Rate> recentRates) {
  final rateList = recentRates.entries.toList()
    ..sort((a, b) => a.value.taxaConversao.compareTo(b.value.taxaConversao));
  return rateList;
}