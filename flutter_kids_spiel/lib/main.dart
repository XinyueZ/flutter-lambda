import 'package:flutter/material.dart';

import 'map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids playground search',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        body: MapSample(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.my_location),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
    );
  }
}
