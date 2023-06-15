import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quote/main.dart';
import 'package:quote/quote_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteQuotesPage extends StatefulWidget {
  const FavoriteQuotesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteQuotesPageState createState() => _FavoriteQuotesPageState();
}

class _FavoriteQuotesPageState extends State<FavoriteQuotesPage> {
  final dio = Dio();
  late SharedPreferences _prefs;
  List<Map<String, dynamic>> _favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _updateFavoriteQuotes();
  }

  Future<void> _updateFavoriteQuotes() async {
    final keys = _prefs.getKeys();
    _favoriteQuotes = [];
    for (final key in keys) {
      if (key.startsWith('quote_') && _prefs.getBool(key) == true) {
        final quoteId = int.parse(key.split('_')[1]);
        final quote = await fetchQuote(quoteId);
        final quoteData = {
          'quoteId': quoteId,
          'quoteContent': quote['quote_content'],
          'characterName': quote['character_name']
        };
        _favoriteQuotes.add(quoteData);
      }
    }
    setState(() {});
  }

  Future<Map<String, dynamic>> fetchQuote(int id) async {
    final response = await dio.get(
      'http://anime-quote.kro.kr/quote/$id',
      options: Options(responseType: ResponseType.json),
    );
    return response.data['quote'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CounterController().count.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateFavoriteQuotes,
        child: const Icon(Icons.refresh),
      ),
      body: ListView.builder(
        itemCount: _favoriteQuotes.length,
        itemBuilder: (context, index) {
          final quote = _favoriteQuotes[index];
          final quoteId = quote['quoteId'];
          final quoteContent = quote['quoteContent'];
          final characterName = quote['characterName'];
          return GestureDetector(
            onTap: () {
              navigateToQuotePage(context, quoteId);
            },
            child: ListTile(
              title: Text(quoteContent),
              subtitle: Text('- $characterName -'),
            ),
          );
        },
      ),
    );
  }
}
