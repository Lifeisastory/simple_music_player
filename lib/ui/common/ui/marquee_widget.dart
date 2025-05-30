import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeWidget extends StatelessWidget {
  final String text;
  const MarqueeWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Marquee(
        text: text,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'heiti',
        ),
        blankSpace: 180,
        velocity: 50,
      );
}
