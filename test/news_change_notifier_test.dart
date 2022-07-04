import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_testing/article.dart';
import 'package:news_app_testing/news_change_notifier.dart';
import 'package:news_app_testing/news_service.dart';

// class BadMockNewService implements NewsService {
//  It is good for explaning not for implementation
//   bool getArticlesCalled = false;
//
//   @override
//   Future<List<Article>> getArticles() async {
//     getArticlesCalled = true;
//
//     return [
//       Article(title: "Test 1", content: "Test 1 Content"),
//       Article(title: "Test 2", content: "Test 2 Content"),
//       Article(title: "Test 3", content: "Test 3 Content"),
//     ];
//   }
// }

class MockNewService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut; //sut= system under test
  late MockNewService mockNewService;

  setUp(() {
    mockNewService = MockNewService();
    sut = NewsChangeNotifier(mockNewService);
  });

  test("initial values are correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group("Get Articles", () {
    final articlesFromService = [
      Article(title: "Test 1", content: "Test 1 Content"),
      Article(title: "Test 2", content: "Test 2 Content"),
      Article(title: "Test 3", content: "Test 3 Content"),
    ];

    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewService.getArticles()).thenAnswer(
        (invocation) async => articlesFromService,
      );
    }

    test("Gets articles using NewsService", () async {
      //aaa pattern
      //arrange
      // when(() => mockNewService.getArticles())
      //     .thenAnswer((invocation) async => []);
      arrangeNewsServiceReturns3Articles();

      //act
      await sut.getArticles();

      //assert
      verify(() => mockNewService.getArticles()).called(1);
    });

    test(
      """indicates loading of data,
       sets articles to the ones from the service,
       indicates that data is not being loaded anymore""",
      () async {
        //aaa pattern
        arrangeNewsServiceReturns3Articles(); //arrange

        //indicates loading of data
        final future = sut.getArticles(); //act
        expect(sut.isLoading, true); //assert
        await future;

        //sets articles to the ones from the service
        expect(sut.articles, articlesFromService);

        //indicates that data is not being loaded anymore
        expect(sut.isLoading, false);
      },
    );
  });
}
