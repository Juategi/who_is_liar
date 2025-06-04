import 'package:flutter/material.dart';

class ColorUtils {
  static Color randomColor() {
    List<Color> colors = [...Colors.primaries];
    return (colors..shuffle()).first;
  }
}
