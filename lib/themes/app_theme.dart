// ignore: unused_import
import 'package:flutter/material.dart';

class AppTheme {
  // sizing
  static const double bottomNavBarHeight = 64;
  static BorderRadius buttonRadius = BorderRadius.circular(10);

  // colors
  static const Color primaryGreen = Color.fromARGB(255, 123, 183, 67);
  static const Color darkGreen = Color.fromARGB(255, 62, 112, 63);
  static const Color primaryOrange = Color.fromARGB(255, 255, 172, 39);
  static const Color primaryRed = Color.fromARGB(255, 215, 80, 46);

  static const Color primaryBlack = Color.fromARGB(255, 65, 65, 65);
  static const Color secondaryBlack = Color.fromARGB(255, 88, 88, 88);

  static const Color primaryWhite = Colors.white;
  static const Color secondaryWhite = Color.fromARGB(255, 244, 244, 244);
  static const Color greyOutline = Color.fromARGB(255, 217, 217, 217);

  // text theme
  static TextTheme textTheme = const TextTheme(
      titleLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: primaryBlack,
          fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: secondaryBlack,
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: primaryWhite,
          fontWeight: FontWeight.w700),
      labelSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: secondaryBlack,
          fontWeight: FontWeight.w400));

  // main theme
  static ThemeData theme = ThemeData(
      backgroundColor: primaryWhite,
      scaffoldBackgroundColor: primaryWhite,
      primaryColor: primaryGreen,
      hintColor: primaryOrange,
      indicatorColor: primaryRed,
      radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(primaryOrange),
          splashRadius: 24),
      iconTheme: const IconThemeData(color: primaryOrange),
      primaryIconTheme: const IconThemeData(color: primaryOrange),
      splashColor: primaryOrange.withOpacity(.4),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: secondaryWhite,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: greyOutline)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryGreen))),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: secondaryBlack));
}
