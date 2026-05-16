import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFFB300);
  static const Color background = Color(0xFFF7F9FC);
  static const Color darkBackground = Color(0xFF0F1722);
  static const Color darkSurface = Color(0xFF17212E);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: primaryBlue,
    primary: primaryBlue,
    secondary: accentOrange,
    surface: background,
    brightness: Brightness.light,
  );

  static final ThemeData lightTheme = _buildTheme(
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: background,
    surfaceColor: Colors.white,
    primaryTextColor: Colors.black87,
    secondaryTextColor: Colors.black54,
    iconColor: Colors.black87,
    shadowColor: Colors.black54.withValues(alpha: 0.14),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: primaryBlue,
    surface: darkSurface,
    brightness: Brightness.dark,
  );

  static final ThemeData darkTheme = _buildTheme(
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: darkBackground,
    surfaceColor: darkSurface,
    primaryTextColor: Colors.white,
    secondaryTextColor: const Color(0xFFB6C2D1),
    iconColor: Colors.white,
    shadowColor: Colors.black.withValues(alpha: 0.32),
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
      alpha: colorScheme.brightness == Brightness.dark ? 0.55 : 0.24,
    );
    final focusedOutlineColor = colorScheme.primary.withValues(alpha: 0.85);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryTextColor,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 72,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        ),
        iconTheme: IconThemeData(color: iconColor),
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8.0,
        height: 64.0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
          ),
        ),
        iconTheme: WidgetStateProperty.all(
          IconThemeData(size: 20, color: iconColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
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
        color: surfaceColor,
        elevation: 6.0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: shadowColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: outlineColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: outlineColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedOutlineColor, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: outlineColor.withValues(alpha: 0.7),
          ),
        ),
        labelStyle: TextStyle(color: secondaryTextColor),
        hintStyle: TextStyle(color: secondaryTextColor),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: primaryTextColor),
        bodyMedium: TextStyle(fontSize: 14, color: secondaryTextColor),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      shadowColor: shadowColor,
    );
  }
}
