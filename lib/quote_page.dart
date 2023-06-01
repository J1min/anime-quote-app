import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class QuotePage extends StatelessWidget {
  final int quoteId;

  const QuotePage({Key? key, required this.quoteId}) : super(key: key);

  Future<Map<String, dynamic>> fetchQuote(int id) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://leehj050211.kro.kr/quote/$id',
        options: Options(responseType: ResponseType.json),
      );
      return response.data['quote'];
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Details'),
      ),
      body: FutureBuilder(
        future: fetchQuote(quoteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch quote details.'),
            );
          }
          final quote = snapshot.data as Map<String, dynamic>;
          final quoteContent = quote['quote_content'];
          final characterName = quote['character_name'];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  quoteContent,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
        },
      ),
    );
  }
}
