import 'package:card_cambio/features/home/model/rate.dart';

class ExchangeRateData {
  final String emissorNome;
  final String emissorCnpj;
  final List<Rate> historicoTaxas;

  ExchangeRateData({
    required this.emissorNome,
    required this.emissorCnpj,
    required this.historicoTaxas,
  });

  factory ExchangeRateData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('itens')) {
      // Handle the nested structure
      var item = json['itens'][0];
      var list = item['historicoTaxas'] as List;
      List<Rate> historicoTaxasList = list.map((i) => Rate.fromJson(i)).toList();

      return ExchangeRateData(
        emissorNome: item['emissor']['emissorNome'],
        emissorCnpj: item['emissor']['emissorCnpj'],
        historicoTaxas: historicoTaxasList,
      );
    } else {
      // Handle the flat structure
      var list = json['historicoTaxas'] as List;
      List<Rate> historicoTaxasList = list.map((i) => Rate.fromJson(i)).toList();

      historicoTaxasList.sort((a, b) => b.taxaDivulgacaoDataHora.compareTo(a.taxaDivulgacaoDataHora));

      return ExchangeRateData(
        emissorNome: json['emissorNome'],
        emissorCnpj: json['emissorCnpj'],
        historicoTaxas: historicoTaxasList,
      );
    }
  }
}