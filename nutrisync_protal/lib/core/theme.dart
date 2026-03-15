import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Colors ───────────────────────────────────────────
  static const Color primary = Color(0xFFE14B4B);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFAAAAAA);

  // BMI zone colours
  static const Color bmiUnderweight = Color(0xFF4FC3F7);
  static const Color bmiNormal = Color(0xFF66BB6A);
  static const Color bmiOverweight = Color(0xFFFFCA28);
  static const Color bmiObese = Color(0xFFFF7043);
  static const Color bmiExtreme = Color(0xFFE53935);

  // Status pill colours
  static const Color statusCriticalBg = Color(0xFFFFEBEB);
  static const Color statusCriticalText = Color(0xFFE14B4B);

  // ─── ThemeData ───────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, surface: background),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: textPrimary),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
    ),
  );
}
