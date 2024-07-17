import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MainChart extends StatelessWidget {
  const MainChart({super.key, required this.primaryColor, required this.secondaryColor});

  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 800;
    final bool isVerySmallScreen = MediaQuery.of(context).size.height < 550;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: isVerySmallScreen ? 150 : isSmallScreen ? 200 : 300, maxWidth: 1200),
      child: LineChart(
        LineChartData(
          // gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            right: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide(color: Colors.transparent, width: 1),
            top: BorderSide(color: Colors.transparent, width: 1),
          )),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 2),
                FlSpot(2, 1.5),
                FlSpot(3, 3),
                FlSpot(4, 2),
                FlSpot(5, 2.5),
                FlSpot(6, 2.0),
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
                FlSpot(2, 1.5),
                FlSpot(3, 3),
                FlSpot(4, 1),
                FlSpot(5, 2),
                FlSpot(6, 1),
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
    );
  }
}