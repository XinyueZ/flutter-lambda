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
        backgroundColor: APP_BACKGROUND_COLOR,
        primaryColor: APP_PRIMARY_COLOR,
        accentColor: APP_ACCENT_COLOR,
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
      ),
      home: Material(
          child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/logo/hn_flutter.png'),
              onPressed: () {},
            );
          }),
          title: Text(
            APP_NAME,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: APP_PRIMARY_COLOR,
        ),
        body: HNContentWidget(),
      )),
    );
  }
}
