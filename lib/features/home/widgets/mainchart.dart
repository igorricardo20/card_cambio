import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MainChart extends StatelessWidget {
  const MainChart({super.key, required this.primaryColor, required this.secondaryColor});

  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {

    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.grey[100],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true, border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent, width: 1),
              left: BorderSide(color: Colors.transparent, width: 1),
              top: BorderSide(color: Colors.transparent, width: 1),
            )),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 1),
                  FlSpot(1, 2),
                  FlSpot(2, 1.5),
                ],
                isCurved: true,
                barWidth: 5,
                isStrokeCapRound: true,
                color: primaryColor,
                belowBarData: BarAreaData(show: false),
              ),
              LineChartBarData(
                spots: [
                  FlSpot(0, 2),
                  FlSpot(1, 3),
                  FlSpot(2, 2),
                ],
                isCurved: true,
                barWidth: 5,
                isStrokeCapRound: true,
                color: secondaryColor,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}