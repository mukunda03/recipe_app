import 'package:flutter/material.dart';

@immutable
class TextStyles {
  static TextStyle h1(Color color) {
    return TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color);
  }

  static TextStyle h2(Color color) {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle h3(Color color) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);
  }

  static TextStyle subtitleText(Color color) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);
  }

  static TextStyle largeSubtitle(Color color) {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: color);
  }
}
