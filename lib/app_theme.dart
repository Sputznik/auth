import 'package:flutter/material.dart';

ThemeData ykaTheme() {
  TextTheme _ykaTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Montserrat',
        // color: Colors.black,
      ),
      headline2: base.headline2.copyWith(
        fontFamily: 'Montserrat',
      ),
      headline3: base.headline3.copyWith(
        fontFamily: 'Montserrat',
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'Montserrat',
      ),
      headline5: base.headline5.copyWith(
        fontFamily: 'Montserrat',
      ),
      headline6: base.headline6.copyWith(
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: base.subtitle1.copyWith(
        fontFamily: 'Montserrat',
      ),
      subtitle2: base.subtitle2.copyWith(
        fontFamily: 'Montserrat',
      ),
      caption: base.caption.copyWith(
        fontFamily: 'Montserrat',
      ),
      bodyText1: base.bodyText1.copyWith(
        fontFamily: 'Montserrat',
      ),
      bodyText2: base.bodyText2.copyWith(
        fontFamily: 'Montserrat',
      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _ykaTextTheme(base.textTheme),
    primaryColor: Color(0xfff1e8e3),
    accentColor: Color(0xff464647),
    errorColor: Colors.red[900],
    scaffoldBackgroundColor: Color(0xfff6f6f6),
    cursorColor: Color(0xff464647),
    appBarTheme: AppBarTheme(
      shadowColor: Color(0xff464647),
      iconTheme: IconThemeData(
        color: Color(0xff464647),
      ),
      actionsIconTheme: IconThemeData(
        color: Color(0xff464647),
      ),
      textTheme: _ykaTextTheme(base.textTheme),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xfff1e8e3),
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(
      color: Color(0xff464647),
      size: 20.0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xfff1e8e3),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xfff1e8e3),
      selectedItemColor: Color(0xff464647),
      selectedIconTheme: IconThemeData(
        color: Color(0xff464647),
      ),
      selectedLabelStyle: TextStyle(
        color: Color(0xff464647),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xfff1e8e3),
      foregroundColor: Color(0xff464647),
    ),
  );
}
