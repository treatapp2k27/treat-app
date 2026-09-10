import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../widgets/treat_map_loading_track.dart';

/// The high-fidelity Treat App Opening / Splash Screen
/// Faithfully reproduces the provided HTML/CSS/SVG design:
/// - Gradient background (#f8f0fc -> #f3e6fb -> #eedef7)
/// - Ambient pastel blurred blobs (#fed7ea, #ebdcf9, #e0f4fb)
/// - 8 Floating subtle foodie vector icons with gentle drift animation
/// - Modern iOS status bar / Dynamic Island notch
/// - Centered Treat logo with continuous breathing pulse & glow
/// - Custom animated map trail loading track with hopping character and 3D swinging door
/// - Bottom home indicator pill
/// - Interactive tap-to-skip and optional auto-transition
class TreatOpeningScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final bool autoContinue;
  final Duration autoContinueDelay;

  const TreatOpeningScreen({
    super.key,
    required this.onContinue,
    this.autoContinue = true,
    this.autoContinueDelay = const Duration(milliseconds: 5200),
  });

  @override
  State<TreatOpeningScreen> createState() => _TreatOpeningScreenState();
}

class _TreatOpeningScreenState extends State<TreatOpeningScreen>
    with TickerProviderStateMixin {
  // Logo continuous breathing / glow pulse controller (2.4s cycle)
  late AnimationController _logoPulseController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  // Background foodie vector drift animation controller (5.0s cycle)
  late AnimationController _driftController;

  bool _navigated = false;

  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();

    // 1. Logo pulse controller (2.4s infinite reverse)
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // Keyframes: 0% -> 50% -> 100%
    // Scale: 1.0 -> 0.975 -> 1.0
    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    // Opacity: 1.0 -> 0.35 -> 1.0
    _logoOpacityAnimation = Tween<double>(begin: 1.0, end: 0.35).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    // 2. Ambient food vector drift controller (5s continuous loop)
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    // 3. Auto-continue timer if enabled
    if (widget.autoContinue) {
      _autoTimer = Timer(widget.autoContinueDelay, () {
        if (mounted && !_navigated) {
          _handleContinue();
        }
      });
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _logoPulseController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_navigated) return;
    _navigated = true;
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleContinue,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8F0FC),
                Color(0xFFF3E6FB),
                Color(0xFFEEDEF7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              // 1. Ambient Background Soft Pastel Blobs
              _buildAmbientBlobs(),

              // 2. Floating Subtle Vector Foodie Icons (SVGs with gentle drift)
              _buildFloatingFoodieIcons(),

              // 3. Main Content (iOS status bar, Logo, Map Loading Track, Home Bar)
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Status Bar & Dynamic Island
                    _buildTopStatusBar(),

                    // Centered Branding & Animated Custom Loading Track
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Centered Treat Logo with continuous breathing / blinking pulse
                          _buildBreathingLogo(),

                          const SizedBox(height: 36),

                          // Custom Animated Map Trail Loading Track
                          TreatMapLoadingTrack(
                            width: 320,
                            height: 140,
                            onCycleCompleted: () {
                              // If auto-continue is enabled, complete on cycle end
                              if (widget.autoContinue) {
                                _handleContinue();
                              }
                            },
                          ),

                          const SizedBox(height: 28),

                          // Subtle Skip / Continue Action Pill
                          _buildSkipButton(),
                        ],
                      ),
                    ),

                    // Bottom Safe-Area Bar Indicator
                    _buildBottomIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Ambient Blobs ---
  Widget _buildAmbientBlobs() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Top-left pink blob
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFED7EA).withValues(alpha: 0.40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFED7EA).withValues(alpha: 0.40),
                      blurRadius: 48,
                      spreadRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            // Mid-right lavender blob
            Positioned(
              top: 240,
              right: -64,
              child: Container(
                width: 288,
                height: 288,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEBDCF9).withValues(alpha: 0.70),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEBDCF9).withValues(alpha: 0.70),
                      blurRadius: 48,
                      spreadRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom-left sky blue blob
            Positioned(
              bottom: -64,
              left: 32,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE0F4FB).withValues(alpha: 0.50),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE0F4FB).withValues(alpha: 0.50),
                      blurRadius: 48,
                      spreadRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Floating Foodie Icons ---
  Widget _buildFloatingFoodieIcons() {
    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, _) {
        final t = _driftController.value * 2 * math.pi;
        // Subtle drift translation: translateY up to -8px, rotate up to 5 deg
        final dy1 = math.sin(t) * -8.0;
        final rot1 = math.sin(t) * (5.0 * math.pi / 180.0);

        final dy2 = math.cos(t) * -8.0;
        final rot2 = math.cos(t) * (4.0 * math.pi / 180.0);

        return Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                // 1. Boba Drink Top-Right (purple 20%)
                Positioned(
                  top: 112,
                  right: 40,
                  child: Transform.translate(
                    offset: Offset(0, dy1),
                    child: Transform.rotate(
                      angle: rot1,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.boba,
                        size: 28,
                        color: Color(0x337C52AA),
                      ),
                    ),
                  ),
                ),

                // 2. Dumpling Top-Left (pink 20%)
                Positioned(
                  top: 96,
                  left: 32,
                  child: Transform.translate(
                    offset: Offset(0, dy2),
                    child: Transform.rotate(
                      angle: rot2,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.dumpling,
                        size: 28,
                        color: Color(0x33E040A0),
                      ),
                    ),
                  ),
                ),

                // 3. Pizza Slice Mid-Right (amber 25%)
                Positioned(
                  top: 176,
                  right: 24,
                  child: Transform.translate(
                    offset: Offset(0, dy2),
                    child: Transform.rotate(
                      angle: rot2,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.pizza,
                        size: 24,
                        color: Color(0x40FFB703),
                      ),
                    ),
                  ),
                ),

                // 4. Croissant Mid-Left (amber 25%)
                Positioned(
                  top: 176,
                  left: 24,
                  child: Transform.translate(
                    offset: Offset(0, dy1),
                    child: Transform.rotate(
                      angle: rot1,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.croissant,
                        size: 24,
                        color: Color(0x40FFB703),
                      ),
                    ),
                  ),
                ),

                // 5. Taco Mid-Lower Left (amber 25%)
                Positioned(
                  top: 470,
                  left: 28,
                  child: Transform.translate(
                    offset: Offset(0, dy1),
                    child: Transform.rotate(
                      angle: rot1,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.taco,
                        size: 24,
                        color: Color(0x40FFB703),
                      ),
                    ),
                  ),
                ),

                // 6. Donut Mid-Lower Right (pink 25%)
                Positioned(
                  top: 480,
                  right: 32,
                  child: Transform.translate(
                    offset: Offset(0, dy2),
                    child: Transform.rotate(
                      angle: rot2,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.donut,
                        size: 28,
                        color: Color(0x40E040A0),
                      ),
                    ),
                  ),
                ),

                // 7. Ice Cream Cone Bottom-Left (purple 20%)
                Positioned(
                  bottom: 96,
                  left: 40,
                  child: Transform.translate(
                    offset: Offset(0, dy2),
                    child: Transform.rotate(
                      angle: rot2,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.iceCream,
                        size: 24,
                        color: Color(0x337C52AA),
                      ),
                    ),
                  ),
                ),

                // 8. Burger Bottom-Right (purple 20%)
                Positioned(
                  bottom: 112,
                  right: 48,
                  child: Transform.translate(
                    offset: Offset(0, dy1),
                    child: Transform.rotate(
                      angle: rot1,
                      child: const _FoodieVectorIcon(
                        type: _FoodIconType.burger,
                        size: 24,
                        color: Color(0x337C52AA),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Top Status Bar ---
  Widget _buildTopStatusBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left subtle dot indicator
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C52AA).withValues(alpha: 0.4),
            ),
          ),

          // Center Dynamic Island / Camera Notch
          Container(
            width: 112,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0F172A),
                    border: Border.all(
                      color: const Color(0xFF1E293B),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Minimal Status Indicators (Signal bars & Battery)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cellular signal bars
              CustomPaint(
                size: const Size(16, 12),
                painter: _SignalBarsPainter(color: const Color(0xFF4C267A).withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 6),
              // Battery icon
              Container(
                width: 20,
                height: 10,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: const Color(0xFF4C267A).withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 10,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C267A).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Centered Breathing Logo ---
  Widget _buildBreathingLogo() {
    return AnimatedBuilder(
      animation: _logoPulseController,
      builder: (context, child) {
        final scale = _logoScaleAnimation.value;
        final opacity = _logoOpacityAnimation.value;

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              AssetConstants.logo,
              width: 260,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'treat',
                      style: TreatTypography.displayLarge.copyWith(
                        color: TreatColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(left: 4, top: 22),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: TreatColors.secondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // --- Skip / Continue Action Pill ---
  Widget _buildSkipButton() {
    return InkWell(
      onTap: _handleContinue,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFF7C52AA).withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C52AA).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                'Finding sweet treats near you...',
                style: TreatTypography.bodySmall.copyWith(
                  color: const Color(0xFF4C267A).withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF7C52AA).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Skip',
                style: TreatTypography.labelSmall.copyWith(
                  color: const Color(0xFF7C52AA),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom Safe-Area Bar Indicator ---
  Widget _buildBottomIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Container(
        width: 144,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0xFF7C52AA).withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

// Custom Painter for Signal Bars
class _SignalBarsPainter extends CustomPainter {
  final Color color;

  _SignalBarsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final barW = size.width / 4.5;
    // 4 bars with increasing height
    for (int i = 0; i < 4; i++) {
      final barH = size.height * (0.35 + (0.65 * i / 3));
      final x = i * (barW + 1.5);
      final y = size.height - barH;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barW, barH),
        const Radius.circular(1),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignalBarsPainter oldDelegate) =>
      oldDelegate.color != color;
}

// Enum for Foodie Vector Icons
enum _FoodIconType {
  boba,
  dumpling,
  pizza,
  croissant,
  taco,
  donut,
  iceCream,
  burger,
}

// Custom Vector Foodie Icon Renderer
class _FoodieVectorIcon extends StatelessWidget {
  final _FoodIconType type;
  final double size;
  final Color color;

  const _FoodieVectorIcon({
    required this.type,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FoodiePathPainter(type: type, color: color),
    );
  }
}

class _FoodiePathPainter extends CustomPainter {
  final _FoodIconType type;
  final Color color;

  _FoodiePathPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final path = Path();
    switch (type) {
      case _FoodIconType.boba:
        // Boba cup
        path.moveTo(17, 5);
        path.lineTo(16, 5);
        path.lineTo(16, 3);
        path.cubicTo(16, 2.4, 15.6, 2, 15, 2);
        path.cubicTo(14.4, 2, 14, 2.4, 14, 3);
        path.lineTo(14, 5);
        path.lineTo(10, 5);
        path.lineTo(10, 2);
        path.cubicTo(10, 1.4, 9.6, 1, 9, 1);
        path.cubicTo(8.4, 1, 8, 1.4, 8, 2);
        path.lineTo(8, 5);
        path.lineTo(7, 5);
        path.cubicTo(5.9, 5, 5, 5.9, 5, 7);
        path.lineTo(5, 8);
        path.lineTo(6.4, 8);
        path.lineTo(7.7, 18.6);
        path.cubicTo(8, 20.6, 9.7, 22, 11.7, 22);
        path.lineTo(14.3, 22);
        path.cubicTo(16.3, 22, 18, 20.6, 18.3, 18.6);
        path.lineTo(19.6, 8);
        path.lineTo(20, 8);
        path.lineTo(20, 7);
        path.cubicTo(20, 5.9, 19.1, 5, 17, 5);
        path.close();
        canvas.drawPath(path, paint);
        // Boba pearls
        canvas.drawCircle(const Offset(10.5, 17), 1.2, paint);
        canvas.drawCircle(const Offset(13.5, 17), 1.2, paint);
        canvas.drawCircle(const Offset(12.0, 14), 1.2, paint);
        break;

      case _FoodIconType.dumpling:
        path.moveTo(12, 4);
        path.cubicTo(6.5, 4, 2, 8.5, 2, 14);
        path.cubicTo(2, 17.3, 4.7, 20, 8, 20);
        path.lineTo(16, 20);
        path.cubicTo(19.3, 20, 22, 17.3, 22, 14);
        path.cubicTo(22, 8.5, 17.5, 4, 12, 4);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case _FoodIconType.pizza:
        path.moveTo(12, 2);
        path.cubicTo(6.9, 2, 2.3, 3.6, 0.5, 4.3);
        path.lineTo(10.4, 20.5);
        path.cubicTo(11.2, 21.8, 12.8, 21.8, 13.6, 20.5);
        path.lineTo(23.5, 4.3);
        path.cubicTo(21.7, 3.6, 17.1, 2, 12, 2);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case _FoodIconType.croissant:
        path.moveTo(21.7, 13.6);
        path.cubicTo(21.1, 12.1, 20.0, 10.8, 18.6, 10.0);
        path.cubicTo(17.1, 9.1, 15.4, 8.7, 13.7, 8.8);
        path.cubicTo(11.3, 9.2, 9.2, 10.5, 7.8, 12.5);
        path.cubicTo(6.3, 14.7, 6.5, 17.5, 8.2, 19.4);
        path.cubicTo(10.5, 22.0, 14.6, 22.1, 17.2, 19.8);
        path.cubicTo(19.8, 17.5, 21.6, 15.6, 21.7, 13.6);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case _FoodIconType.taco:
        path.moveTo(20.9, 12.2);
        path.cubicTo(19.7, 7.5, 15.3, 4, 10, 4);
        path.cubicTo(4.5, 4, 0, 8.5, 0, 14);
        path.cubicTo(0, 14.7, 0.1, 15.4, 0.3, 16);
        path.lineTo(19.8, 16);
        path.cubicTo(20.5, 15.1, 20.9, 13.6, 20.9, 12.2);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case _FoodIconType.donut:
        // Outer ring
        path.addOval(const Rect.fromLTWH(2, 2, 20, 20));
        // Inner hole
        final hole = Path()..addOval(const Rect.fromLTWH(8, 8, 8, 8));
        final donutPath = Path.combine(PathOperation.difference, path, hole);
        canvas.drawPath(donutPath, paint);
        break;

      case _FoodIconType.iceCream:
        // Scoops
        path.addOval(const Rect.fromLTWH(7, 2, 10, 10));
        // Cone
        final cone = Path();
        cone.moveTo(7, 11);
        cone.lineTo(17, 11);
        cone.lineTo(12, 22);
        cone.close();
        canvas.drawPath(path, paint);
        canvas.drawPath(cone, paint);
        break;

      case _FoodIconType.burger:
        // Top bun
        path.moveTo(4, 10);
        path.cubicTo(4, 5, 7.5, 3, 12, 3);
        path.cubicTo(16.5, 3, 20, 5, 20, 10);
        path.close();
        // Patty
        final patty = RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 11, 18, 3),
          const Radius.circular(1.5),
        );
        // Bottom bun
        final bottom = RRect.fromRectAndRadius(
          const Rect.fromLTWH(4, 15, 16, 4),
          const Radius.circular(2),
        );
        canvas.drawPath(path, paint);
        canvas.drawRRect(patty, paint);
        canvas.drawRRect(bottom, paint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FoodiePathPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}
