import 'package:flutter/material.dart';
import 'package:ministerio_de_louvor/theme/decorated_box.dart';
import 'package:ministerio_de_louvor/theme/sized_box.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.orange,
    inversePrimary: Colors.grey[300],
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300], foregroundColor: Colors.black),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[100],
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.black),
  )),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.blue,
  ),
  extensions: <ThemeExtension<dynamic>>[
    DecoratedBoxBorderColors(borderColor: Colors.black),
    SizedBoxBackgroundColors(backgroundColor: Colors.blue),
  ],
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.purple[400]!,
    secondary: Colors.orange,
    inversePrimary: Colors.grey[800]!,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[800],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[800],
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.white),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.purple[400]!,
  ),
  extensions: <ThemeExtension<dynamic>>[
    DecoratedBoxBorderColors(borderColor: Colors.white),
    SizedBoxBackgroundColors(backgroundColor: Colors.purple[400]!),
  ],
);
