import 'package:card_cambio/features/home/model/exchangeratedata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeRateService {
  final String baseUrl = 'us-central1-card-cambio.cloudfunctions.net';
  final String endpoint = 'proxyRequest';

  //add headers to the request
  final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
  };

  Future<ExchangeRateData> fetchExchangeRates() async {
    final Uri uri = Uri.https(baseUrl, endpoint, {
      'url': 'https://dadosabertos.nubank.com.br/taxasCartoes/itens'
    });

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ExchangeRateData.fromJson(data);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}