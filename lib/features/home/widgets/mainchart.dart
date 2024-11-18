import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:card_cambio/features/home/model/rate.dart';

class MainChart extends StatelessWidget {
  final Map<String, List<Rate>> rates;
  

  const MainChart({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            isVisible: true,
          ),
          primaryYAxis: NumericAxis(
            isVisible: false,
          ),
          series: _getSeries(rates),
        ),
      ),
    );
  }

  List<CartesianSeries<ChartData, double>> _getSeries(Map<String, List<Rate>> rates) {
    // Create a series for each bank
    return rates.entries.map((entry) {
      final bankName = entry.key;
      final rateList = entry.value;
      final chartData = rateList.map((rate) {
        final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
        return ChartData(dateTime.millisecondsSinceEpoch.toDouble(), rate.taxaConversao);
      }).toList();

      return LineSeries<ChartData, double>(
        name: bankName,
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        width: 5,
        isVisibleInLegend: true,
        dataLabelSettings: DataLabelSettings(isVisible: false),
      );
    }).toList();
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}