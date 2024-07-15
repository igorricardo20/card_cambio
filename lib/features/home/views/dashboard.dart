import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold =  Color.fromARGB(255, 255, 176, 7);
    const Color silver =  Color.fromARGB(255, 85, 85, 85);
    const Color bronze = Color.fromARGB(255, 121, 60, 60);
    
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Title(color: Colors.black, child: Text('Credit Card Ranking', style: TextStyle(fontSize: 30))),
              MaxGap(30),
              Text('Best institutions', style: TextStyle(fontSize: 20)),
              MaxGap(30),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 4,
                children: [
                  BankCard(value: 5, name: 'bankName', logo: 'nubank_logo.png', color: gold, rankingName: '1st'),
                  BankCard(value: 6, name: 'bankName', logo: 'itau_logo.png', color: silver, rankingName: '2nd'),
                  BankCard(value: 7, name: 'bankName', logo: 'btg_logo.png', color: bronze, rankingName: '3rd'),
                ]
              ),
              MaxGap(30),
            ],
          ),
        ],
      )
    );
  }
}