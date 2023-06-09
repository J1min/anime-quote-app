// random_quote_page.dart

import 'package:flutter/material.dart';
import 'package:quote/quote_util.dart';

class RandomQuotePage extends StatelessWidget {
  final String quoteContent;
  final String characterName;
  final int quoteId;

  const RandomQuotePage({
    Key? key,
    required this.quoteContent,
    required this.characterName,
    required this.quoteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              navigateToQuotePage(context, quoteId);
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
      ),
    );
  }
}
