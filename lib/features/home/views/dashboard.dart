import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:card_cambio/features/home/widgets/mainchart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold =  Color.fromARGB(255, 255, 176, 7);
    const Color silver =  Color.fromARGB(255, 85, 85, 85);
    const Color bronze = Color.fromARGB(255, 121, 60, 60);

    final bool isScreenBelow1800 = MediaQuery.of(context).size.width < 1800;
    final bool isSmallScreen = MediaQuery.of(context).size.height < 800;
    
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 20),
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
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Over time', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: isScreenBelow1800 ? 0.0 : MediaQuery.of(context).size.width / 3),
            child: SizedBox(
              height: isSmallScreen ? 200 : 300,
              child: MainChart(primaryColor: Color.fromARGB(255, 131, 3, 210), secondaryColor: Colors.orange)),
          ),
        ],
      ),
    );
  }
}