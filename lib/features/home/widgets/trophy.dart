import 'package:flutter/material.dart';

class Trophy extends StatelessWidget {
  const Trophy({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.emoji_events, size: 30, color: color)
          ),
          Text(text, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }
}