import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:card_cambio/features/home/widgets/bankcard.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isScreenWide = MediaQuery.of(context).size.width > 850;
    
    return Center(
      child: Column(
        children: [
          Title(color: Colors.black, child: Text('Credit Card Ranking', style: TextStyle(fontSize: 30))),
          Text('For Dollar exchange rates', style: TextStyle(fontSize: 20)),
          isScreenWide
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                _getBankCards,
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _getBankCards
            ),
        ],
      )
    );
  }

  List<Widget> get _getBankCards {
    return <Widget>[
          BankCard(value: 5, name: 'NuBank', logo: 'nubank_logo.png', color: const Color.fromARGB(255, 255, 176, 7)),
          Gap(10),
          BankCard(value: 2, name: 'Itaú', logo: 'itau_logo.png', color: const Color.fromARGB(255, 85, 85, 85)),
          Gap(10),
          BankCard(value: 3, name: 'Santander', logo: 'btg_logo.png', color: Color.fromARGB(255, 121, 60, 60))
        ];
  }
}

