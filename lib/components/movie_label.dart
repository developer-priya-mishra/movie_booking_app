import 'package:flutter/material.dart';

class MovieLabel extends StatelessWidget {
  final String label;
  const MovieLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Choose by\n"),
            TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
