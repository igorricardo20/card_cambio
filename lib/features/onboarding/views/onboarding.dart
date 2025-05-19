import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:card_cambio/l10n/app_localizations.dart';

class Onboarding extends StatefulWidget {
  final VoidCallback onFinish;

  Onboarding({required this.onFinish});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          if (isLargeScreen)
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 10) {
                  _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                } else if (details.delta.dx < -10) {
                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                }
              },
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  OnboardingPage(
                    title: AppLocalizations.of(context)!.credit_card_usage_rates,
                    description: AppLocalizations.of(context)!.credit_card_usage_rates_description,
                    image: Icons.credit_card,
                  ),
                  OnboardingPage(
                    title: AppLocalizations.of(context)!.cheapest_bank_rankings,
                    description: AppLocalizations.of(context)!.cheapest_bank_rankings_description,
                    image: Icons.bar_chart,
                  ),
                  OnboardingPage(
                    title: AppLocalizations.of(context)!.historical_comparisons,
                    description: AppLocalizations.of(context)!.historical_comparisons_description,
                    image: Icons.history,
                  ),
                ],
              ),
            )
          else
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingPage(
                  title: AppLocalizations.of(context)!.credit_card_usage_rates,
                  description: AppLocalizations.of(context)!.credit_card_usage_rates_description,
                  image: Icons.credit_card,
                ),
                OnboardingPage(
                  title: AppLocalizations.of(context)!.cheapest_bank_rankings,
                  description: AppLocalizations.of(context)!.cheapest_bank_rankings_description,
                  image: Icons.bar_chart,
                ),
                OnboardingPage(
                  title: AppLocalizations.of(context)!.historical_comparisons,
                  description: AppLocalizations.of(context)!.historical_comparisons_description,
                  image: Icons.history,
                ),
              ],
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                DotsIndicator(
                  dotsCount: 3,
                  position: _currentIndex.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                if (_currentIndex == 2)
                  Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: widget.onFinish,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        child: Text(
                          AppLocalizations.of(context)!.get_started,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 100, color: Theme.of(context).primaryColor),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}