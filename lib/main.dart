import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:quote/quote_page.dart';
import 'random_quote_page.dart';
import 'all_quotes_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String quoteContent = '';
  String characterName = '';
  int quoteId = 0;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://anime-quote.kro.kr/quote',
        options: Options(responseType: ResponseType.json),
      );
      final data = response.data['quote'];
      setState(() {
        quoteContent = data['quote_content'];
        characterName = data['character_name'];
        quoteId = data['quote_id'];
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('Random Anime Quote'),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 첫 번째 탭: 랜덤 보기
          RandomQuotePage(
            quoteContent: quoteContent,
            characterName: characterName,
            quoteId: quoteId,
          ),
          // 두 번째 탭: 전체 보기
          const AllQuoteListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            label: '랜덤 보기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '전체 보기',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                fetchQuote();
              },
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
