import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/config.dart';
import 'package:flutter_hacker_news/router/root_router.dart';
import 'package:flutter_hacker_news/widgets/hn_splash_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        backgroundColor: APP_BACKGROUND_COLOR,
        primaryColor: APP_PRIMARY_COLOR,
        accentColor: APP_ACCENT_COLOR,
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
      ),
      onGenerateRoute: generateRootRoute,
      home: Material(child: HNSplashWidget()),
    );
  }
}
