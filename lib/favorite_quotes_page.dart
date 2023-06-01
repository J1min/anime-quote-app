// favorite_quote_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteQuotesPage extends StatefulWidget {
  const FavoriteQuotesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteQuotesPageState createState() => _FavoriteQuotesPageState();
}

class _FavoriteQuotesPageState extends State<FavoriteQuotesPage> {
  late SharedPreferences _prefs;
  List<int> _favoriteQuoteIds = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final keys = _prefs.getKeys();
    _favoriteQuoteIds = keys
        .where((key) => key.startsWith('quote_') && _prefs.getBool(key) == true)
        .map((key) => int.parse(key.split('_')[1]))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Quotes'),
      ),
      body: ListView.builder(
        itemCount: _favoriteQuoteIds.length,
        itemBuilder: (context, index) {
          final quoteId = _favoriteQuoteIds[index];
          return ListTile(
            title: Text('Quote ID: $quoteId'),
          );
        },
      ),
    );
  }
}
