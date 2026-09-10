import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treat_colors.dart';

/// Typography definitions matching Treat design tokens
class TreatTypography {
  TreatTypography._();

  // Displays
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.03 * 36,
    color: TreatColors.onSurface,
    height: 1.15,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.025 * 28,
    color: TreatColors.onSurface,
    height: 1.2,
  );

  // Headlines
  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 24,
    color: TreatColors.onSurface,
    height: 1.25,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.015 * 20,
    color: TreatColors.onSurface,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01 * 18,
    color: TreatColors.onSurface,
    height: 1.3,
  );

  // Titles
  static TextStyle titleLarge = GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: TreatColors.onSurface,
  );

  static TextStyle titleMedium = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.005 * 16,
    color: TreatColors.onSurface,
  );

  static TextStyle titleSmall = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: TreatColors.onSurface,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: TreatColors.onSurface,
    height: 1.45,
  );

  static TextStyle bodyMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TreatColors.onSurface,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TreatColors.onSurfaceVariant,
    height: 1.35,
  );

  // Labels & Chips
  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.01 * 14,
    color: TreatColors.onSurface,
  );

  static TextStyle labelMedium = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.02 * 12,
    color: TreatColors.onSurface,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.04 * 11,
    color: TreatColors.onSurface,
  );

  // Ticket Code (Monospace)
  static const TextStyle ticketCode = TextStyle(
    fontFamily: 'monospace',
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    color: TreatColors.secondary,
  );
}
