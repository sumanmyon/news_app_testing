import 'package:flutter/material.dart';
import 'package:news_app_testing/news_change_notifier.dart';
import 'package:news_app_testing/news_page.dart';
import 'package:news_app_testing/news_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(NewsService()),
        child: NewsPage(),
      ),
    );
  }
}
