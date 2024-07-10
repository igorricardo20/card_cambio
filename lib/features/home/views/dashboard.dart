import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isScreenWide = MediaQuery.of(context).size.width > 600;
    
    return Center(
      child: isScreenWide
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBankCard(rank: 1, name: 'NuBank', color: const Color.fromARGB(255, 255, 176, 7)),
            _buildBankCard(rank: 2, name: 'Itaú', color: Colors.grey),
            _buildBankCard(rank: 3, name: 'Santander', color: Color.fromARGB(255, 121, 60, 60))
          ]
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildBankCard(rank: 1, name: 'NuBank', color: Colors.amber),
            _buildBankCard(rank: 2, name: 'Itaú', color: Colors.grey),
            _buildBankCard(rank: 3, name: 'Santander', color: Color.fromARGB(255, 140, 124, 94))
          ]
        )
    );
  }
}

Widget _buildBankCard({required int rank, required String name, required Color color}) {
  return SizedBox(
            width: 300,
            height: 200,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text(name)),
                  Icon(Icons.emoji_events, size: 30, color: color),                
                ]
              )
            )
          );
}