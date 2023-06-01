import 'package:flutter/material.dart';

class RandomQuotePage extends StatelessWidget {
  final String quoteContent;
  final String characterName;

  const RandomQuotePage({
    Key? key,
    required this.quoteContent,
    required this.characterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            print('tapped');
          },
          child: Text(
            quoteContent,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '- $characterName -',
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
