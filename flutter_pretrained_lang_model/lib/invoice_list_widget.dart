import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'bill_list_widget.dart';

class InvoiceListWidget extends StatefulWidget {
  final Directory _billDirectory;

  InvoiceListWidget(this._billDirectory);

  @override
  _InvoiceListWidgetState createState() => _InvoiceListWidgetState();
}

class _InvoiceListWidgetState extends State<InvoiceListWidget> {
  List<FileSystemEntity> _fileList;

  @override
  void initState() {
    this.loadDirectoryFiles();
    super.initState();
  }

  loadDirectoryFiles() async {
    setState(() {
      _fileList = widget._billDirectory.listSync().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return BillListWidget(widget._billDirectory);
            }));
          }),
      appBar: AppBar(
        title: Text("INVOICES"),
      ),
      body: ListView.builder(
        itemCount: _fileList == null ? 0 : _fileList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(basename(_fileList[index].path),
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
