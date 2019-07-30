import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/widgets.dart';

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
  Future<double> getTotalPrice();
}

class BillSummary extends IBillSummary {
  static final TAG = "BS";

  TextRecognizer _textRecognizer;
  List _priceList = List<double>();
  double _totalPrice = 0.0;

  final List<FileSystemEntity> _files;

  BillSummary(this._files) {
    _textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
  }

  @override
  _textRecognize() async {
    final fileListStream = Stream.fromIterable(_files);
    await for (File file in fileListStream) {
      final visionImage = FirebaseVisionImage.fromFile(file);
      final visionText = await _textRecognizer.processImage(visionImage);
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          if (line.text.contains("€")) {
            var s = line.text.replaceFirst(RegExp('€'), '');
            s = s.replaceFirst(RegExp(','), '.').trim();

            debugPrint("$TAG s: ${s}");
            final d = double.parse(s);
            _priceList.add(d);
          }
        }
      }
    }
  }

  @override
  _calc() {
    _priceList.forEach((d) => (_totalPrice += d));
  }

  @override
  Future<double> getTotalPrice() async {
    await _textRecognize();
    _calc();

    debugPrint("$TAG: total price: $_totalPrice");
    return _totalPrice;
  }
}
