import 'dart:ui';

import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';

class HNTranslationBloc extends ChangeNotifier {
  String _origin;
  String translated;
  LanguageLabel _languageLabel;
  LanguageTranslator _languageTranslator;
  LanguageIdentifier _languageIdentifier;

  HNTranslationBloc(this._origin) {
    _languageIdentifier = FirebaseLanguage.instance.languageIdentifier();
  }

  static initSupportedLanguage() async {
    final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
    debugPrint("dl lang: ${window.locale.languageCode}");
    await modelManager.downloadModel(window.locale.languageCode);
  }

  _findLanguageId() async {
    final List<LanguageLabel> labels =
        await _languageIdentifier.processText(_origin);
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));
    _languageLabel = labels.first;
  }

  _translate() async {
    _languageTranslator = FirebaseLanguage.instance.languageTranslator(
        _languageLabel.languageCode, window.locale.languageCode);
    translated = await _languageTranslator.processText(_origin);
  }

  translate() async {
    try {
      await _findLanguageId();
      await _translate();
    } on Exception catch (e) {
      translated = null;
    } finally {
      notifyListeners();
    }
  }
}
