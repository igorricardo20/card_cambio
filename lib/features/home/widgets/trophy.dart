import 'package:flutter/material.dart';

class Trophy extends StatelessWidget {
  const Trophy({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    bool isTransparent = color == Colors.transparent;

    return Padding(
      padding: EdgeInsets.only(left: isTransparent ? 0 : 11.0),
      child: Row(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.emoji_events, size: 20, color: color)
          ),
          Text(text, style: TextStyle(fontSize: 14, color: isTransparent ? Colors.grey[700] : color)),
        ],
      ),
    );
  }
}