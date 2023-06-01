import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AllQuotesPage extends StatefulWidget {
  const AllQuotesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllQuotesPageState createState() => _AllQuotesPageState();
}

class _AllQuotesPageState extends State<AllQuotesPage> {
  List<dynamic> quotes = [];

  @override
  void initState() {
    super.initState();
    fetchAllQuotes();
  }

  Future<void> fetchAllQuotes() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://leehj050211.kro.kr/quote/all',
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
        title: const Text('All Quotes'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          final quoteContent = quote['quote_content'];
          final characterName = quote['character_name'];
          return ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(quoteContent),
            subtitle: Text(characterName),
          );
        },
      ),
    );
  }
}
