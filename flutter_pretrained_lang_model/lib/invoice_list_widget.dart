import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'bill_list_widget.dart';
import 'invoice_file_detector.dart';

class InvoiceListWidget extends StatefulWidget {
  final Directory _invoiceFilesDirectory;

  InvoiceListWidget(this._invoiceFilesDirectory);

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
      _fileList = widget._invoiceFilesDirectory.listSync().toList();
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
            _openBillListWidget(context);
          }),
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

  /*
   * Open the list of files which are confirmed as an invoice file.
   */
  _openBillListWidget(BuildContext context) async {
    final listConfirmed = List<File>();
    final fileListStream = Stream.fromIterable(_fileList);
    await for (File file in fileListStream) {
      InvoiceFileDetector invoiceFileDetector = InvoiceFileDetector(file);
      bool isInvoice = await invoiceFileDetector.isInvoice();
      if (isInvoice) {
        listConfirmed.add(file);
      }
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return BillListWidget(widget._invoiceFilesDirectory, listConfirmed);
    }));
  }
}
