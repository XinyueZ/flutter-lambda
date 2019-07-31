import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/widgets.dart';

import 'bill.dart';

abstract class IBillSummary {
  /*
   * Extract price overall
   */
  _textRecognize();

  /*
   * Summary all price values.
   */
  _calc();

  /*
   * Return summary.
   */
  Future<BillOverview> getTotalPrice();
}

class BillSummary extends IBillSummary {
  static final TAG = "BS";

  TextRecognizer _textRecognizer;
  final List<FileSystemEntity> _files;

  List _priceList = List<double>();
  BillOverview _billOverview = BillOverview.from(0, List<Bill>());

  BillSummary(this._files) {
    _textRecognizer = FirebaseVision.instance.textRecognizer();
  }

  @override
  _textRecognize() async {
    final fileListStream = Stream.fromIterable(_files);
    await for (File file in fileListStream) {
      String dateText;
      String datePattern =
          r"([^a-zA-Z0-9]|0*[1-9]|1[012])[- /.](0*[1-9]|[12][0-9]|3[01])[- /.]\d\d";
      RegExp regEx = RegExp(datePattern);

      final visionImage = FirebaseVisionImage.fromFile(file);
      final visionText = await _textRecognizer.processImage(visionImage);
      for (TextBlock block in visionText.blocks) {
        /**
         * One invoice file has one chance to get bill date.
         * As long as it is set, it will never be set again.
         */
        if (regEx.hasMatch(block.text.trim()) && dateText == null) {
          dateText = block.text.trim();
        }
        for (TextLine line in block.lines) {
          debugPrint("$TAG line: ${line.text}");
          if (line.text.contains("€")) {
            /**
             * Convert from "22,34€" to "22.34".
             * Put the formatted value to [_priceList] to summary total price.
             */
            final standard = // for UI therefor remove , O
                line.text
                    .replaceFirst(RegExp(','), '.')
                    .replaceFirst(RegExp('O'), '0')
                    .replaceFirst(RegExp('o'), '0');
            final normalized = // for summary calc therefor remove €
                standard.replaceFirst(RegExp('€'), '').trim();
            final d = double.parse(normalized);
            _priceList.add(d);

            debugPrint(
                "$TAG standard: $standard, normalized: $normalized, dateText: $dateText, file: ${file.path}");
            _billOverview.billList.add(Bill.from(standard, dateText, file));
          }
        }
      }
    }
  }

  @override
  _calc() {
    _priceList.forEach((d) => (_billOverview.totalPrice += d));
  }

  @override
  Future<BillOverview> getTotalPrice() async {
    await _textRecognize();
    _calc();

    return _billOverview;
  }
}
