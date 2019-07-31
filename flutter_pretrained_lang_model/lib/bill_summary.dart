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
   * Release all resource.
   */
  release();

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
    _textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
  }

  @override
  _textRecognize() async {
    final fileListStream = Stream.fromIterable(_files);
    await for (File file in fileListStream) {
      String dateText;
      bool shouldBeTotalPriceNext = false;
      String totalPriceText;

      String datePattern =
          r"([^a-zA-Z0-9]|0*[1-9]|1[012])[- /.](0*[1-9]|[12][0-9]|3[01])[- /.]\d\d";
      RegExp regEx = RegExp(datePattern);

      final visionImage = FirebaseVisionImage.fromFile(file);
      final visionText = await _textRecognizer.processImage(visionImage);
      for (TextBlock block in visionText.blocks) {
        debugPrint("$TAG block: ${block.text}");
        for (TextLine line in block.lines) {
          debugPrint("$TAG line: ${line.text}");
          if (totalPriceText == null && shouldBeTotalPriceNext) {
            /**
             * Extract total price:
             *
             * Convert from "22,34€" to "22.34".
             * Put the formatted value to [_priceList] to summary total price.
             */
            final standard = // for UI therefor remove , O
                line.text
                    .replaceFirst(RegExp(','), '.')
                    .replaceFirst(RegExp('O'), '0')
                    .replaceFirst(RegExp('o'), '0')
                    .trim();
            totalPriceText = standard;
            final normalized = // for summary calc therefor remove €
                standard
                    .replaceFirst(RegExp('€'), '')
                    .replaceFirst(RegExp('E'), '')
                    .trim();
            final d = double.parse(normalized);
            _priceList.add(d);
          }

          if (!shouldBeTotalPriceNext) {
            /**
             * TODO Use translation model is here better than hard-coding.
             */
            shouldBeTotalPriceNext =
                (line.text == "Price total" || line.text == "Gesamtpreis");
          }

          for (TextElement element in line.elements) {
            /**
             * Extract date:
             *
             * One invoice file has one chance to get bill date.
             * As long as it is set, it will never be set again.
             */
            debugPrint("$TAG element: ${element.text}");
            if (regEx.hasMatch(element.text.trim()) && dateText == null) {
              dateText = element.text.trim();
            }
          }
        }
      }
      _billOverview.billList.add(Bill.from(
          totalPriceText.replaceFirst(RegExp('E'), '€').trim(),
          dateText,
          file));
    }
  }

  @override
  _calc() {
    _priceList.forEach((d) => (_billOverview.totalPrice += d));
  }

  @override
  release() {
    _files?.clear();
    _priceList?.clear();
    _billOverview?.release();
    _textRecognizer?.close();
  }

  @override
  Future<BillOverview> getTotalPrice() async {
    await _textRecognize();
    _calc();

    return _billOverview;
  }
}
