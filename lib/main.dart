import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'random_quote_page.dart';
import 'all_quotes_page.dart';
import 'favorite_quotes_page.dart';
import 'new_quote_page.dart';

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
  final CounterController counterController = Get.put(CounterController());

  CounterController get to => Get.find();

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
              title: const Text('랜덤 명언'),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          RandomQuotePage(
            quoteContent: quoteContent,
            characterName: characterName,
            quoteId: quoteId,
          ),
          const AllQuoteListPage(),
          const FavoriteQuotesPage(),
          NewQuotePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.shuffle),
              label: '랜덤 보기',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '전체 보기',
              backgroundColor: Colors.blue),
          // 즐겨찾기 아이콘 및 라벨
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '즐겨찾기',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.plus_one),
              label: '추가하기',
              backgroundColor: Colors.blue),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                fetchQuote();
                Get.find<CounterController>().increment();
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

class CounterController extends GetxController {
  RxInt count = 0.obs;

  void increment() {
    count.value = count.value + 1;
    print(count.value);
  }
}
