import 'package:card_cambio/features/home/widgets/bankcard.dart';
import 'package:card_cambio/features/home/widgets/mainchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';
import 'package:card_cambio/utils/rate_utils.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:card_cambio/features/home/widgets/buttoncard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RateProvider>(context);
    final rates = provider.rates;
    final shimmerColors = Theme.of(context).extension<ShimmerColors>()!;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: provider.hasFetchedEverything
              ? _getMainListView(rates, context)
              : _buildShimmer(shimmerColors),
        ),
      ),
    );
  }

  ListView _getMainListView(Map<String, List<Rate>> rates, BuildContext context) {
    final recentRates = getRecentRates(rates);
    final rateList = sortRatesByValue(recentRates);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // Assign positions based on the sorted order
    final bankCards = _getBankCards(rateList, isDark);

    bankCards.add(BankCard(
      type: AppLocalizations.of(context)!.more_banks_soon,
    ));
    
    return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.ranking, style: Theme.of(context).textTheme.headlineSmall),
                    Text(AppLocalizations.of(context)!.credit_card_usage_rates, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
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
                    Text(AppLocalizations.of(context)!.over_time, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200, maxHeight: 408),
                  child: MainChart(rates: rates),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.simulate, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ButtonCard(
                text: AppLocalizations.of(context)!.calculate_your_purchase,
                assetPath: "/images/coin-card.png",
              ),
              SizedBox(height: 30),
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

  List<BankCard> _getBankCards(List<MapEntry<String, Rate>> rateList, bool isDark) {
    final Map<String, String> bankLogos = {
      'nubank': 'nubank_logo.png',
      'itau': 'itau_logo.png',
      'c6': 'c6_logo.png',
    };

    final Map<String, String> bankNames = {
      'nubank': 'Nubank',
      'itau': 'Itaú',
      'c6': 'C6 Bank',
    };

    final Map<String, Color> bankColors = {
      'nubank': Colors.purple,
      'itau': Colors.orange,
      'c6': Colors.black,
    };

    return rateList.asMap().entries.map((entry) {
      final position = entry.key + 1;
      final bankName = entry.value.key;
      final rate = entry.value.value;

      String trophyPosition;
      Color trophyColor;

      switch (position) {
        case 1:
          trophyColor = isDark
              ? Color.fromARGB(255, 255, 215, 0)
              : Color.fromARGB(255, 255, 176, 7);
          trophyPosition = '1st';
        case 2:
          trophyColor = isDark
              ? Color.fromARGB(255, 169, 169, 169)
              : Color.fromARGB(255, 85, 85, 85);
          trophyPosition = '2nd';
        case 3:
          trophyColor = isDark
              ? Color.fromARGB(255, 205, 127, 50)
              : Color.fromARGB(255, 121, 60, 60);
          trophyPosition = '3rd';
        default:
          trophyColor = Colors.transparent;
          trophyPosition = '${position}th';
      }

      return BankCard(
        value: rate.taxaConversao,
        name: bankNames[bankName]!,
        logo: bankLogos[bankName]!,
        color: bankColors[bankName]!,
        trophyPosition: trophyPosition,
        trophyColor: trophyColor,
      );
    }).toList();
  }

  Widget _buildShimmer(ShimmerColors shimmerColors) {
  return Shimmer.fromColors(
    baseColor: shimmerColors.baseColor,
    highlightColor: shimmerColors.highlightColor,
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