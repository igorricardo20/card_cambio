import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
      body: Stack(
        children: [
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
                  position: _currentIndex,
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                if (_currentIndex == 2)
                  ElevatedButton(
                    onPressed: widget.onFinish,
                    child: Text('Finish'),
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