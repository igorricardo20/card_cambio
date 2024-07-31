import 'package:card_cambio/features/home/widgets/trophy.dart';
import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  const BankCard({super.key, required this.value, required this.name, required this.logo, required this.color, this.trophyPosition=''});

  final double value;
  final String name;
  final String logo;
  final Color color;
  final String trophyPosition;

  @override
  Widget build(BuildContext context) {
    bool hasTrohpy = trophyPosition.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTrohpy ? Trophy(text: trophyPosition, color: color) : Container(),
        SizedBox(
          width: 150,
          height: 150,
          child: Card(
            clipBehavior: Clip.hardEdge,
            color: Color.fromARGB(255, 250, 243, 242),
            child: _getCardBody(logo, name, value, color)
          ),
        ),
      ],
    );
  }

  InkWell _getCardBody(String logo, String name, double value, Color color) {
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
                      SizedBox(height: 80, child: Image.asset('assets/images/$logo', width: 80)),
                      Text(name),
                      Text('R\$ $value', style: TextStyle(fontSize: 20, color: color))
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
}