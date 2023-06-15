import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NewQuotePage extends StatelessWidget {
  NewQuotePage({super.key});

  final TextEditingController quoteContentController = TextEditingController();
  final TextEditingController characterNameController = TextEditingController();

  Future<void> addNewQuote(String quoteContent, String characterName) async {
    final dio = Dio();
    final quoteData = {
      "quote_content": quoteContent,
      "character_name": characterName,
    };

    try {
      await dio.post(
        'http://anime-quote.kro.kr/quote',
        options: Options(responseType: ResponseType.json),
        data: quoteData,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quote'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: quoteContentController,
              decoration: const InputDecoration(
                labelText: 'Quote Content',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: characterNameController,
              decoration: const InputDecoration(
                labelText: 'Character Name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final quoteContent = quoteContentController.text;
                final characterName = characterNameController.text;
                addNewQuote(quoteContent, characterName);
              },
              child: const Text('Add Quote'),
            ),
          ],
        ),
      ),
    );
  }
}
