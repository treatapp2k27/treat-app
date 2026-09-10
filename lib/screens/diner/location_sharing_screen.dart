import 'package:flutter/material.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../widgets/radar_pulse_widget.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';

class LocationSharingScreen extends StatelessWidget {
  final VoidCallback onEnableLocation;
  final VoidCallback onSkip;

  const LocationSharingScreen({
    super.key,
    required this.onEnableLocation,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Image.asset(
                    AssetConstants.logo,
                    height: 36,
                    errorBuilder: (_, __, ___) => Text(
                      'treat.',
                      style: TreatTypography.headlineLarge.copyWith(color: TreatColors.primary),
                    ),
                  ),
                  TextButton(
                    onPressed: onSkip,
                    child: Text('Skip', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSurfaceVariant)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Animated Radar
              const Center(
                child: RadarPulseWidget(size: 210),
              ),
              const SizedBox(height: 14),

              // Hero Headings
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TreatTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
                  children: [
                    const TextSpan(text: 'Find Tasty Deals\n'),
                    TextSpan(
                      text: 'Around You 📍',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [TreatColors.secondary, TreatColors.primary, Color(0xFFE53E3E)],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 30)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Share your location to unlock secret foodie platters and instant drops nearby.',
                  textAlign: TextAlign.center,
                  style: TreatTypography.bodyMedium.copyWith(color: TreatColors.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 18),

              // Value Proposition Card
              TreatCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('⚡', style: TextStyle(fontSize: 14))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Instant food deals & table drops within walking distance',
                            style: TreatTypography.bodySmall.copyWith(
                              color: TreatColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: TreatColors.tertiaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('🔒', style: TextStyle(fontSize: 14))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '100% anonymous — never tracked in background',
                            style: TreatTypography.bodySmall.copyWith(
                              color: TreatColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Actions Footer
              TreatButton(
                text: 'Allow Location Access ⚡',
                variant: TreatButtonVariant.purpleGradient,
                onPressed: onEnableLocation,
              ),
              const SizedBox(height: 10),

              TreatButton(
                text: 'Enter City or Zip Code',
                variant: TreatButtonVariant.softSecondary,
                onPressed: onSkip,
              ),
              const SizedBox(height: 6),

              TextButton(
                onPressed: onSkip,
                child: Text(
                  'Not now',
                  style: TreatTypography.bodySmall.copyWith(
                    color: TreatColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Security Guarantee
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 14, color: TreatColors.tertiary),
                  const SizedBox(width: 6),
                  Text(
                    'You can change location permissions anytime in Settings.',
                    style: TreatTypography.bodySmall.copyWith(fontSize: 10, color: TreatColors.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
