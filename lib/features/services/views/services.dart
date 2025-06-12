import 'package:card_cambio/features/faq/views/faq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:card_cambio/features/simulate/views/simulate.dart';
import 'package:card_cambio/features/services/views/vitrine_card.dart';
import 'package:card_cambio/features/compare/views/compare.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.services_title, style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Fix: Wrap GridView.count in a SizedBox and set shrinkWrap/physics
              SizedBox(
                height: MediaQuery.of(context).size.width < 700 ? 700 : 1000, // Responsive grid height for mobile
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    VitrineCard(
                      icon: Icons.calculate_outlined,
                      title: AppLocalizations.of(context)!.simulate_title,
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => Simulate()),
                        );
                      },
                    ),
                    VitrineCard(
                      icon: Icons.notifications_active_outlined,
                      title: AppLocalizations.of(context)!.alerts_title,
                      onTap: () {}, // TODO: Implement currency converter page
                    ),
                    VitrineCard(
                      icon: Icons.compare_arrows_outlined,
                      title: AppLocalizations.of(context)!.compare_title,
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => const Compare()),
                        );
                      },
                    ),
                    VitrineCard(
                      icon: Icons.auto_graph_outlined,
                      title: 'Insights',
                      iconColor: Colors.deepPurple,
                      badge: 'New',
                      glowOnce: true,
                      onTap: () {}, // TODO: Implement AI insights feature
                      // glowMargin: EdgeInsets.zero, // Remove any margin or padding around the glow effect
                    ),
                    VitrineCard(
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.faq_help_title,
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => const Faq()),
                        );
                      },
                    ),
                    VitrineCard(
                      icon: Icons.support_agent_outlined,
                      title: AppLocalizations.of(context)!.contact_support_title,
                      onTap: () {}, // TODO: Implement contact support
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
