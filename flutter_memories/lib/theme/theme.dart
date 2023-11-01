import 'package:flutter/material.dart';

ThemeData? activeTheme;

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF001a38),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF001a38),
    iconTheme: IconThemeData(color: Colors.white),
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    tileColor: const Color(0xFF003367),
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF003367),
  ),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all(Colors.white),
    thumbColor: MaterialStateProperty.all(Colors.white),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.white),
    fillColor: MaterialStateProperty.all(const Color(0xFF003367)),
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Color(0xFF001a38),
    dialTextColor: Colors.white,
    hourMinuteColor: Color(0xFF003367),
  ),
  cardColor: const Color(0xFF003367),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
  ),
  dialogBackgroundColor: const Color(0xFF003367),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF003367),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE5F5FF),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE5F5FF),
    iconTheme: IconThemeData(color: Colors.black),
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    tileColor: Colors.white,
    iconColor: Colors.blue,
    textColor: Colors.black,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.green),
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black),
    ),
  ),
  dialogBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
);
