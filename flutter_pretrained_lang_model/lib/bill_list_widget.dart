import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'bill.dart';
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
  BillOverview _billOverview = BillOverview(0, List<Bill>());

  bool _isRunning = false;
  Widget _fabIcon = Icon(Icons.functions);
  Widget _fabLabel = Container(height: 0.0, width: 0.0);

  MainAxisAlignment _rowMainAxisAlignment = MainAxisAlignment.start;

  @override
  void initState() {
    _loadFilesContainBill();
    super.initState();
  }

  _loadFilesContainBill() async {
    setState(() {
      _initBillOverviewList();
    });
    _updateBillOverviewList(this.context);
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
            await _updateBillOverviewList(context);
          }),
      appBar: AppBar(
        title: Text("Bill's overview list"),
      ),
      body: ListView.builder(
        itemCount: _billOverview.billList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: _rowMainAxisAlignment,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          basename(
                              _billOverview.billList[index].invoiceFile.path),
                          textAlign: TextAlign.left),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _billOverview.billList[index].dateText,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _billOverview.billList[index].priceText,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold),
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

  _initBillOverviewList() {
    final dirFiles = widget._billFileDirectory.listSync().toList();
    _fileList = dirFiles.where((dirFile) {
      return widget._invoiceFileList
          .where((invoiceFile) => invoiceFile.path == dirFile.path)
          .isNotEmpty;
    }).toList();

    final newBillOverview = BillOverview(0, List<Bill>());
    _fileList.forEach((f) {
      newBillOverview.billList.add(Bill(f));
    });
    _billOverview = newBillOverview;
  }

  _updateBillOverviewList(BuildContext context) async {
    if (_isRunning) return;

    _toggleRunning(bool isRunning) {
      setState(() {
        _isRunning = isRunning;
        _updateFAB();
      });
    }

    final summary = BillSummary(_fileList);
    _toggleRunning(true);
    final billOverview = await summary.getTotalPrice();
    setState(() {
      _billOverview = billOverview;
      _rowMainAxisAlignment = MainAxisAlignment.spaceBetween;
    });
    _toggleRunning(false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Summary"),
            content: Text(
                "${billOverview.billList.length} day trips, total cost ${billOverview.totalPrice} €. Export as different format."),
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
  }
}
