import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';

abstract class Pipeline {
  /*
   * Detect invoice file language. 
   */
  _findLanguageId();

  /*
   * Translate invoice to English from any source language.
   */
  _translate();

  /*
   * Extract text from invoice.
   */
  _textRecognize();

  /*
   * [true] when the file is confirmed as an invoice file.
   * [false] otherwise not a invoice file.
   */
  Future<bool> isInvoice();
}

class InvoiceFileDetector extends Pipeline {
  static final TAG = "IFD";

  TextRecognizer _textRecognizer;
  LanguageIdentifier _languageIdentifier;
  FirebaseVisionImage _visionImage;
  VisionText _visionText;
  LanguageLabel _languageLabel;
  LanguageTranslator _languageTranslator;

  String _fulltext;
  List<String> _lineList = List();

  String _translatedFulltext;
  List<String> _translatedLineList = List();

  final File _file;

  InvoiceFileDetector(this._file) {
    _visionImage = FirebaseVisionImage.fromFile(_file);
    _textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
    _languageIdentifier = FirebaseLanguage.instance.languageIdentifier();
  }

  @override
  _findLanguageId() async {
    for (TextBlock block in _visionText.blocks) {
      for (TextLine line in block.lines) {
        _lineList.add(line.text);
      }
    }
    _fulltext = _lineList.join(" ");
    debugPrint("$TAG: full-> $_fulltext");

    // Get the language of the invoice file, try the best detected
    // confidence(score), use this language for later translation
    // source.
    final List<LanguageLabel> labels =
        await _languageIdentifier.processText(_fulltext);
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));

    _languageLabel = labels.first;
  }

  @override
  _translate() async {
    if (_languageLabel.languageCode != "en") {
      _languageTranslator = FirebaseLanguage.instance
          .languageTranslator(_languageLabel.languageCode, "en");

      final x = Stream.fromIterable(_lineList);
      await for (String line in x) {
        debugPrint("$TAG: origin-> $line");
        final String t = await _languageTranslator.processText(line);
        debugPrint("$TAG: trans-> $t");
        _translatedLineList.add(t);
      }
      _translatedFulltext = _translatedLineList.join(" ");
    } else {
      _lineList.forEach((line) {
        debugPrint("$TAG: origin-> $line");
      });
      _translatedFulltext = _lineList.join(" ");
    }
  }

  @override
  _textRecognize() async {
    _visionText = await _textRecognizer.processImage(_visionImage);
  }

  @override
  Future<bool> isInvoice() async {
    await _textRecognize();
    await _findLanguageId();
    await _translate();

    debugPrint("$TAG: trans-full-> $_translatedFulltext");
    debugPrint(
        "$TAG: ${_languageLabel.languageCode}/${_languageLabel.confidence}");
    return true;
  }
}
