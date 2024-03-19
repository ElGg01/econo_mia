import 'package:flutter/material.dart';

enum ThemeModeOption {
  light,
  dark,
  system
}

class ThemeProvider extends ChangeNotifier {


  ThemeModeOption _themeModeOption = ThemeModeOption.system;
  ThemeModeOption get themeMode => _themeModeOption;

  void setThemeMode(ThemeModeOption modeOption){
    _themeModeOption = modeOption;
    notifyListeners();
  }

}