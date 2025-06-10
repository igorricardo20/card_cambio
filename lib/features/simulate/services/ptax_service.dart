import 'dart:convert';
import 'package:http/http.dart' as http;

class PtaxService {
  Future<double?> fetchCurrentPtax(DateTime date) async {
    final formattedDate = '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}';
    final url = "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)?@dataCotacao='$formattedDate'&\$top=100&\$format=json";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['value'] != null && data['value'].isNotEmpty) {
        return (data['value'][0]['cotacaoVenda'] as num).toDouble();
      }
    }
    return null;
  }
}
