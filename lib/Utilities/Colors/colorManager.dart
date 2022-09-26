import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#009B00");
  static Color backGroundColor = Colors.white;
  static Color lightBackGround = Color(0xfff7f6fb);
  static Color accentColor = Colors.black;
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#7c7d7e");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");
  static Color starRatingColor = Color(0xffFC6011);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
