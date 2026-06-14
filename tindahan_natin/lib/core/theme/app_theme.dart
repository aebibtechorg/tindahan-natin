import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color background = Color(0xFFF9FAFB);
  static const Color darkBackground = Color(0xFF030712);
  static const Color darkSurface = Color(0xFF111827);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: primaryIndigo,
    primary: primaryIndigo,
    secondary: accentRose,
    surface: background,
    brightness: Brightness.light,
  );

  static final ThemeData lightTheme = _buildTheme(
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: background,
    surfaceColor: Colors.white,
    primaryTextColor: const Color(0xFF111827),
    secondaryTextColor: const Color(0xFF4B5563),
    iconColor: const Color(0xFF111827),
    shadowColor: Colors.black.withValues(alpha: 0.04),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: primaryIndigo,
    primary: const Color(0xFF818CF8),
    secondary: const Color(0xFFF472B6),
    surface: darkSurface,
    brightness: Brightness.dark,
  );

  static final ThemeData darkTheme = _buildTheme(
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: darkBackground,
    surfaceColor: darkSurface,
    primaryTextColor: const Color(0xFFF9FAFB),
    secondaryTextColor: const Color(0xFF9CA3AF),
    iconColor: const Color(0xFFF9FAFB),
    shadowColor: Colors.black.withValues(alpha: 0.2),
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
    final outlineColor = colorScheme.outline.withValues(
      alpha: colorScheme.brightness == Brightness.dark ? 0.35 : 0.12,
    );
    final focusedOutlineColor = colorScheme.primary.withValues(alpha: 0.85);

    // Get the base text theme
    TextTheme baseTextTheme = ThemeData(brightness: colorScheme.brightness).textTheme;
    TextStyle appBarTitleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: primaryTextColor,
      letterSpacing: -0.5,
    );
    TextStyle navLabelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
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
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: primaryTextColor,
          letterSpacing: -0.5,
        );
        navLabelStyle = GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        );
      } catch (_) {}
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: baseTextTheme.copyWith(
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
          letterSpacing: -0.5,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: primaryTextColor),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: secondaryTextColor),
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
        toolbarHeight: 72,
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
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.22)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.brightness == Brightness.dark ? darkSurface : Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: outlineColor, width: 1.0),
        ),
        shadowColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.brightness == Brightness.dark ? darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
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
          borderSide: BorderSide(color: focusedOutlineColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: outlineColor.withValues(alpha: 0.7),
          ),
        ),
        labelStyle: TextStyle(color: secondaryTextColor),
        hintStyle: TextStyle(color: secondaryTextColor),
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
