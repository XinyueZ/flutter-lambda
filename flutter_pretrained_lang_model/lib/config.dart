import 'dart:ui';

import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

const Color MAIN_COLOR = const Color.fromARGB(255, 97, 83, 29);

initSupportedLanguage() async {
  final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
  await modelManager.downloadModel(SupportedLanguages.English);
  await modelManager.downloadModel(SupportedLanguages.German);
  await modelManager.downloadModel(SupportedLanguages.Chinese);
}
