import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle heading2 = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle body = GoogleFonts.nunito(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static TextStyle button = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static TextStyle chip = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
}
