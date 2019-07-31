import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'bill_list_widget.dart';
import 'config.dart';
import 'invoice_file_detector.dart';

class InvoiceListWidget extends StatefulWidget {
  final Directory _invoiceFilesDirectory;

  InvoiceListWidget(this._invoiceFilesDirectory);

  @override
  _InvoiceListWidgetState createState() => _InvoiceListWidgetState();
}

class _InvoiceListWidgetState extends State<InvoiceListWidget> {
  List<FileSystemEntity> _fileList;

  bool _fabVisible = true;
  bool _isFiltering = false;
  Widget _fabIcon = Icon(Icons.check);
  Widget _fabLabel = Container(height: 0.0, width: 0.0);

  InvoiceFileDetector _invoiceFileDetector;

  @override
  void initState() {
    this.loadDirectoryFiles();
    super.initState();
  }

  loadDirectoryFiles() async {
    setState(() {
      _fileList = widget._invoiceFilesDirectory.listSync().toList();
    });
  }

  _updateFAB() {
    setState(() {
      if (_isFiltering) {
        _fabLabel = Text(
          "filtering...",
          style: TextStyle(fontStyle: FontStyle.italic, color: MAIN_COLOR),
        );
        _fabIcon = Container(
          margin: EdgeInsets.only(right: 5),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      } else {
        _fabLabel = Container(
          width: 0,
          height: 0,
        );
        _fabIcon = Icon(Icons.check);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: _fabVisible,
        child: FloatingActionButton.extended(
            label: _fabLabel,
            icon: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: _fabIcon),
            backgroundColor: Colors.greenAccent,
            isExtended: _isFiltering,
            onPressed: () {
              _openBillListWidget(context);
            }),
      ),
      appBar: AppBar(
        title: Text("INVOICES"),
      ),
      body: ListView.builder(
        itemCount: _fileList == null ? 0 : _fileList.length,
        itemBuilder: (BuildContext context, int index) {
          final String filePath = _fileList[index].path;
          return Card(
            child: InkWell(
              onTap: () async {
                await OpenFile.open(filePath);
              },
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
                        child:
                            Text(basename(filePath), textAlign: TextAlign.left),
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

  @override
  void dispose() {
    _fileList?.clear();
    _fabVisible = true;
    _isFiltering = false;
    _invoiceFileDetector?.release();
    super.dispose();
  }

  /*
   * Find invoice files which contain bill.
   */
  Future<List<File>> _filterInvoiceFiles() async {
    final listConfirmed = List<File>();
    final fileListStream = Stream.fromIterable(_fileList);
    await for (File file in fileListStream) {
      _invoiceFileDetector?.release();
      _invoiceFileDetector = InvoiceFileDetector(file);
      bool isInvoice = await _invoiceFileDetector.isInvoice();
      if (isInvoice) {
        listConfirmed.add(file);
      }
    }
    return listConfirmed;
  }

  /*
   * Open the list of files which are confirmed as invoice files.
   * The FAB will be update to "loading" status until finishing.
   */
  _openBillListWidget(BuildContext context) async {
    if (_isFiltering) return;

    _toggleFiltering(bool filtering) {
      setState(() {
        _isFiltering = filtering;
        _updateFAB();
      });
    }

    _toggleFiltering(true);
    List<File> listConfirmed = await _filterInvoiceFiles();
    _toggleFiltering(false);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return BillListWidget(widget._invoiceFilesDirectory, listConfirmed);
    }));
  }
}
