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
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:card_cambio/features/home/widgets/buttoncard.dart';
import 'package:card_cambio/features/simulate/views/simulate.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RateProvider>(context);
    final rates = provider.rates;
    final shimmerColors = Theme.of(context).extension<ShimmerColors>()!;

    // Track fetching state for shimmer
    final ValueNotifier<bool> isFetching = ValueNotifier(false);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: ValueListenableBuilder<bool>(
              valueListenable: isFetching,
              builder: (context, fetching, _) {
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    isFetching.value = true;
                    await provider.fetchAllRates();
                    isFetching.value = false;
                  },
                  displacement: 36,
                  color: shimmerColors.baseColor.withOpacity(0.85), // Harmonize with shimmer
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  strokeWidth: 2.4,
                  notificationPredicate: (notification) => notification.depth == 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutExpo,
                    switchOutCurve: Curves.easeInExpo,
                    transitionBuilder: (child, animation) {
                      final fade = FadeTransition(opacity: animation, child: child);
                      final scale = ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation), child: fade);
                      return scale;
                    },
                    child: fetching || !provider.hasFetchedEverything
                        ? _buildShimmer(shimmerColors, context)
                        : _getMainListView(rates, context),
                  ),
                );
              },
            ),
          ),
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

    // bankCards.add(BankCard(
    //   type: AppLocalizations.of(context)!.more_banks_soon,
    // ));
    
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
          height: 130,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.over_time, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(width: 10),
                  Icon(Icons.emoji_events, size: 13, color: Colors.amber),
                  SizedBox(width: 6),
                  Text(
                    'Top 3 only',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 9.6,
                      color: Colors.amber[800],
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200, maxHeight: 306),
            child: MainChart(
              rates: Map.fromEntries(
                rateList.take(3).map((entry) => MapEntry(entry.key, rates[entry.key]!)),
              ),
            ),
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
          assetPath: "assets/images/coin-card.png",
          page: Simulate(),
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
      'bb': 'itau_logo.png', // TEMP: Use itau_logo.png as placeholder for Banco do Brasil
      'caixa': 'nubank_logo.png', // TEMP: Use nubank_logo.png as placeholder for Caixa
      'safra': 'nubank_logo.png', // TEMP: Use nubank_logo.png as placeholder for Safra
    };

    final Map<String, String> bankNames = {
      'nubank': 'Nubank',
      'itau': 'Itaú',
      'c6': 'C6 Bank',
      'bb': 'Banco do Brasil',
      'caixa': 'Caixa',
      'safra': 'Safra',
    };

    final Map<String, Color> bankColors = {
      'nubank': Colors.purple,
      'itau': Colors.orange,
      'c6': Colors.black,
      'bb': Color(0xFFFFCC29),
      'caixa': Color(0xFF005CA9), // Caixa blue
      'safra': Color(0xFF2B2D42), // Safra deep blue
    };

    // --- VALUE COLOR LOGIC ---
    // Simulate's best: dark green, others: gold. If tie, all lowest get green.
    final double minValue = rateList.isNotEmpty ? rateList.first.value.taxaConversao : 0.0;
    final bool allTied = rateList.where((e) => e.value.taxaConversao == minValue).length > 1;
    final Color bestGreen = isDark ? const Color(0xFF4BE07B) : const Color(0xFF2EAD5B);
    final Color gold = isDark ? const Color(0xFFD1B97A) : const Color(0xFF5C4715);

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

      // Value color logic
      Color? valueColor;
      Widget? valuePrefix;
      if (rate.taxaConversao == minValue && minValue > 0) {
        valueColor = gold;
        if (position == 1) {
          valuePrefix = Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: bestGreen,
              size: 18,
            ),
          );
        }
      } else if (allTied && minValue > 0) {
        valueColor = bestGreen;
      } else {
        valueColor = gold;
      }

      return BankCard(
        value: rate.taxaConversao,
        name: bankNames[bankName]!,
        logo: bankLogos[bankName]!,
        color: bankColors[bankName]!,
        trophyPosition: trophyPosition,
        trophyColor: trophyColor,
        valueColor: valueColor,
        valuePrefix: valuePrefix,
        // Optionally, you can pass a width or size parameter if BankCard supports it
      );
    }).toList();
  }

  Widget _buildShimmer(ShimmerColors shimmerColors, BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Shimmer.fromColors(
      baseColor: shimmerColors.baseColor,
      highlightColor: shimmerColors.highlightColor,
      period: reduceMotion ? const Duration(milliseconds: 1200) : const Duration(milliseconds: 700),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: shimmerColors.baseColor.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Subtitle shimmer
                Container(
                  width: 250,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: shimmerColors.baseColor.withOpacity(0.06),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Horizontal cards shimmer
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => Container(
                      width: 110,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: shimmerColors.baseColor.withOpacity(0.10),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Chart shimmer
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: shimmerColors.baseColor.withOpacity(0.09),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Simulate button shimmer
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  width: 220,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: shimmerColors.baseColor.withOpacity(0.07),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}