import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isScreenWide = MediaQuery.of(context).size.width > 850;
    
    return Center(
      child: Column(
        children: [
          Title(color: Colors.black, child: Text('Credit Card Ranking', style: TextStyle(fontSize: 30))),
          Text('For Dollar exchange rates', style: TextStyle(fontSize: 20)),
          isScreenWide
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                getBankCards,
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getBankCards
            ),
        ],
      )
    );
  }

  List<Widget> get getBankCards {
    return <Widget>[
          _buildBankCard(value: 5, name: 'NuBank', logo: 'nubank_logo.png', color: const Color.fromARGB(255, 255, 176, 7)),
          _buildBankCard(value: 2, name: 'Itaú', logo: 'itau_logo.png', color: const Color.fromARGB(255, 85, 85, 85)),
          _buildBankCard(value: 3, name: 'Santander', logo: 'btg_logo.png', color: Color.fromARGB(255, 121, 60, 60))
        ];
  }
}

Widget _buildBankCard({required int value, required String name, required String logo, required Color color}) {
  return SizedBox(
            width: 250,
            height: 200,
            child: Card(
              clipBehavior: Clip.hardEdge,
              color: Colors.white,
              child: InkWell(
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
                                Text('R\$ $value,00', style: TextStyle(fontSize: 20, color: color))
                            ]
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.emoji_events, size: 30, color: color)
                          ),
                        ],
                      ),
                    ),                
                  ]
                ),
              )
            )
          );
}