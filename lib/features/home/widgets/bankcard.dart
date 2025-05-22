import 'package:card_cambio/features/home/widgets/trophy.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/l10n/app_localizations.dart';

class BankCard extends StatelessWidget {
  const BankCard({super.key, this.value=0.0, this.name='', this.logo='', this.color=Colors.black, this.trophyPosition='', this.trophyColor=Colors.black, this.type='bank', this.valueColor});

  final double value;
  final String name;
  final String logo;
  final Color color;
  final String trophyPosition;
  final Color trophyColor;
  final String type;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    bool hasTrohpy = trophyPosition.isNotEmpty;
    bool isBank = type == 'bank';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTrohpy
            ? Trophy(
                text: trophyPosition,
                color: trophyColor,
                // No fontSize/iconSize props, so we must update Trophy widget directly
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: SizedBox(
            width: 128, // Slightly narrower for a sleeker look
            height: 92, // Reduced height for a more compact card
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: isBank ? _getCardBody(context, logo, name, value.toStringAsFixed(2), color, valueColor: valueColor) : _getSeeMoreBanks(context)
            ),
          ),
        ),
      ],
    );
  }

  InkWell _getCardBody(BuildContext context, String logo, String name, String value, Color color, {Color? valueColor}) {
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Tighter padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0), // Add left padding to the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(name, style: TextStyle(fontSize: 12.5, color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w400)),
                  SizedBox(height: 2),
                  Text('R\$ $value', style: TextStyle(fontSize: 17, color: valueColor ?? Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w700)),
                  SizedBox(height: 7),
                  Container(
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _getSeeMoreBanks(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.more_banks, 
            style: TextStyle(
              fontSize: 12, 
              color: isDark ? Colors.white : Colors.grey[700]
            )
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.coming_soon, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12, 
                color: isDark ? Colors.white : Colors.grey[700]
              )
            ),
          ),
        ],
      ),
    );
  }
}