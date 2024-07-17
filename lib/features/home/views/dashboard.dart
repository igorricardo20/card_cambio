import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold =  Color.fromARGB(255, 255, 176, 7);
    const Color silver =  Color.fromARGB(255, 85, 85, 85);
    const Color bronze = Color.fromARGB(255, 121, 60, 60);
    
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ranking', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Text('Credit card usage', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          MaxGap(20),
          SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                BankCard(value: 5, name: 'bankName', logo: 'nubank_logo.png', color: gold, trophyPosition: '1st'),
                BankCard(value: 6, name: 'bankName', logo: 'itau_logo.png', color: silver, trophyPosition: '2nd'),
                BankCard(value: 7, name: 'bankName', logo: 'btg_logo.png', color: bronze, trophyPosition: '3rd'),
                BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.black),
                BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.black),
                BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.black),
                BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.black),
                BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.black),
              ]
            ),
          ),
          MaxGap(50),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Over time', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          MaxGap(40),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
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
                    color: gold,
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
                    color: silver,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}