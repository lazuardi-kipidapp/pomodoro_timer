import 'package:flutter/material.dart';

class CustomColors {
  // Pallates
  static const Color lightBlue100 = Color(0xFFCAEDFF);
  static const Color lightPurple100 = Color(0xFFD8B4F8);
  static const Color lightGray100 = Color(0xFFD9D9D9);

  static const Color darkBlue100 = Color(0xFFA5D3F2);
  static const Color darkPurple100 = Color(0xFF5A3370);
  static const Color darkPurple200 = Color(0xFF3E224D);

  // Backgrounds
  static const Color backgroundBlue = CustomColors.lightBlue100;

  // Texts
  static const Color textRegular = Colors.black;

  // Tags
  static const Color tagBlueBG = CustomColors.darkBlue100;
  static const Color tagBlueLabel = Colors.black;

  // Buttons
  static const Color buttonPurpleBG = CustomColors.darkPurple200;
  static const Color buttonPurpleLabel = Colors.white;

  // Strokes
  static const Color strokeBlue = CustomColors.darkBlue100;

  // Navbars
  static const Color navbarSelectedBG = CustomColors.darkPurple100;
  static const Color navbarSelectedLabel = Colors.white;
  static const Color navbarSelectedHighlight = Colors.white;
  static const Color navbarUnselectedBG = CustomColors.darkPurple200;
  static const Color navbarUnselectedLabel = CustomColors.lightPurple100;
  static const Color navbarUnselectedHighlight = Colors.transparent;
}