import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'invoice_list_widget.dart';

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
                await _selectFileToOpenDirectory(context);
              }),
        ),
      ),
    );
  }

  Future _selectFileToOpenDirectory(BuildContext context) async {
    final String path = await FilePicker.getFilePath(type: FileType.ANY);
    final File file = File(path);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return InvoiceListWidget(file.parent);
    }));
  }
}
