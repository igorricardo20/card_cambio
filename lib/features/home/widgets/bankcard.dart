import 'package:card_cambio/features/home/widgets/trophy.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankCard extends StatelessWidget {
  const BankCard({super.key, this.value=0.0, this.name='', this.logo='', this.color=Colors.black, this.trophyPosition='', this.type='bank'});

  final double value;
  final String name;
  final String logo;
  final Color color;
  final String trophyPosition;
  final String type;

  @override
  Widget build(BuildContext context) {
    bool hasTrohpy = trophyPosition.isNotEmpty;
    bool isBank = type == 'bank';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTrohpy ? Trophy(text: trophyPosition, color: color) : Container(),
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: SizedBox(
            width: 150,
            height: 100,
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: isBank ? _getCardBody(context, logo, name, value.toStringAsFixed(2), color) : _getSeeMoreBanks(context)
            ),
          ),
        ),
      ],
    );
  }

  InkWell _getCardBody(BuildContext context, String logo, String name, String value, Color color) {
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40, child: Image.asset('assets/images/$logo', width: 40)),
                      SizedBox(height: 10),
                      Text('R\$ $value', style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w700)),
                    ]
                  )
                ),
              ],
            ),
          ),
        ]
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
            'more banks', 
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.white : Colors.grey[700]
            )
          ),
          Text(
            'coming soon', 
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.white : Colors.grey[700]
            )
          ),
        ],
      ),
    );
  }
}