import 'package:flutter/material.dart';

enum LanguageModeOption {
  english,
  spanish
}

class LanguageProvider extends ChangeNotifier {

  LanguageModeOption _languageModeOption = LanguageModeOption.english;
  LanguageModeOption get languageMode => _languageModeOption;

  void setLanguageMode(LanguageModeOption modeOption){
    _languageModeOption = modeOption;
    notifyListeners();
  }
}