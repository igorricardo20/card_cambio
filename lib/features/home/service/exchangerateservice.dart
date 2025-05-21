import 'package:card_cambio/features/home/model/exchangeratedata.dart';
import 'package:card_cambio/features/home/model/rate.dart';
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
      ExchangeRateData data = handleResponse(response.body);
      // Special handling for 'bb' date format
      if (value == 'bb') {
        data = _formatBbDatesInExchangeRateData(data);
      }
      return data;
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
    case 'bb':
      return 'api-dadosabertos-ws.bb.com.br/dadosabertos/v1/taxasCartoes/itens';
    case 'c6':
      return 'dadosabertos-p.c6bank.info/cartao/taxasCartoes/itens';
    case 'caixa':
      return 'api.caixa.gov.br:8443/dadosabertos/taxasCartoes/1.2.0/itens';
    case 'safra':
      return 'safra.com.br/dadosabertos/taxascartoes/itens';
    default:
      return 'dadosabertos.nubank.com.br';
  }
}

// Helper to reformat BB date fields in all Rate objects
ExchangeRateData _formatBbDatesInExchangeRateData(ExchangeRateData data) {
  List<Rate> updatedRates = data.historicoTaxas.map((rate) {
    if (rate.taxaDivulgacaoDataHora.contains('-') &&
        !rate.taxaDivulgacaoDataHora.contains('T')) {
      // Example: "2025-05-16-20.00.33.089890"
      final parts = rate.taxaDivulgacaoDataHora.split('-');
      if (parts.length >= 4) {
        final datePart = parts.sublist(0, 3).join('-');
        final timePart = parts[3].replaceAll('.', ':');
        final timeParts = timePart.split(':');
        String formattedTime = '';
        if (timeParts.length >= 3) {
          formattedTime = '${timeParts[0]}:${timeParts[1]}:${timeParts[2].split('.')[0]}';
        }
        final isoString = '${datePart}T$formattedTime.000Z';
        return Rate(
          taxaTipoGasto: rate.taxaTipoGasto,
          taxaData: rate.taxaData,
          taxaConversao: rate.taxaConversao,
          taxaDivulgacaoDataHora: isoString,
        );
      }
    }
    return rate;
  }).toList();
  return ExchangeRateData(
    emissorNome: data.emissorNome,
    emissorCnpj: data.emissorCnpj,
    historicoTaxas: updatedRates,
  );
}