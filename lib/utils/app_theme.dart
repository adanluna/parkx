import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF170F52);
  static const textColor = Color(0xFF000000);
  static const secondaryColor = Color(0xFF00FEE1);
  static const accentColor = Color(0xFF00FEE1);
  static const backgroundColor = Color(0xFFEEEEEE);
  static const disabledTextSecondary = Color(0xFF8b87a8);

  static const errorColor = Color(0xFFF92929);
  static const successColor = Color.fromARGB(255, 0, 161, 59);

  static const lightGray = Color(0xFFF6F6F6);
  static const gray = Color.fromARGB(132, 100, 100, 100);
  static const mediumGray = Color.fromARGB(255, 79, 79, 79);
  static const darkGray = Color(0xFF363636);
  static const alert = Color(0xFFFFA800);

  static ThemeData get theme {
    return ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: _NoAnimationTransition(),
        TargetPlatform.iOS: _NoAnimationTransition(),
        // if you have more you can add them here
      }),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primaryColor,
      fontFamily: 'Sansation',
      tabBarTheme: const TabBarTheme(
          labelColor: accentColor,
          unselectedLabelColor: Color.fromARGB(255, 185, 181, 178),
          indicator: BoxDecoration(),
          labelStyle: TextStyle(fontSize: 9),
          unselectedLabelStyle: TextStyle(fontSize: 9)),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 25,
            color: primaryColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 21,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          )),
      buttonTheme: ButtonThemeData(
        height: 50,
        buttonColor: accentColor,
        textTheme: ButtonTextTheme.normal,
        colorScheme: const ColorScheme.light(primary: Colors.black, secondary: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Sansation'),
          minimumSize: const Size(0, 45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: Colors.white,
          minimumSize: const Size(0, 45),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(width: 1.0, color: primaryColor),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        floatingLabelStyle: TextStyle(fontSize: 19),
        hintStyle: TextStyle(fontSize: 14, color: mediumGray),
        labelStyle: TextStyle(fontSize: 16, color: textColor),
        filled: true,
        fillColor: lightGray,
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: primaryColor,
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _NoAnimationTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(_, __, ___, ____, Widget child) => child;
}
