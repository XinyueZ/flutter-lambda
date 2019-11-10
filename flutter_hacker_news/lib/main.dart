import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/config.dart';
import 'package:flutter_hacker_news/widgets/hn_content_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primaryColor: APP_PRIMARY_COLOR,
        accentColor: APP_ACCENT_COLOR,
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
      ),
      home: Material(
          color: APP_PRIMARY_COLOR,
          child: Scaffold(
            appBar: AppBar(
              title: Text(APP_NAME),
              backgroundColor: APP_PRIMARY_COLOR,
            ),
            body: HNContentWidget(),
          )),
    );
  }
}
