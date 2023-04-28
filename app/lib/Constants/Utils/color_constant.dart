import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColorConstant {
  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color lightGreen700 = fromHex('#61894e');

  static Color gray200 = fromHex('#f0f0f0');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray50 = fromHex('#f9f9f9');

  static Color primaryColor = lightGreen700;

  static Color listTextColor = Colors.red;

  static Color expirationPassedColor = Colors.red;

  static Color expirationApproachingColor = Colors.greenAccent;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color expirationDateColor(String date) {
    DateTime expirationDate = DateTime.parse(date);
    DateTime today = DateTime.now();

    if (expirationDate.year == today.year &&
        expirationDate.month == today.month &&
        expirationDate.day == today.day) {
          return Colors.black;
    } else if (expirationDate.isBefore(today)) {
      return expirationPassedColor;
    }
    return Colors.black38;
  }
}
