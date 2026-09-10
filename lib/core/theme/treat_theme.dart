import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treat_colors.dart';
import 'treat_typography.dart';

/// App-wide ThemeData setup
class TreatTheme {
  TreatTheme._();

  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.light(
      primary: TreatColors.primary,
      onPrimary: TreatColors.onPrimary,
      primaryContainer: TreatColors.primaryContainer,
      onPrimaryContainer: TreatColors.onPrimaryContainer,
      secondary: TreatColors.secondary,
      onSecondary: TreatColors.onSecondary,
      secondaryContainer: TreatColors.secondaryContainer,
      onSecondaryContainer: TreatColors.onSecondaryContainer,
      tertiary: TreatColors.tertiary,
      onTertiary: TreatColors.onTertiary,
      surface: TreatColors.surface,
      onSurface: TreatColors.onSurface,
      error: TreatColors.error,
      onError: TreatColors.onError,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseScheme,
      scaffoldBackgroundColor: TreatColors.background,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      textTheme: TextTheme(
        displayLarge: TreatTypography.displayLarge,
        displayMedium: TreatTypography.displayMedium,
        headlineLarge: TreatTypography.headlineLarge,
        headlineMedium: TreatTypography.headlineMedium,
        headlineSmall: TreatTypography.headlineSmall,
        titleLarge: TreatTypography.titleLarge,
        titleMedium: TreatTypography.titleMedium,
        titleSmall: TreatTypography.titleSmall,
        bodyLarge: TreatTypography.bodyLarge,
        bodyMedium: TreatTypography.bodyMedium,
        bodySmall: TreatTypography.bodySmall,
        labelLarge: TreatTypography.labelLarge,
        labelMedium: TreatTypography.labelMedium,
        labelSmall: TreatTypography.labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: TreatColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color.fromRGBO(124, 82, 170, 0.12),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: TreatTypography.labelLarge,
        ),
      ),
    );
  }
}
