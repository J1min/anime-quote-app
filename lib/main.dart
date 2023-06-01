import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String quoteContent = '';
  String characterName = '';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://leehj050211.kro.kr/quote',
        options: Options(responseType: ResponseType.json),
      );
      setState(() {
        quoteContent = response.data['quote']['quote_content'];
        characterName = response.data['quote']['character_name'];
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_currentIndex == 0 ? 'Random Anime Quote' : 'All Anime Quote'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 첫 번째 탭: 랜덤 보기
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
          // 두 번째 탭: 전체 보기
          AllQuotesPage(),
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

class AllQuotesPage extends StatefulWidget {
  const AllQuotesPage({Key? key}) : super(key: key);

  @override
  _AllQuotesPageState createState() => _AllQuotesPageState();
}

class _AllQuotesPageState extends State<AllQuotesPage> {
  List<String> quotes = [];

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
      final List<String> fetchedQuotes =
          List<String>.from(data.map((quote) => quote['quote_content']));
      setState(() {
        quotes = fetchedQuotes;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(quotes[index]),
        );
      },
    );
  }
}
