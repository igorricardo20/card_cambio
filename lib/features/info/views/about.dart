import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Us', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Text', style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('More Text', style: TextStyle(fontSize: 20)),
                    Text('Text 1'),
                    Text('Text 2'),
                  ],
                ),
              ]
            ),
          ),
        )
      ),
    );
  }
}