import 'package:flutter/material.dart';

/// Centralized Color Tokens matching the Treat Design System
/// Extracted from stitch_remix_of_treat_mobile_app_wireframes and DESIGN.md
class TreatColors {
  TreatColors._();

  // Primary: Candy Berry Pink
  static const Color primary = Color(0xFFE040A0);
  static const Color primaryContainer = Color(0xFFF080C0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF2E1A28);
  static const Color primaryFixed = Color(0xFFFFD6EE);
  static const Color primaryFixedDim = Color(0xFFF0A0CC);
  static const Color onPrimaryFixed = Color(0xFF3D0028);
  static const Color onPrimaryFixedVariant = Color(0xFFA02070);

  // Secondary: Funky Violet / Purple
  static const Color secondary = Color(0xFF7C52AA);
  static const Color secondaryDark = Color(0xFF633990);
  static const Color secondaryContainer = Color(0xFFEEDCFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF2E2040);
  static const Color secondaryFixed = Color(0xFFEEDCFF);
  static const Color secondaryFixedDim = Color(0xFFC8A8E8);
  static const Color onSecondaryFixed = Color(0xFF1A1030);
  static const Color onSecondaryFixedVariant = Color(0xFF4A3068);

  // Tertiary: Sky Cyan / Blue
  static const Color tertiary = Color(0xFF0096CC);
  static const Color tertiaryContainer = Color(0xFF40C0EE);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF00334D);
  static const Color tertiaryFixed = Color(0xFFC8EAFF);
  static const Color tertiaryFixedDim = Color(0xFF80D0F0);
  static const Color onTertiaryFixed = Color(0xFF001A33);
  static const Color onTertiaryFixedVariant = Color(0xFF005580);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFFEF7FF);
  static const Color surface = Color(0xFFFEF7FF);
  static const Color surfaceBright = Color(0xFFFEF7FF);
  static const Color surfaceDim = Color(0xFFE0D6E0);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFBF2FB);
  static const Color surfaceContainer = Color(0xFFF8EEF8);
  static const Color surfaceContainerHigh = Color(0xFFF2E8F2);
  static const Color surfaceContainerHighest = Color(0xFFECE2EC);

  // Typography & On-Surfaces
  static const Color onSurface = Color(0xFF2E1A28);
  static const Color onSurfaceVariant = Color(0xFF604868);
  static const Color onBackground = Color(0xFF2E1A28);
  static const Color outline = Color(0xFF907898);
  static const Color outlineVariant = Color(0xFFDCC8E0);

  // Status & Feedback
  static const Color success = Color(0xFF00A86B);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFE53E3E);
  static const Color errorContainer = Color(0xFFFFE8E8);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF9B1C1C);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);

  // Signature Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary, tertiary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFF054B0), Color(0xFFE040A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C52AA), Color(0xFF633990)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [primaryFixed, surfaceContainerLowest, secondaryFixed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient potBannerGradient = LinearGradient(
    colors: [secondary, primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient softAmbientGlow = LinearGradient(
    colors: [Color(0xFFFEF7FF), Color(0xFFF8F1F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static const List<BoxShadow> candyShadow = [
    BoxShadow(
      color: Color.fromRGBO(124, 82, 170, 0.12),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color.fromRGBO(224, 64, 160, 0.08),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> pillShadow = [
    BoxShadow(
      color: Color.fromRGBO(124, 82, 170, 0.35),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> pinkPillShadow = [
    BoxShadow(
      color: Color.fromRGBO(224, 64, 160, 0.35),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];
}
