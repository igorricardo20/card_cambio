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
    return fetchExchangeRatesForBank('nubank');
  }

  Future<ExchangeRateData> fetchExchangeRatesForBank(String? value) async {
    final String bankHost = _getHost(value);

    final Uri uri = Uri.https(baseUrl, endpoint, {
      'url': 'https://$bankHost'
    });

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return handleResponse(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}

ExchangeRateData handleResponse(String responseBody) {
  final dynamic decodedJson = json.decode(responseBody);

  if (decodedJson is List) {
    // Handle the JSON structure with 'itens'
    final List<dynamic> dataList = decodedJson;
    final Map<String, dynamic> firstItem = dataList[0];
    return ExchangeRateData.fromJson(firstItem);
  } else if (decodedJson is Map<String, dynamic>) {
    // Handle the flat JSON structure
    final Map<String, dynamic> data = decodedJson;
    return ExchangeRateData.fromJson(data);
  } else {
    throw Exception('Unexpected JSON structure');
  }
}

String _getHost(String? value) {
  switch (value) {
    case 'nubank':
      return 'dadosabertos.nubank.com.br/taxasCartoes/itens';
    case 'itau':
      return 'api.itau.com.br/dadosabertos/taxasCartoes/taxas/itens';
    case 'bradesco':
      return 'openapi.bradesco.com.br/bradesco/dadosabertos';
    case 'c6':
      return 'dadosabertos-p.c6bank.info/cartao/taxasCartoes/itens';
    default:
      return 'dadosabertos.nubank.com.br';
  }
}