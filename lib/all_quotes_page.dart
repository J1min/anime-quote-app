// all_quotes_page.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:quote/main.dart';
import "quote_util.dart";

class AllQuoteListPage extends StatefulWidget {
  const AllQuoteListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllQuoteListPageState createState() => _AllQuoteListPageState();
}

class _AllQuoteListPageState extends State<AllQuoteListPage> {
  List<dynamic> quotes = [];
  int _currentIndex = 2;
  @override
  void initState() {
    super.initState();
    fetchAllQuotes();
  }

  Future<void> fetchAllQuotes() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://anime-quote.kro.kr/quote/all',
        options: Options(responseType: ResponseType.json),
      );
      final data = response.data['list'];
      setState(() {
        quotes = data;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모든 명언'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          final quoteContent = quote['quote_content'];
          final characterName = quote['character_name'];
          final quoteId = quote['quote_id'];
          return GestureDetector(
            onTap: () {
              navigateToQuotePage(context, quoteId);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(quoteContent),
              subtitle: Text(characterName),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchAllQuotes();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
