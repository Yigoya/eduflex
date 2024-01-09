import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 155, 148, 255),
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  cardColor: Colors.black.withOpacity(0.5),
  canvasColor: Colors.grey[300],
  colorScheme: ColorScheme.light(),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 25, 85, 52),
  primaryColorLight: Colors.black,
  primaryColorDark: Colors.white,
  cardColor: Colors.white.withOpacity(0.5),
  canvasColor: const Color.fromARGB(255, 71, 70, 70),
  colorScheme: ColorScheme.dark(),
);

class ThemeChanger extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  ThemeData get theme => _currentTheme;

  void toggleTheme() {
    _currentTheme = (_currentTheme == lightTheme) ? darkTheme : lightTheme;
    notifyListeners();
  }
}
