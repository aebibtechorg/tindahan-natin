import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: primaryIndigo,
    primary: primaryIndigo,
    secondary: const Color(0xFF0EA5E9), // Sky 500
    surface: background,
    brightness: Brightness.light,
  ).copyWith(
    outline: const Color(0xFFE2E8F0), // Slate 200 - subtle border
    outlineVariant: const Color(0xFFCBD5E1), // Slate 300
    surfaceContainerHighest: const Color(0xFFF1F5F9), // Slate 100
  );

  static final ThemeData lightTheme = _buildTheme(
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: background,
    surfaceColor: Colors.white,
    primaryTextColor: const Color(0xFF0F172A), // Slate 900
    secondaryTextColor: const Color(0xFF64748B), // Slate 500
    iconColor: const Color(0xFF0F172A),
    shadowColor: Colors.black.withValues(alpha: 0.03),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: primaryIndigo,
    primary: const Color(0xFF818CF8), // Indigo 400
    secondary: const Color(0xFF38BDF8), // Sky 400
    surface: darkSurface,
    brightness: Brightness.dark,
  ).copyWith(
    outline: const Color(0xFF334155), // Slate 700
    outlineVariant: const Color(0xFF475569), // Slate 600
    surfaceContainerHighest: const Color(0xFF334155), // Slate 700
  );

  static final ThemeData darkTheme = _buildTheme(
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: darkBackground,
    surfaceColor: darkSurface,
    primaryTextColor: const Color(0xFFF8FAFC), // Slate 50
    secondaryTextColor: const Color(0xFF94A3B8), // Slate 400
    iconColor: const Color(0xFFF8FAFC),
    shadowColor: Colors.black.withValues(alpha: 0.15),
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconColor,
    required Color shadowColor,
  }) {
    final outlineColor = colorScheme.outline;
    final focusedOutlineColor = colorScheme.primary.withValues(alpha: 0.85);

    // Get the base text theme
    TextTheme baseTextTheme = ThemeData(brightness: colorScheme.brightness).textTheme;
    TextStyle appBarTitleStyle = TextStyle(
      fontSize: 20, // Slightly more compact and modern
      fontWeight: FontWeight.w700,
      color: primaryTextColor,
      letterSpacing: -0.5,
    );
    TextStyle navLabelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
    );

    // Only load Google Fonts if we are not running in a test environment
    bool isTest = false;
    if (!kIsWeb) {
      try {
        isTest = Platform.environment.containsKey('FLUTTER_TEST');
      } catch (_) {}
    }

    if (!isTest) {
      try {
        baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);
        appBarTitleStyle = GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          letterSpacing: -0.5,
        );
        navLabelStyle = GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        );
      } catch (_) {}
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          letterSpacing: -0.6,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
          letterSpacing: -0.4,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 15,
          color: primaryTextColor,
          height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 13,
          color: secondaryTextColor,
          height: 1.4,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryTextColor,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: appBarTitleStyle,
        iconTheme: IconThemeData(color: iconColor),
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.brightness == Brightness.dark ? darkSurface : Colors.white,
        elevation: 0,
        height: 72.0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.08),
        labelTextStyle: WidgetStateProperty.all(navLabelStyle),
        iconTheme: WidgetStateProperty.all(
          IconThemeData(size: 24, color: iconColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: outlineColor),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: outlineColor, width: 1.0),
        ),
        shadowColor: shadowColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.brightness == Brightness.dark ? darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusedOutlineColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: outlineColor.withValues(alpha: 0.5),
          ),
        ),
        labelStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
        hintStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      shadowColor: shadowColor,
    );
  }
}
