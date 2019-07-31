import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/widgets.dart';

import 'bill.dart';

abstract class IBillSummary {
  /*
   * Extract price overall
   */
  _billDateTotalPriceRecognize();

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
  _billDateTotalPriceRecognize() async {
    final LanguageIdentifier languageIdentifier =
        FirebaseLanguage.instance.languageIdentifier();
    final fileListStream = Stream.fromIterable(_files);

    await for (File file in fileListStream) {
      String dateText;
      bool shouldBeTotalPriceNext = false;
      String totalPriceText;
      double price;

      final String datePattern =
          r"([^a-zA-Z0-9]|0*[1-9]|1[012])[- /.](0*[1-9]|[12][0-9]|3[01])[- /.]\d\d";
      final RegExp regEx = RegExp(datePattern);

      final visionImage = FirebaseVisionImage.fromFile(file);
      final visionText = await _textRecognizer.processImage(visionImage);

      for (TextBlock block in visionText.blocks) {
        debugPrint("$TAG block: ${block.text}");
        for (TextLine line in block.lines) {
          debugPrint("$TAG line: ${line.text}");
          if (totalPriceText == null && shouldBeTotalPriceNext) {
            /**
             * Extract trip price:
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
            price = double.parse(normalized);
            _priceList.add(price);
          }

          if (!shouldBeTotalPriceNext) {
            String lineText;
            try {
              final List<LanguageLabel> labels =
                  await languageIdentifier.processText(line.text);
              labels.sort((a, b) => b.confidence.compareTo(a.confidence));

              if (labels.first.languageCode != "en") {
                final LanguageTranslator languageTranslator = FirebaseLanguage
                    .instance
                    .languageTranslator(labels.first.languageCode, "en");
                lineText = await languageTranslator.processText(line.text);
              } else {
                lineText = line.text;
              }
            } catch (e) {
              lineText = line.text;
            }

            lineText = lineText.toLowerCase();
            shouldBeTotalPriceNext = lineText.contains("price") &&
                (lineText.contains("total") || lineText.contains("overall"));
          }

          for (TextElement element in line.elements) {
            /**
             * Extract trip date:
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
          price,
          dateText,
          file));

      /**
       * DESC sort the price text on the bill overview list.
       */
      _billOverview.billList
          .sort((first, second) => second.price.compareTo(first.price));
    } // One invoice has been handled.
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
    await _billDateTotalPriceRecognize();
    _calc();

    return _billOverview;
  }
}
