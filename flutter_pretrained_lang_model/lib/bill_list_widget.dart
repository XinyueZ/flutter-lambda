import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class BillListWidget extends StatefulWidget {
  final Directory _billDirectory;

  BillListWidget(this._billDirectory);

  @override
  _BillListWidgetState createState() => _BillListWidgetState();
}

class _BillListWidgetState extends State<BillListWidget> {
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
                          color: Colors.black,
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
