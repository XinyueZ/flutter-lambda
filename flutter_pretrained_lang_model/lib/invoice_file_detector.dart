import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';

abstract class IInvoiceFileDetector {
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
   * Confirm the file is an invoice file. 
   */
  _identifyInvoice();

  /*
   * [true] when the file is confirmed as an invoice file.
   * [false] otherwise not a invoice file.
   */
  Future<bool> isInvoice();
}

class InvoiceFileDetector extends IInvoiceFileDetector {
  static final TAG = "IFD";

  TextRecognizer _textRecognizer;
  LanguageIdentifier _languageIdentifier;
  FirebaseVisionImage _visionImage;
  VisionText _visionText;
  LanguageLabel _languageLabel;
  LanguageTranslator _languageTranslator;

  List<String> _lineList = List();
  List<String> _translatedLineList = List();

  final File _file;

  bool _isInvoice = false;

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
    final fulltext = _lineList.join(" ");
    // Get the language of the invoice file, try the best detected
    // confidence(score), use this language for later translation
    // source.
    final List<LanguageLabel> labels =
        await _languageIdentifier.processText(fulltext);
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));

    _languageLabel = labels.first;
  }

  @override
  _translate() async {
    /**
     * Translation will be ignored if the detected language is already English.
     */
    if (_languageLabel.languageCode != "en") {
      _languageTranslator = FirebaseLanguage.instance
          .languageTranslator(_languageLabel.languageCode, "en");

      final lineListStream = Stream.fromIterable(_lineList);
      await for (String line in lineListStream) {
        debugPrint("$TAG: origin: $line");
        final String lineInEnglish =
            await _languageTranslator.processText(line);
        debugPrint("$TAG: in English: $lineInEnglish");
        _translatedLineList.add(lineInEnglish);
      }
    } else {
      _translatedLineList.addAll(_lineList);
      _translatedLineList.forEach((line) {
        debugPrint("$TAG: origin: $line");
      });
    }
  }

  @override
  _textRecognize() async {
    _visionText = await _textRecognizer.processImage(_visionImage);
  }

  @override
  void _identifyInvoice() {
    _isInvoice = _translatedLineList.where((line) {
      return "invoice" == line.toLowerCase();
    }).isNotEmpty;
  }

  @override
  Future<bool> isInvoice() async {
    await _textRecognize();
    await _findLanguageId();
    await _translate();
    _identifyInvoice();

    return _isInvoice;
  }
}
