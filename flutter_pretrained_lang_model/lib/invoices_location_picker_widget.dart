import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

import 'config.dart';

class InvoicesLocationPickerWidget extends StatefulWidget {
  InvoicesLocationPickerWidget({Key key}) : super(key: key);

  @override
  _InvoicesLocationPickerWidgetState createState() =>
      _InvoicesLocationPickerWidgetState();
}

class _InvoicesLocationPickerWidgetState
    extends State<InvoicesLocationPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          elevation: 15,
          title: Text("MOIA INVOICE"),
        ),
        body: Center(
          child: RaisedButton(
              color: Colors.amberAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.folder_open),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Open INVOICE directory",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              onPressed: () async {
                final String file = await FlutterDocumentPicker.openDocument();
                debugPrint("file: $file");
              }),
        ),
      ),
    );
  }
}
