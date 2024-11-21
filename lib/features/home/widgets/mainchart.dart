import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:intl/intl.dart';

class MainChart extends StatefulWidget {
  final Map<String, List<Rate>> rates;

  const MainChart({
    super.key,
    required this.rates,
  });

  @override
  MainChartState createState() => MainChartState();
}

class MainChartState extends State<MainChart> {
  int selectedDays = 8;
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    _disableAnimationAfterDelay(); // Automatically disable animation
  }

  void _disableAnimationAfterDelay() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle Buttons
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildToggleButton('1 week', 8),
              const SizedBox(width: 8),
              _buildToggleButton('2 weeks', 16),
              const SizedBox(width: 8),
              _buildToggleButton('Max.', 60),
            ],
          ),
        ),
        Card(
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
                numberFormat: NumberFormat.currency(
                  symbol: 'R\$ ', // Add your currency symbol
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
              series: _getSeries(widget.rates),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, int days) {
  final bool isSelected = selectedDays == days;
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedDays = days;
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.amber[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500, // Medium weight for better readability
        ),
      ),
    ),
  );
}

  List<SplineSeries<ChartData, DateTime>> _getSeries(Map<String, List<Rate>> rates) {
    if (rates.isEmpty) {
      return [];
    }

    final DateTime rangeStart = DateTime.now().subtract(Duration(days: selectedDays));

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
        return dateTime.isAfter(rangeStart);
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
        enableTooltip: true,
        animationDuration: showAnimation ? 1000 : 0,
        markerSettings: MarkerSettings(
          isVisible: selectedDays > 0 && selectedDays <= 8,
          color: seriesColor,
        ),
        // markerSettings: const MarkerSettings(isVisible: true),
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
