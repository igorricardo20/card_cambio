import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:card_cambio/features/simulate/views/simulate.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.services_title,
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 14),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: [
                      _VitrineCard(
                        icon: Icons.calculate_outlined,
                        title: localizations.simulate_title,
                        onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => Simulate()),
                        ),
                      ),
                      _VitrineCard(
                        icon: Icons.notifications_active_outlined,
                        title: localizations.alerts_title,
                        onTap: () => Navigator.of(context).pushNamed('/alerts'),
                      ),
                      _VitrineCard(
                        icon: Icons.more_horiz_outlined,
                        title: localizations.more_services_title,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VitrineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _VitrineCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.cardColor.withOpacity(0.9),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(icon, size: 28, color: Colors.black),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 2, right: 8),
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
