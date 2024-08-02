import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:card_cambio/features/home/widgets/mainchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold =  Color.fromARGB(255, 255, 176, 7);
    const Color silver =  Color.fromARGB(255, 85, 85, 85);
    const Color bronze = Color.fromARGB(255, 121, 60, 60);

    final bool isSmallScreen = MediaQuery.sizeOf(context).height < 800;

    final bankCards = [
      BankCard(value: 5, name: 'bankName', logo: 'nubank_logo.png', color: gold, trophyPosition: '1st'),
      BankCard(value: 6, name: 'bankName', logo: 'itau_logo.png', color: silver, trophyPosition: '2nd'),
      BankCard(value: 7, name: 'bankName', logo: 'btg_logo.png', color: bronze, trophyPosition: '3rd'),
      BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.transparent, trophyPosition: '4th'),
      BankCard(value: 7.5, name: 'bankName', logo: 'btg_logo.png', color: Colors.transparent, trophyPosition: '5th'),
      BankCard(type:'more'),
    ];
    
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ranking', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Credit card usage rates by bank'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 170,
                child: ListView(
                  cacheExtent: 1000,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: _getAnimatedCards(bankCards)
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
                padding: EdgeInsets.only(left: 12.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200, maxHeight: isSmallScreen ? 200 : 320),
                  child: MainChart(primaryColor: Colors.orange, secondaryColor: Color.fromARGB(255, 131, 3, 210))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getAnimatedCards(List<BankCard> bankCards) {
    return [
      for (int i = 0; i < bankCards.length; i++)
        Animate(
          effects: [
            SlideEffect(
              begin: Offset(1, 0),
              end: Offset(0, 0),
              duration: Duration(milliseconds: 220),
              delay: Duration(milliseconds: i * 120),
            ),
            FadeEffect(
              duration: Duration(milliseconds: 220),
              delay: Duration(milliseconds: i * 120),
            )
          ],
          child: bankCards[i]
      ),
    ];
  }
}