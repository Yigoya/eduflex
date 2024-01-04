import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 121, 241, 175),
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  cardColor: Colors.black.withOpacity(0.5),
  canvasColor: Colors.grey[300],
  colorScheme: ColorScheme.light(),
);

ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black.withOpacity(0.2),
    colorScheme: ColorScheme.dark());

class ThemeChanger extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  ThemeData get theme => _currentTheme;

  void toggleTheme() {
    _currentTheme = (_currentTheme == lightTheme) ? darkTheme : lightTheme;
    notifyListeners();
  }
}
