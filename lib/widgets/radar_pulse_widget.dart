import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';

class RadarPulseWidget extends StatefulWidget {
  final double size;

  const RadarPulseWidget({super.key, this.size = 220.0});

  @override
  State<RadarPulseWidget> createState() => _RadarPulseWidgetState();
}

class _RadarPulseWidgetState extends State<RadarPulseWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Animated Pulse Ring 1
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final val = _pulseController.value;
              return Container(
                width: widget.size * (0.6 + 0.4 * val),
                height: widget.size * (0.6 + 0.4 * val),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: TreatColors.secondary.withValues(alpha: (1 - val) * 0.4),
                    width: 2,
                  ),
                  color: TreatColors.secondaryContainer.withValues(alpha: (1 - val) * 0.15),
                ),
              );
            },
          ),

          // Animated Pulse Ring 2 (Offset)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final val = (_pulseController.value + 0.5) % 1.0;
              return Container(
                width: widget.size * (0.5 + 0.45 * val),
                height: widget.size * (0.5 + 0.45 * val),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: TreatColors.primary.withValues(alpha: (1 - val) * 0.4),
                    width: 1.5,
                  ),
                  color: TreatColors.primaryFixed.withValues(alpha: (1 - val) * 0.15),
                ),
              );
            },
          ),

          // Core Radar Disk
          Container(
            width: widget.size * 0.72,
            height: widget.size * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.85),
              border: Border.all(color: TreatColors.primaryFixed, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(224, 64, 160, 0.15),
                  blurRadius: 40,
                  spreadRadius: 4,
                )
              ],
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.46,
                height: widget.size * 0.46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF2E8FC), Color(0xFFFDF0F7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: TreatColors.purpleGradient,
                      boxShadow: [
                        BoxShadow(
                          color: TreatColors.secondary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text('📍', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating Pin 1: 50% OFF (Top Left)
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = math.sin(_floatController.value * math.pi) * 5;
              return Positioned(
                top: 8 + offset,
                left: -10,
                child: child!,
              );
            },
            child: _buildFloatingTag('🍕', '50% OFF', TreatColors.primary),
          ),

          // Floating Pin 2: Nearby Deals (Bottom Right)
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final offset = math.cos(_floatController.value * math.pi) * 5;
              return Positioned(
                bottom: 8 + offset,
                right: -10,
                child: child!,
              );
            },
            child: _buildFloatingTag('⚡', 'Nearby Deals', TreatColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTag(String emoji, String text, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.12),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TreatTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
