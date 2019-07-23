import 'package:flutter/material.dart';

import 'config.dart';
import 'invoices_location_picker_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MAIN_COLOR,
        primarySwatch: Colors.blue,
      ),
      home: InvoicesLocationPickerWidget(),
    );
  }
}
