import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var cardColor = Color.fromRGBO(252, 245, 218, 1.0);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(primary: Colors.teal),
  cardColor: cardColor,
  dividerColor: Colors.black,
  bottomAppBarColor: Colors.teal,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(primary: Colors.teal),
  cardColor: Colors.black38,
  dividerColor: Colors.white,
  bottomAppBarColor: Colors.teal,
);

class ThemeProvider with ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _pref;
  bool _darkTheme = false;

  _saveTheme() async {
    _pref = await SharedPreferences.getInstance();
    _pref.setBool(key, _darkTheme);
    notifyListeners();
  }

  _loadThemeFromPref() async {
    _pref = await SharedPreferences.getInstance();
    _darkTheme = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  changeTheme() {
    if (_darkTheme == false) {
      _darkTheme = true;
      _saveTheme();
      notifyListeners();
      return darkMode;
    } else {
      _darkTheme = false;
      _saveTheme();
      notifyListeners();
      return lightMode;
    }
  }

  ThemeData getTheme() {
    _loadThemeFromPref();
    if (_darkTheme == false) {
      return darkMode;
    } else {
      return lightMode;
    }
  }
}
