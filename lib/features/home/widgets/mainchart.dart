import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:intl/intl.dart';

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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            dateFormat: DateFormat.MMMd(),
            intervalType: DateTimeIntervalType.days,
          ),
          primaryYAxis: NumericAxis(
            isVisible: true,
            // labelFormat: '\${value}',
            numberFormat: NumberFormat.currency(
              symbol: '\$', // Add your currency symbol
              decimalDigits: 2, // Always show 2 decimal places
            ),
            majorGridLines: const MajorGridLines(color: Colors.grey, width: 0.5),
            interval: 0.05,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.scroll,
          ),
          series: _getSeries(rates),
        ),
      ),
    );
  }

  List<SplineSeries<ChartData, DateTime>> _getSeries(Map<String, List<Rate>> rates) {
  if (rates.isEmpty) {
    return [];
  }

  final DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 8));

  final Map<String, Color> bankColors = {
      'nubank': Colors.purple,
      'itau': Colors.orange,
      'c6': Colors.black,
    };

  return rates.entries.map((entry) {
    final bankName = entry.key;
    final rateList = entry.value;

    final filteredData = rateList.where((rate) {
      final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
      return dateTime.isAfter(sevenDaysAgo);
    }).toList();

    final chartData = filteredData.map((rate) {
      final dateTime = DateTime.parse(rate.taxaDivulgacaoDataHora);
      return ChartData(dateTime, rate.taxaConversao);
    }).toList();

    final Color seriesColor = bankColors[bankName] ?? Colors.grey; // Fallback to grey

    return SplineSeries<ChartData, DateTime>(
      name: bankName,
      dataSource: chartData,
      xValueMapper: (ChartData data, _) => data.x,
      yValueMapper: (ChartData data, _) => data.y,
      color: seriesColor,
      width: 2,
      markerSettings: const MarkerSettings(isVisible: true),
      dataLabelSettings: const DataLabelSettings(isVisible: false),
    );
    }).toList();
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData(this.x, this.y);
}
