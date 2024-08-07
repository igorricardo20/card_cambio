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
    var list = json['historicoTaxas'] as List;
    List<Rate> historicoTaxasList = list.map((i) => Rate.fromJson(i)).toList();

    return ExchangeRateData(
      emissorNome: json['emissorNome'],
      emissorCnpj: json['emissorCnpj'],
      historicoTaxas: historicoTaxasList,
    );
  }
}