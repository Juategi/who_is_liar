import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:who_is_liar/settings/colors.dart';

class AppStyles {
  static final primary = GoogleFonts.comicNeue(
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor,
    ),
  );

  static final secondary = GoogleFonts.comicNeue(
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
