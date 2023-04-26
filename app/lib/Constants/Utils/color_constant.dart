import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color lightGreen700 = fromHex('#61894e');

  static Color gray200 = fromHex('#f0f0f0');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray50 = fromHex('#f9f9f9');

  static Color primaryColor = lightGreen700;

  static Color listTextColor = Colors.red;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
