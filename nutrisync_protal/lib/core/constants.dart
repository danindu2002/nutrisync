import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFEF4444); // Red
  static const Color secondary = Color(0xFF393C43); // Dark Grey
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color cardBg = Color(0xFFF4F4F4); // Light grey
  static const Color textMain = Color(0xFF1F2937);
  static const Color textSub = Color(0xFF6B7280);
}

class AppTextStyles {
  static final TextStyle header = GoogleFonts.workSans(
    fontSize: 26,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );

  static final TextStyle welcomeText = GoogleFonts.workSans(
    fontSize: 32,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle welcomeTextRed = GoogleFonts.workSans(
    fontSize: 32,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle subHeader = GoogleFonts.workSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  static final TextStyle buttonText = GoogleFonts.workSans(
    fontSize: 18,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}