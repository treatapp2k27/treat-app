import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/asset_constants.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';

/// A playful, glossy, jelly-like animated Treat logo
/// Features:
/// 1. Weightless organic levitation (floating & gentle breathing tilt)
/// 2. Interactive Jelly Squish & Bounce on tap (elastic gummy feedback)
/// 3. Synchronized dynamic ground shadow that reacts to float height
/// 4. Whimsical ambient sparkle accents around the droplet splash
class TreatAnimatedLogo extends StatefulWidget {
  final double height;
  final VoidCallback? onTap;

  const TreatAnimatedLogo({
    super.key,
    this.height = 76,
    this.onTap,
  });

  @override
  State<TreatAnimatedLogo> createState() => _TreatAnimatedLogoState();
}

class _TreatAnimatedLogoState extends State<TreatAnimatedLogo>
    with TickerProviderStateMixin {
  // Continuous gentle floating animation
  late AnimationController _floatController;

  // Squish & bounce interactive physics animation
  late AnimationController _squishController;

  // Sparkle twinkle rotation & pulse
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();

    // 1. Soothing float loop
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    // 2. Interactive Squish controller
    _squishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // 3. Sparkle pulse loop
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _squishController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  void _triggerSquish() {
    _squishController.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _triggerSquish,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _squishController,
          _sparkleController,
        ]),
        builder: (context, child) {
          // Floating physics (sine wave)
          final tFloat = _floatController.value * 2 * math.pi;
          final floatOffset = math.sin(tFloat) * 4.5; // -4.5 to +4.5 px
          final tiltAngle = math.sin(tFloat * 0.9) * 0.025; // ~1.4 degrees tilt
          final breatheScale = 1.0 + (math.cos(tFloat) * 0.015);

          // Squish & bounce physics curve (decaying oscillation)
          double squishScaleX = 1.0;
          double squishScaleY = 1.0;
          double squishDy = 0.0;

          if (_squishController.isAnimating) {
            final p = _squishController.value;
            // 0.0 - 0.2: Squash down
            // 0.2 - 0.5: Stretch up
            // 0.5 - 0.75: Secondary bounce
            // 0.75 - 1.0: Settle
            final damping = math.exp(-4.0 * p);
            final wave = math.sin(p * math.pi * 3.5);
            squishScaleX = 1.0 + (0.22 * damping * -wave);
            squishScaleY = 1.0 + (0.22 * damping * wave);
            squishDy = 6.0 * damping * wave;
          }

          // Combined transforms
          final totalScaleX = breatheScale * squishScaleX;
          final totalScaleY = breatheScale * squishScaleY;
          final totalDy = floatOffset + squishDy;

          // Dynamic shadow intensity (softer when higher, tighter when lower)
          final shadowNormalized = (floatOffset + 4.5) / 9.0; // 0.0 (high) to 1.0 (low)
          final shadowWidth = widget.height * 1.7 * (0.85 + 0.15 * shadowNormalized);
          final shadowOpacity = 0.14 + (0.10 * shadowNormalized);
          final shadowBlur = 14.0 - (4.0 * shadowNormalized);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Ambient candy glow aura behind the logo
                  Positioned(
                    child: Container(
                      width: widget.height * 2.2,
                      height: widget.height * 1.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C52AA).withValues(alpha: 0.18),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: const Color(0xFFE040A0).withValues(alpha: 0.12),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating & Squishing Logo Body
                  Transform.translate(
                    offset: Offset(0, totalDy),
                    child: Transform.rotate(
                      angle: tiltAngle,
                      child: Transform.scale(
                        scaleX: totalScaleX,
                        scaleY: totalScaleY,
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // The 3D Bubble Candy Treat Logo Image
                            Image.asset(
                              AssetConstants.logo,
                              height: widget.height,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'treat',
                                      style: TreatTypography.displayLarge.copyWith(
                                        color: TreatColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(left: 2, top: 18),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: TreatColors.secondary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            // Playful Sparkle 1 (Top right above droplets)
                            Positioned(
                              top: -4,
                              right: 2,
                              child: _buildSparkle(
                                phase: 0.0,
                                size: 14,
                                color: const Color(0xFFFFB800),
                              ),
                            ),

                            // Playful Sparkle 2 (Over the cute leaf)
                            Positioned(
                              top: 2,
                              left: widget.height * 0.85,
                              child: _buildSparkle(
                                phase: 0.4,
                                size: 10,
                                color: const Color(0xFFE040A0),
                              ),
                            ),

                            // Playful Sparkle 3 (Lower splash droplet)
                            Positioned(
                              bottom: 10,
                              right: -6,
                              child: _buildSparkle(
                                phase: 0.7,
                                size: 9,
                                color: const Color(0xFF7C52AA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Synchronized Ground Shadow (reacts to elevation)
              Container(
                width: shadowWidth,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF633990).withValues(alpha: shadowOpacity),
                      blurRadius: shadowBlur,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSparkle({
    required double phase,
    required double size,
    required Color color,
  }) {
    final progress = (_sparkleController.value + phase) % 1.0;
    // Pulse scale 0.4 -> 1.2 -> 0.4
    final scale = 0.4 + (0.8 * math.sin(progress * math.pi));
    final angle = progress * 2 * math.pi;

    return Transform.rotate(
      angle: angle,
      child: Transform.scale(
        scale: scale,
        child: Icon(
          Icons.auto_awesome,
          size: size,
          color: color.withValues(alpha: 0.75 + (0.25 * math.sin(progress * math.pi))),
        ),
      ),
    );
  }
}
