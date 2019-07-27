import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';

abstract class Pipeline {
  /*
   * Detect invoice file language. 
   */
  Future<String> _findLanguageId();

  /*
   * Translate invoice to English from any source language.
   */
  Future<String> _translate();

  /*
   * Extract text from invoice.
   */
  Future<bool> _textRecognize();

  /*
   * [true] when the file is confirmed as an invoice file.
   * [false] otherwise not a invoice file.
   */
  Future<bool> isInvoice();
}

class InvoiceFileDetector extends Pipeline {
  TextRecognizer _textRecognizer;
  LanguageIdentifier _languageIdentifier;
  FirebaseVisionImage _visionImage;
  VisionText _visionText;
  LanguageLabel _languageLabel;

  final File _file;

  InvoiceFileDetector(this._file) {
    _visionImage = FirebaseVisionImage.fromFile(_file);
    _textRecognizer = FirebaseVision.instance.cloudTextRecognizer();
    _languageIdentifier = FirebaseLanguage.instance.languageIdentifier();
  }

  @override
  Future<String> _findLanguageId() async {
    final List<String> lineList = List();

    for (TextBlock block in _visionText.blocks) {
      for (TextLine line in block.lines) {
        lineList.add(line.text);
      }
    }

    lineList.forEach((text) {
      debugPrint("InvoiceFileDetector: $text");
    });

    final fulltext = lineList.join(" ");
    debugPrint("InvoiceFileDetector: $fulltext");

    // Get the language of the invoice file, try the best detected
    // confidence(score), use this language for later translation
    // source.
    final List<LanguageLabel> labels =
        await _languageIdentifier.processText(fulltext);
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));

    _languageLabel = labels.first;
    return _languageLabel.languageCode;
  }

  @override
  Future<String> _translate() async {
    return "unknown";
  }

  @override
  Future<bool> _textRecognize() async {
    _visionText = await _textRecognizer.processImage(_visionImage);
    return _visionText.blocks.isNotEmpty;
  }

  @override
  Future<bool> isInvoice() async {
    await _textRecognize();
    await _findLanguageId();
    await _translate();

    debugPrint(
        "InvoiceFileDetector: ${_languageLabel.languageCode}/${_languageLabel.confidence}");
    return true;
  }
}
