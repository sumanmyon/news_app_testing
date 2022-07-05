import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_testing/article.dart';
import 'package:news_app_testing/news_change_notifier.dart';
import 'package:news_app_testing/news_page.dart';
import 'package:news_app_testing/news_service.dart';
import 'package:provider/provider.dart';

class MockNewService extends Mock implements NewsService {}

void main() {
  late MockNewService mockNewService;
  final articlesFromService = [
    Article(title: "Test 1", content: "Test 1 Content"),
    Article(title: "Test 2", content: "Test 2 Content"),
    Article(title: "Test 3", content: "Test 3 Content"),
  ];

  setUp(() {
    mockNewService = MockNewService();
  });

  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewService.getArticles()).thenAnswer(
      (invocation) async => articlesFromService,
    );
  }

  void arrangeNewsServiceReturns3ArticlesAfter2secLate() {
    when(() => mockNewService.getArticles()).thenAnswer(
      (invocation) {
        return Future.delayed(Duration(seconds: 2), () {
          return articlesFromService;
        });
      },
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewService),
        child: NewsPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      //tap, drag, rebuild,
      arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("News"), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed while waiting for articles",
    (WidgetTester tester) async {
      //tap, drag, rebuild,
      arrangeNewsServiceReturns3ArticlesAfter2secLate();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "articles are displayed",
    (WidgetTester tester) async {
      //tap, drag, rebuild
      arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      for(final article in articlesFromService){
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }
    },
  );
}
