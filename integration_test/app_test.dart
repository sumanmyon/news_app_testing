import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_testing/article.dart';
import 'package:news_app_testing/article_page.dart';
import 'package:news_app_testing/news_change_notifier.dart';
import 'package:news_app_testing/news_page.dart';
import 'package:news_app_testing/news_service.dart';
import 'package:news_app_testing/pages/latest_posts/LatestPostPage.dart';
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
    "Tapping on first article expects open the article detail page and displays it.",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.text("Test 1 Content"));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);

      expect(find.text("Test 1"), findsOneWidget);
      expect(find.text("Test 1 Content"), findsOneWidget);
    },
  );

  testWidgets(
    "Tapping on Latest Post expects open the article detail page and displays it.",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byKey(Key("key-latest-posts")));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(LatestPostPage), findsOneWidget);

      expect(find.text("Latest Posts"), findsOneWidget);
      expect(find.text("All latest posts will display here"), findsOneWidget);

      expect(find.text("USA"), findsOneWidget);

      // Tap on the DropdownButton
      // https://github.com/flutter/flutter/issues/95384
      await tester.tap(find.byKey(Key("key-dropdown-button")));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      //get last item for testing due it find.text("Brazil") gets lists
      await tester.tap(find.text("Brazil").last);
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.text("Brazil"), findsOneWidget);
    },
  );
}
