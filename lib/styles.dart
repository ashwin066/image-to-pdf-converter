import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants/constants.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    Color primaryColor = Color.fromARGB(255, 245, 45, 81);
    Color primaryColorDark = Color.fromARGB(255, 239, 40, 76);
    double fontSize = 1.25;

    return ThemeData(
      useMaterial3: true,progressIndicatorTheme:  ProgressIndicatorThemeData(
        color: isDarkTheme ? primaryColorDark : primaryColor,
      ),
      fontFamily: "GoogleSans",
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isDarkTheme ? primaryColorDark : primaryColor,
        selectionColor: isDarkTheme
            ? primaryColor.withOpacity(.4)
            : primaryColorDark.withOpacity(.4),
        selectionHandleColor: isDarkTheme ? primaryColor : primaryColorDark,
      ),
      primaryColor: isDarkTheme ? primaryColorDark : primaryColor,
      primaryColorLight: Color.fromARGB(43, 239, 71, 77) ,
      primaryColorDark: primaryColorDark,
      indicatorColor: isDarkTheme ? primaryColorDark : primaryColor,

      hintColor: isDarkTheme ? primaryColorDark : Color(0xffEECED3),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(
            isDarkTheme ? primaryColorDark : primaryColor),
        trackColor: MaterialStateProperty.all<Color>(isDarkTheme
            ? MuchDarkGray
            :   MuchLightGray ,)
      ),
      sliderTheme: SliderThemeData(
        thumbColor: isDarkTheme ? primaryColorDark : primaryColor,
        activeTrackColor: isDarkTheme ? primaryColor : primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isDarkTheme ? primaryColorDark : primaryColor,
          elevation: 7.5,surfaceTintColor: null,
          shadowColor: isDarkTheme
              ? Color.fromARGB(255, 255, 129, 120)
              : Color.fromARGB(180, 255, 123, 114),
          minimumSize: const Size(150, 50),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius10,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:  isDarkTheme ? primaryColorDark : primaryColor),

      snackBarTheme: SnackBarThemeData(
          backgroundColor: MuchLightGray,
          contentTextStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: aBlack, fontFamily: "GoogleSans")),
      inputDecorationTheme: InputDecorationTheme(
        
        fillColor: isDarkTheme ? MuchDarkGray : MuchLightGray,  
        filled: true,
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDarkTheme ? primaryColor : primaryColorDark,
            fontWeight: FontWeight.w600),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 3,
                color: isDarkTheme ? primaryColorDark : primaryColor)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 3,
                color: isDarkTheme ? primaryColorDark : primaryColor)),
      ),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor:   isDarkTheme ? primaryColorDark : primaryColor,
      ),

      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 72.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline2: TextStyle(
            fontSize: 36.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline3: TextStyle(
            fontSize: 24.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline4: TextStyle(
            fontSize: 18.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline5: TextStyle(
            fontSize: 14.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline6: TextStyle(
            fontSize: 12.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        subtitle1: TextStyle(
            fontSize: 16.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        subtitle2: TextStyle(
            fontSize: 14.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        bodyText1: TextStyle(
            fontSize: 12.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        bodyText2: TextStyle(
            fontSize: 10.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        caption: TextStyle(
            fontSize: 8.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        button: TextStyle(
            fontSize: 10.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),
        overline: TextStyle(
            fontSize: 8.0 * fontSize,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.black),

        // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.white : Colors.black),
      ),

      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(background: isDarkTheme ? Colors.black : Color(0xffF1F5FB)), textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}
