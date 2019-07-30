import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'bill_summary.dart';

class BillListWidget extends StatefulWidget {
  final Directory _billFileDirectory;
  final List<File> _invoiceFileList;

  BillListWidget(this._billFileDirectory, this._invoiceFileList);

  @override
  _BillListWidgetState createState() => _BillListWidgetState();
}

class _BillListWidgetState extends State<BillListWidget> {
  List<FileSystemEntity> _fileList;

  bool _isRunning = false;
  Widget _fabIcon = Icon(Icons.functions);
  Widget _fabLabel = Container(height: 0.0, width: 0.0);

  @override
  void initState() {
    _loadFilesContainBill();
    super.initState();
  }

  _loadFilesContainBill() async {
    setState(() {
      final dirFiles = widget._billFileDirectory.listSync().toList();
      _fileList = dirFiles.where((dirFile) {
        return widget._invoiceFileList
            .where((invoiceFile) => invoiceFile.path == dirFile.path)
            .isNotEmpty;
      }).toList();
    });
  }

  _updateFAB() {
    setState(() {
      if (_isRunning) {
        _fabLabel = Text(
          "running...",
          style: TextStyle(fontStyle: FontStyle.italic),
        );
        _fabIcon = Container(
          margin: EdgeInsets.only(right: 5),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          ),
        );
      } else {
        _fabLabel = Container(
          width: 0,
          height: 0,
        );
        _fabIcon = Icon(Icons.functions);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: _fabLabel,
          icon: Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: _fabIcon),
          isExtended: _isRunning,
          onPressed: () async {
            if (_isRunning) return;

            _toggleRunning(bool isRunning) {
              setState(() {
                _isRunning = isRunning;
                _updateFAB();
              });
            }

            final summary = BillSummary(_fileList);
            _toggleRunning(true);
            final totalPrice = await summary.getTotalPrice();
            _toggleRunning(false);

            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Summary"),
                    content: Text(
                        "${_fileList.length} day trips, total cost $totalPrice €. Export as different format."),
                    actions: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text("PDF"),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("PNG"),
                      ),
                    ],
                  );
                });
          }),
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
