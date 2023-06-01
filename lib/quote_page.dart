import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotePage extends StatefulWidget {
  final int quoteId;

  const QuotePage({Key? key, required this.quoteId}) : super(key: key);

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  late SharedPreferences _prefs;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isFavorite = _prefs.getBool('quote_${widget.quoteId}') ?? false;
    setState(() {});
  }

  Future<Map<String, dynamic>> _fetchQuote(int id) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://anime-quote.kro.kr/quote/$id',
        options: Options(responseType: ResponseType.json),
      );
      return response.data['quote'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _toggleFavorite() async {
    final newValue = !_isFavorite;
    await _prefs.setBool('quote_${widget.quoteId}', newValue);
    setState(() {
      _isFavorite = newValue;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('링크가 복사되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Details'),
      ),
      body: FutureBuilder(
        future: _fetchQuote(widget.quoteId),
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
          final quoteLink = 'http://anime-quote.kro.kr/quote/${widget.quoteId}';
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
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    _copyToClipboard(quoteLink);
                  },
                  child: const Icon(Icons.share),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleFavorite,
                  child: Text(_isFavorite ? '즐겨찾기 해제' : '즐겨찾기 등록'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
