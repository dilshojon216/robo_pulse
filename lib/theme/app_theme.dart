import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors - RoboPulse
  static const Color primaryBlue = Color(
    0xFF0057FF,
  ); // Yurak urishi chizig'i, asosiy urg'u
  static const Color white = Color(0xFFFFFFFF); // Fon, robot belgisi
  static const Color darkGray = Color(0xFF333333); // Matn, fon kontrasti
  static const Color signalRed = Color(
    0xFFE53935,
  ); // Signal yoki xavfsizlik urg'usi
  static const Color lightGray = Color(
    0xFFF4F4F4,
  ); // Qo'shimcha fonlar, silliq ko'rinish

  // Additional UI colors
  static const Color backgroundGray = lightGray;
  static const Color cardBackground = white;
  static const Color shadowColor = Color(0x1A000000);

  // Gradient variations
  static const Color primaryBlueLight = Color(0xFF3374FF);
  static const Color primaryBlueDark = Color(0xFF003ACC);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundGray,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.white,
        secondary: AppColors.darkGray,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.darkGray,
        error: AppColors.signalRed,
      ),

      // Text Theme
      textTheme: TextTheme(
        // App Title
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGray,
        ),

        // Section Headers
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),

        // Card Titles
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),

        // Subtitles
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGray,
        ),

        // Body Text
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkGray,
        ),

        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.darkGray,
        ),

        // Labels & Small Text
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGray,
        ),

        labelMedium: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGray,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        shadowColor: AppColors.shadowColor,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 4,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.signalRed),
        ),
        labelStyle: GoogleFonts.roboto(color: AppColors.darkGray, fontSize: 14),
        hintStyle: GoogleFonts.roboto(color: Colors.grey[600], fontSize: 14),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryBlue,
        inactiveTrackColor: AppColors.lightGray,
        thumbColor: AppColors.primaryBlue,
        overlayColor: AppColors.primaryBlue.withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        trackHeight: 6,
      ),
    );
  }
}

class AppSizes {
  static const double padding = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double cardElevation = 4.0;

  // Control button sizes
  static const double controlButtonSize = 80.0;
  static const double controlButtonGap = 12.0;

  // Icons
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Status indicators
  static const double statusIndicatorSize = 12.0;
}
