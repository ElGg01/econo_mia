import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LanguageModeOption {
  english,
  spanish
}

class LanguageProvider extends ChangeNotifier {

  LanguageModeOption _languageModeOption = LanguageModeOption.english;
  LanguageModeOption get languageMode => _languageModeOption;

  LanguageProvider(String? language){
    if (language == null) return;
    if (language == 'english'){
      _languageModeOption = LanguageModeOption.english;
    } else if (language == 'spanish'){
      _languageModeOption = LanguageModeOption.spanish;
    }
  }

  void setLanguageMode(LanguageModeOption modeOption) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _languageModeOption = modeOption;
    prefs.setString('language', modeOption.name);
    notifyListeners();
  }
}