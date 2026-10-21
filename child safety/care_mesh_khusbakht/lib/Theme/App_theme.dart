import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette - Modern & Sophisticated
  static const Color primaryDark = Color(0xFF0A1628);
  static const Color primaryMedium = Color(0xFF162447);
  static const Color primaryLight = Color(0xFF1F4068);
  static const Color primaryAccent = Color(0xFF3B82F6);
  static const Color secondaryAccent = Color(0xFF60A5FA);
  static const Color accentCyan = Color(0xFF22D3EE);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningRed = Color(0xFFF43F5E);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningYellow = Color(0xFFFBBF24);

  // Glassmorphism Colors
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x0DFFFFFF);

  // Neon Glow Colors
  static const Color neonBlue = Color(0xFF00D4FF);
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonPink = Color(0xFFFF0080);
  static const Color neonGreen = Color(0xFF00FF88);

  // Text Styles using Google Fonts - Premium Typography
  static TextStyle get headingXL => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headingLarge => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle get headingMedium => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: -0.2,
  );

  static TextStyle get headingSmall => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0,
  );

  static TextStyle get subtitle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.7),
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.1,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.9),
    letterSpacing: 0.1,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.6),
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static TextStyle get linkText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: accentCyan,
    letterSpacing: 0.2,
  );

  static TextStyle get labelText => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
    letterSpacing: 0.3,
  );

  static TextStyle get locationText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.8),
    letterSpacing: 0.2,
  );

  static TextStyle get timeText => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.6),
    letterSpacing: 0.5,
  );

  // Premium Gradient Lists
  static List<Color> get backgroundGradient => [
    primaryDark,
    primaryMedium,
    primaryLight,
    const Color(0xFF1E3A5F),
  ];

  static List<Color> get meshGradient => [
    const Color(0xFF0A1628),
    const Color(0xFF1A1A2E),
    const Color(0xFF16213E),
    const Color(0xFF0F3460),
  ];

  static List<Color> get buttonGradient => [
    primaryAccent,
    accentCyan,
  ];

  static List<Color> get premiumButtonGradient => [
    const Color(0xFF667EEA),
    const Color(0xFF764BA2),
  ];

  static List<Color> get successGradient => [
    const Color(0xFF059669),
    const Color(0xFF10B981),
  ];

  static List<Color> get dangerGradient => [
    const Color(0xFFDC2626),
    const Color(0xFFF43F5E),
  ];

  static List<Color> get warningGradient => [
    const Color(0xFFD97706),
    const Color(0xFFF59E0B),
  ];

  static List<Color> get cardGradient => [
    glassWhite,
    glassHighlight,
  ];

  static List<Color> get glassGradient => [
    Colors.white.withOpacity(0.1),
    Colors.white.withOpacity(0.05),
  ];

  // Glassmorphism Box Decoration
  static BoxDecoration get glassDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: glassGradient,
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: glassBorder,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 10),
      ),
    ],
  );

  // Neon Glow Box Shadow
  static List<BoxShadow> neonGlow(Color color, {double intensity = 1.0}) => [
    BoxShadow(
      color: color.withOpacity(0.3 * intensity),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withOpacity(0.2 * intensity),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: primaryDark,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.7),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}