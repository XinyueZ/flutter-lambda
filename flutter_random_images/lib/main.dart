import 'package:flutter/material.dart';

import 'image_app_splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lorem Picsum",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageAppSplash(),
    );
  }
}
