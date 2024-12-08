import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:card_cambio/features/home/widgets/mainchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:card_cambio/utils/rate_utils.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:shimmer/shimmer.dart';



class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RateProvider>(context);
    final rates = provider.rates;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: provider.hasFetchedEverything
              ? _getMainListView(rates, context)
              : _buildShimmer(),
        ),
      ),
    );
  }

  ListView _getMainListView(Map<String, List<Rate>> rates, BuildContext context) {
    final recentRates = getRecentRates(rates);
    final rateList = sortRatesByValue(recentRates);

    // Assign positions based on the sorted order
    final bankCards = _getBankCards(rateList);

    bankCards.add(BankCard(
      type: 'more banks soon',
    ));
    
    return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ranking', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text('Credit card usage rates by bank'),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: ListView(
                  cacheExtent: 1000,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: _getAnimatedCards(bankCards)
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Over time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200, maxHeight: 408),
                  child: MainChart(rates: rates),
                ),
              ),
              SizedBox(height: 20),
            ],
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

  List<BankCard> _getBankCards(List<MapEntry<String, Rate>> rateList) {
    final Map<String, String> bankLogos = {
      'nubank': 'nubank_logo.png',
      'itau': 'itau_logo.png',
      'c6': 'c6_logo.png',
    };

    final Map<String, String> bankNames = {
      'nubank': 'NuBank',
      'itau': 'Itaú',
      'c6': 'C6 Bank',
    };

    return rateList.asMap().entries.map((entry) {
      final position = entry.key + 1;
      final bankName = entry.value.key;
      final rate = entry.value.value;

      Color color;
      String trophyPosition;

      switch (position) {
        case 1:
          color = Color.fromARGB(255, 255, 176, 7);;
          trophyPosition = '1st';
        case 2:
          color = Color.fromARGB(255, 85, 85, 85);
          trophyPosition = '2nd';
        case 3:
          color = Color.fromARGB(255, 121, 60, 60);
          trophyPosition = '3rd';
        default:
          color = Colors.transparent;
          trophyPosition = '${position}th';
      }

      return BankCard(
        value: rate.taxaConversao,
        name: bankNames[bankName]!,
        logo: bankLogos[bankName]!,
        color: color,
        trophyPosition: trophyPosition,
      );
    }).toList();
  }

  Widget _buildShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 30,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 150.0,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}