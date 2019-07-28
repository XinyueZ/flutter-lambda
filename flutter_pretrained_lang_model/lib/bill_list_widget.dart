import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class BillListWidget extends StatefulWidget {
  final Directory _billFileDirectory;
  final List<File> _invoiceFileList;

  BillListWidget(this._billFileDirectory, this._invoiceFileList);

  @override
  _BillListWidgetState createState() => _BillListWidgetState();
}

class _BillListWidgetState extends State<BillListWidget> {
  List<FileSystemEntity> _fileList;

  @override
  void initState() {
    this.loadFilesContainBill();
    super.initState();
  }

  loadFilesContainBill() async {
    setState(() {
      final dirFiles = widget._billFileDirectory.listSync().toList();
      _fileList = dirFiles.where((dirFile) {
        return widget._invoiceFileList
            .where((invoiceFile) => invoiceFile.path == dirFile.path)
            .isNotEmpty;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.functions,
            color: Colors.white,
          ),
          onPressed: () {}),
      appBar: AppBar(
        title: Text("Bill List"),
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
                          Icons.monetization_on,
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
