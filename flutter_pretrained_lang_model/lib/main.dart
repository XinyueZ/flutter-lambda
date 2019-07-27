import 'package:flutter/material.dart';

import 'config.dart';
import 'invoices_location_picker_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initSupportedLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MAIN_COLOR,
        accentColor: MAIN_COLOR,
        primarySwatch: Colors.blue,
      ),
      home: InvoicesLocationPickerWidget(),
    );
  }
}
