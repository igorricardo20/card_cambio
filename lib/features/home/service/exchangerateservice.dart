import 'package:card_cambio/features/home/model/exchangeratedata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRateService {
  final Uri uri = Uri.https('dadosabertos.nubank.com.br', 'taxasCartoes/itens'); 

  //add headers to the request
  final Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
  };

  Future<ExchangeRateData> fetchExchangeRates() async {
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ExchangeRateData.fromJson(data);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}