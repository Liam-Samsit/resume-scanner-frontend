import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final heading = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.wheatBeige,
  );

  static final body = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.wheatBeige,
  );

  static final hint = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.wheatBeige.withOpacity(0.7),
  );
}
