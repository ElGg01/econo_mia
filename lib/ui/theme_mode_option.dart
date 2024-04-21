import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption {
  light,
  dark,
  system
}

class ThemeProvider extends ChangeNotifier {


  ThemeModeOption _themeModeOption = ThemeModeOption.system;
  ThemeModeOption get themeMode => _themeModeOption;

  ThemeProvider(String? theme){
    if(theme == null) return;
    if (theme == 'light'){
      _themeModeOption = ThemeModeOption.light;
    } else if (theme == 'dark'){
      _themeModeOption = ThemeModeOption.dark;
    } else if (theme == 'system'){
      _themeModeOption = ThemeModeOption.system;
    }
  }

  void setThemeMode(ThemeModeOption modeOption) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeModeOption = modeOption;
    prefs.setString('theme', modeOption.name);
    notifyListeners();
  }

}