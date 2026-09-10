import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Interactive SVG-grade Animated Map Loading Track
/// Features:
/// 1. Dotted curve track (M 28 82 Q 78 58, 126 78 T 226 78 L 252 78)
/// 2. Active multi-color gradient line fill (Pink -> Purple -> Amber)
/// 3. Starting landmark pin
/// 4. Detailed restaurant building with scalloped awning, lantern, cutlery badge,
///    planter, glowing interior, twinkly sparkles, and 3D swinging door
/// 5. Cheerful character traveling along the track with bouncy hopping physics,
///    squash-and-stretch, magnifying glass tilt, and disappearing into the open doorway!
class TreatMapLoadingTrack extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onCycleCompleted;

  const TreatMapLoadingTrack({
    super.key,
    this.width = 320,
    this.height = 140,
    this.onCycleCompleted,
  });

  @override
  State<TreatMapLoadingTrack> createState() => _TreatMapLoadingTrackState();
}

class _TreatMapLoadingTrackState extends State<TreatMapLoadingTrack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 4.8s master timeline matching HTML keyframes
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCycleCompleted?.call();
          _controller.forward(from: 0.0);
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value; // 0.0 .. 1.0

          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _MapTrackPainter(t: t),
          );
        },
      ),
    );
  }
}

class _MapTrackPainter extends CustomPainter {
  final double t; // 0.0 to 1.0 progress of the 4.8s cycle

  _MapTrackPainter({required this.t});

  // Base canvas coordinate space: 300 x 120
  static const double baseWidth = 300.0;
  static const double baseHeight = 120.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale canvas to fit viewBox 0 0 300 120
    final scale = math.min(size.width / baseWidth, size.height / baseHeight);
    final dx = (size.width - baseWidth * scale) / 2;
    final dy = (size.height - baseHeight * scale) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    // Build the track path: M 28 82 Q 78 58, 126 78 T 226 78 L 252 78
    final trackPath = Path();
    trackPath.moveTo(28, 82);
    trackPath.quadraticBezierTo(78, 58, 126, 78);
    // Smooth continuation (T in SVG): reflected control point across (126, 78) is (174, 98)
    trackPath.quadraticBezierTo(174, 98, 226, 78);
    trackPath.lineTo(252, 78);

    // 1. Draw Dotted Background Guide Track (#EBDCF9, dash 3 on, 7 off, width 4.5)
    _drawDashedPath(
      canvas: canvas,
      path: trackPath,
      color: const Color(0xFFEBDCF9),
      strokeWidth: 4.5,
      dashLength: 3.0,
      gapLength: 7.0,
    );

    // 2. Active Animated Line Fill (Smoothly filling from start pin to restaurant door)
    // 0% -> 72%: stroke drawn from 0 to full length (~240px)
    // 72% -> 88%: remains full
    // 96% -> 100%: resets
    final lineProgress = _calculateLineProgress(t);
    if (lineProgress > 0.001) {
      _drawProgressLine(canvas, trackPath, lineProgress);
    }

    // 3. Cute Map Landmark Pin (Starting Point at x=28, y=66)
    _drawStartPin(canvas);

    // 4. Restaurant Building & Entrance Door (Destination at x=228, y=22)
    _drawRestaurant(canvas, t);

    // 5. Person Hopping & Jumping along the Path
    _drawPerson(canvas, t);

    canvas.restore();
  }

  double _calculateLineProgress(double t) {
    if (t <= 0.72) {
      // Ease in out fill
      return (t / 0.72).clamp(0.0, 1.0);
    } else if (t <= 0.88) {
      return 1.0;
    } else if (t <= 0.96) {
      return 1.0;
    } else {
      // Reset from 96% to 100%
      return ((1.0 - t) / 0.04).clamp(0.0, 1.0);
    }
  }

  void _drawDashedPath({
    required Canvas canvas,
    required Path path,
    required Color color,
    required double strokeWidth,
    required double dashLength,
    required double gapLength,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = math.min(dashLength, metric.length - distance);
        final segment = metric.extractPath(distance, distance + len);
        canvas.drawPath(segment, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  void _drawProgressLine(Canvas canvas, Path path, double progress) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final totalLength = metric.length;
    final drawLength = totalLength * progress;
    final extract = metric.extractPath(0, drawLength);

    final shader = ui.Gradient.linear(
      const Offset(28, 78),
      const Offset(252, 78),
      const [
        Color(0xFFE040A0), // Pink
        Color(0xFF7C52AA), // Purple
        Color(0xFFFFB703), // Amber
      ],
      [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = shader
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(extract, paint);
  }

  void _drawStartPin(Canvas canvas) {
    canvas.save();
    canvas.translate(18, 56);

    // Drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF633990).withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawCircle(const Offset(10, 13.5), 7.5, shadowPaint);

    // Outer circle
    final outerFill = Paint()..color = const Color(0xFFFCE7F3);
    final outerStroke = Paint()
      ..color = const Color(0xFFE040A0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(const Offset(10, 10), 7.5, outerFill);
    canvas.drawCircle(const Offset(10, 10), 7.5, outerStroke);

    // Inner dot
    final innerDot = Paint()..color = const Color(0xFFE040A0);
    canvas.drawCircle(const Offset(10, 10), 3.0, innerDot);

    canvas.restore();
  }

  void _drawRestaurant(Canvas canvas, double t) {
    canvas.save();
    canvas.translate(228, 22);

    // 1. Sparkles around shop header (Active when t in 0.68 .. 0.94)
    double sparkleOpacity = 0.0;
    double sparkleScale = 0.4;
    if (t >= 0.68 && t <= 0.94) {
      if (t < 0.75) {
        final p = (t - 0.68) / (0.75 - 0.68);
        sparkleOpacity = p;
        sparkleScale = 0.4 + 0.7 * p;
      } else if (t <= 0.86) {
        sparkleOpacity = 1.0;
        sparkleScale = 1.1;
      } else {
        final p = (0.94 - t) / (0.94 - 0.86);
        sparkleOpacity = p;
        sparkleScale = 0.4 + 0.7 * p;
      }
    }

    if (sparkleOpacity > 0.01) {
      canvas.save();
      // Little circle sparkle
      final sparklePaint = Paint()
        ..color = const Color(0xFFFFB703).withValues(alpha: sparkleOpacity);
      canvas.drawCircle(const Offset(10, 12), 1.8 * sparkleScale, sparklePaint);

      // Star sparkle at (48, 8)
      canvas.translate(48, 8);
      canvas.scale(sparkleScale, sparkleScale);
      final starPath = Path();
      starPath.moveTo(0, -6);
      starPath.lineTo(2, -2);
      starPath.lineTo(6, 0);
      starPath.lineTo(2, 2);
      starPath.lineTo(0, 6);
      starPath.lineTo(-2, 2);
      starPath.lineTo(-6, 0);
      starPath.lineTo(-2, -2);
      starPath.close();
      canvas.drawPath(starPath, sparklePaint);
      canvas.restore();
    }

    // 2. Facade Walls: rect x=8, y=38, w=40, h=42, rx=4
    final facadeRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 38, 40, 42),
      const Radius.circular(4),
    );
    // Shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF633990).withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    canvas.drawRRect(facadeRRect.shift(const Offset(0, 3)), shadowPaint);

    final facadeFill = Paint()..color = Colors.white;
    final facadeStroke = Paint()
      ..color = const Color(0xFF7C52AA)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(facadeRRect, facadeFill);
    canvas.drawRRect(facadeRRect, facadeStroke);

    // 3. Welcoming Warm Illuminated Doorway Halo (Glowing when door opens)
    // t: 0..0.68: opacity 0.15; 0.74..0.88: opacity 1.0; 0.96..1.0: opacity 0.15
    double doorGlowOpacity = 0.15;
    if (t >= 0.68 && t <= 0.96) {
      if (t < 0.74) {
        final p = (t - 0.68) / (0.74 - 0.68);
        doorGlowOpacity = 0.15 + (0.85 * p);
      } else if (t <= 0.88) {
        doorGlowOpacity = 1.0;
      } else {
        final p = (0.96 - t) / (0.96 - 0.88);
        doorGlowOpacity = 0.15 + (0.85 * p);
      }
    }

    final doorRect = const Rect.fromLTWH(17, 44, 22, 36);
    final doorRRect = RRect.fromRectAndRadius(doorRect, const Radius.circular(3));

    // Warm radial gradient glow
    final glowShader = ui.Gradient.radial(
      const Offset(28, 62),
      20,
      [
        const Color(0xFFFFFBEB).withValues(alpha: doorGlowOpacity),
        const Color(0xFFFDE68A).withValues(alpha: doorGlowOpacity * 0.95),
        const Color(0xFFF59E0B).withValues(alpha: 0.0),
      ],
      [0.0, 0.6, 1.0],
    );
    final glowPaint = Paint()..shader = glowShader;
    canvas.drawRRect(doorRRect, glowPaint);

    // Halo glow shadow when door is fully open
    if (doorGlowOpacity > 0.4) {
      final glowHalo = Paint()
        ..color = const Color(0xFFFFB703).withValues(alpha: (doorGlowOpacity - 0.2).clamp(0.0, 0.75))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0 * doorGlowOpacity);
      canvas.drawRRect(doorRRect, glowHalo);
    }

    // 4. The Welcoming Entrance Door (Swings open in 3D perspective!)
    // 0..0.68: 0deg, 0.76..0.88: -70deg, 0.96..1.0: 0deg
    double doorAngleDeg = 0.0;
    if (t >= 0.68 && t <= 0.96) {
      if (t < 0.76) {
        final p = Curves.easeInOut.transform((t - 0.68) / (0.76 - 0.68));
        doorAngleDeg = -70.0 * p;
      } else if (t <= 0.88) {
        doorAngleDeg = -70.0;
      } else {
        final p = Curves.easeInOut.transform((0.96 - t) / (0.96 - 0.88));
        doorAngleDeg = -70.0 * p;
      }
    }

    canvas.save();
    // Pivot at left edge of door (x=17, y=62)
    canvas.translate(17, 62);
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.003) // Perspective distortion
      ..rotateY(doorAngleDeg * math.pi / 180.0);
    canvas.transform(matrix.storage);
    canvas.translate(-17, -62);

    // Door body
    final doorBodyPaint = Paint()..color = const Color(0xFF7C52AA);
    final doorBorderPaint = Paint()
      ..color = const Color(0xFF5A2F89)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(doorRRect, doorBodyPaint);
    canvas.drawRRect(doorRRect, doorBorderPaint);

    // Door window glass (x=20, y=48, w=16, h=15, rx=2)
    final glassRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 48, 16, 15),
      const Radius.circular(2),
    );
    final glassPaint = Paint()..color = const Color(0xFFE0F2FE).withValues(alpha: 0.85);
    canvas.drawRRect(glassRRect, glassPaint);

    // Mullion line
    final mullionPaint = Paint()
      ..color = const Color(0xFF7C52AA)
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(28, 48), const Offset(28, 63), mullionPaint);

    // Golden door knob at (34, 65)
    final knobPaint = Paint()..color = const Color(0xFFFFB703);
    canvas.drawCircle(const Offset(34, 65), 1.8, knobPaint);

    canvas.restore(); // End door 3D transform

    // 5. Planter box next to door (x=39, y=72, w=8, h=8)
    final planterRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(39, 72, 8, 8),
      const Radius.circular(2),
    );
    final planterPaint = Paint()..color = const Color(0xFF7C52AA);
    canvas.drawRRect(planterRRect, planterPaint);
    // Cute succulent plant leaves
    final leafPaint1 = Paint()..color = const Color(0xFF10B981);
    final leafPaint2 = Paint()..color = const Color(0xFF34D399);
    canvas.drawCircle(const Offset(41, 70), 3.0, leafPaint1);
    canvas.drawCircle(const Offset(45, 69), 3.5, leafPaint2);

    // 6. Bistro Hanging Lantern (x=28, y=18 to 24)
    final lanternLinePaint = Paint()
      ..color = const Color(0xFF7C52AA)
      ..strokeWidth = 2.0;
    canvas.drawLine(const Offset(28, 18), const Offset(28, 24), lanternLinePaint);
    final lanternBulbPaint = Paint()..color = const Color(0xFFFFB703);
    canvas.drawCircle(const Offset(28, 18), 4.0, lanternBulbPaint);

    // Golden cutlery badge motif above door (x=28, y=32)
    final badgePaint = Paint()..color = const Color(0xFFFFB703);
    canvas.drawCircle(const Offset(28, 32), 3.0, badgePaint);

    // 7. Striped Scalloped Awning Canopy
    final awningPath = Path();
    awningPath.moveTo(4, 28);
    awningPath.cubicTo(4, 28, 12, 24, 28, 24);
    awningPath.cubicTo(44, 24, 52, 28, 52, 28);
    awningPath.lineTo(56, 36);
    // Scallops
    awningPath.cubicTo(56, 38, 54, 40, 51, 40);
    awningPath.cubicTo(48, 40, 46, 38, 46, 38);
    awningPath.cubicTo(46, 38, 44, 40, 41, 40);
    awningPath.cubicTo(38, 40, 36, 38, 36, 38);
    awningPath.cubicTo(36, 38, 34, 40, 31, 40);
    awningPath.cubicTo(28, 40, 26, 38, 26, 38);
    awningPath.cubicTo(26, 38, 24, 40, 21, 40);
    awningPath.cubicTo(18, 40, 16, 38, 16, 38);
    awningPath.cubicTo(16, 38, 14, 40, 11, 40);
    awningPath.cubicTo(8, 40, 6, 38, 6, 38);
    awningPath.cubicTo(6, 38, 4, 40, 2, 38);
    awningPath.lineTo(4, 28);
    awningPath.close();

    final awningPaint = Paint()..color = const Color(0xFFE040A0);
    canvas.drawPath(awningPath, awningPaint);

    // Candy Stripes on Awning (#FEF7FF at 0.9 opacity)
    final stripePaint = Paint()..color = const Color(0xFFFEF7FF).withValues(alpha: 0.9);

    final stripe1 = Path()
      ..moveTo(12, 25)
      ..lineTo(14, 39)
      ..lineTo(20, 38)
      ..lineTo(19, 24)
      ..close();
    canvas.drawPath(stripe1, stripePaint);

    final stripe2 = Path()
      ..moveTo(27, 24)
      ..lineTo(27, 38)
      ..lineTo(33, 38)
      ..lineTo(34, 24)
      ..close();
    canvas.drawPath(stripe2, stripePaint);

    final stripe3 = Path()
      ..moveTo(42, 25)
      ..lineTo(40, 38)
      ..lineTo(46, 38)
      ..lineTo(48, 26)
      ..close();
    canvas.drawPath(stripe3, stripePaint);

    canvas.restore(); // End restaurant
  }

  void _drawPerson(Canvas canvas, double t) {
    // Calculate person position, scale, and opacity from characterTravel keyframes
    final travel = _calculatePersonTravel(t);
    if (travel.opacity <= 0.001) return;

    // Cheerful hop bounce (0.48s period = 10 hops per 4.8s travel)
    final hopPhase = (t * 10.0) % 1.0;
    final hop = _calculatePersonHop(hopPhase);

    // Magnifying glass tilt (0.96s period = 5 cycles per 4.8s travel)
    final glassPhase = (t * 5.0) % 1.0;
    final glassAngle = _calculateGlassAngle(glassPhase);

    canvas.save();
    canvas.translate(travel.x, travel.y);
    canvas.scale(travel.scale, travel.scale);

    // Apply hopping translation, squash & stretch, and tilt
    canvas.translate(0, hop.dy);
    canvas.translate(17, 22); // Center of mass
    canvas.rotate(hop.rotation);
    canvas.scale(hop.scaleX, hop.scaleY);
    canvas.translate(-17, -22);

    // Alpha / Opacity wrapper
    final alpha = (travel.opacity * 255).round().clamp(0, 255);

    // Cute Drop Shadow under person
    final shadowPaint = Paint()
      ..color = const Color(0xFF633990).withAlpha((alpha * 0.20).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawOval(
      const Rect.fromLTWH(8, 32, 18, 5),
      shadowPaint,
    );

    // 1. Hopping Legs / Cute Feet
    final footPaint = Paint()..color = const Color(0xFF4C267A).withAlpha(alpha);
    final legPaint = Paint()
      ..color = const Color(0xFF4C267A).withAlpha(alpha)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Left foot
    canvas.drawOval(const Rect.fromLTWH(9.5, 31, 7, 4), footPaint);
    canvas.drawLine(const Offset(15, 28), const Offset(13, 33), legPaint);

    // Right foot
    canvas.drawOval(const Rect.fromLTWH(16.5, 31, 7, 4), footPaint);
    canvas.drawLine(const Offset(18, 28), const Offset(20, 33), legPaint);

    // 2. Joyful Pullover / Body (rect x=10, y=18, w=15, h=14, rx=7)
    final bodyPaint = Paint()..color = const Color(0xFF7C52AA).withAlpha(alpha);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 18, 15, 14),
        const Radius.circular(7),
      ),
      bodyPaint,
    );

    // 3. Treat Crossbody Bag Strap & Golden Hip-pack
    final strapPaint = Paint()
      ..color = const Color(0xFFFFB703).withAlpha(alpha)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final strapPath = Path()
      ..moveTo(11, 19)
      ..quadraticBezierTo(17, 24, 22, 27);
    canvas.drawPath(strapPath, strapPaint);

    final hipPackPaint = Paint()..color = const Color(0xFFFFB703).withAlpha(alpha);
    canvas.drawCircle(const Offset(20, 26), 2.8, hipPackPaint);

    // 4. Cheerful Round Head (cx=17, cy=11, r=8.5, #FCD34D)
    final headPaint = Paint()..color = const Color(0xFFFCD34D).withAlpha(alpha);
    canvas.drawCircle(const Offset(17, 11), 8.5, headPaint);

    // Playful Hot Pink Cap / Beret (#E040A0)
    final beretPaint = Paint()..color = const Color(0xFFE040A0).withAlpha(alpha);
    final beretPath = Path();
    beretPath.moveTo(9, 10);
    beretPath.cubicTo(9, 4, 24, 3, 26, 9);
    beretPath.cubicTo(27, 12, 8, 13, 9, 10);
    beretPath.close();
    canvas.drawPath(beretPath, beretPaint);
    // Pompom on cap
    canvas.drawCircle(const Offset(17, 4), 2.0, beretPaint);

    // Rosy Cheek & Happy Eye
    final cheekPaint = Paint()
      ..color = const Color(0xFFF472B6).withAlpha((alpha * 0.6).round());
    canvas.drawCircle(const Offset(20, 13), 1.6, cheekPaint);

    final eyePaint = Paint()..color = const Color(0xFF4C267A).withAlpha(alpha);
    canvas.drawCircle(const Offset(21, 10), 1.2, eyePaint);

    // 5. Arm reaching forward (M 17 22 C 21 22, 24 23, 26 19)
    final armPaint = Paint()
      ..color = const Color(0xFF7C52AA).withAlpha(alpha)
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final armPath = Path();
    armPath.moveTo(17, 22);
    armPath.cubicTo(21, 22, 24, 23, 26, 19);
    canvas.drawPath(armPath, armPaint);

    // 6. Magnifying Glass Scanning Ahead (tilting with glassAngle)
    canvas.save();
    canvas.translate(24, 11);
    canvas.translate(10, 6); // Pivot at glass center
    canvas.rotate(glassAngle);
    canvas.translate(-10, -6);

    // Glass rim & lens (cx=10, cy=6, r=7)
    final lensFill = Paint()
      ..color = const Color(0xFFE0F2FE).withAlpha((alpha * 0.65).round());
    final lensRim = Paint()
      ..color = const Color(0xFFE040A0).withAlpha(alpha)
      ..strokeWidth = 2.3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(const Offset(10, 6), 7.0, lensFill);
    canvas.drawCircle(const Offset(10, 6), 7.0, lensRim);

    // White curved glint reflection on glass
    final glintPaint = Paint()
      ..color = Colors.white.withAlpha(alpha)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final glintPath = Path()
      ..moveTo(8, 4)
      ..quadraticBezierTo(10, 3, 12, 4);
    canvas.drawPath(glintPath, glintPaint);

    // Golden handle from (5, 11) to (1, 17)
    final handlePaint = Paint()
      ..color = const Color(0xFFFFB703).withAlpha(alpha)
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(5, 11), const Offset(1, 17), handlePaint);

    canvas.restore(); // End magnifying glass

    // 7. Playful Hop Wind Sparkles behind character
    final windSparkle1 = Paint()
      ..color = const Color(0xFFE040A0).withAlpha((alpha * 0.6).round());
    canvas.drawCircle(const Offset(2, 28), 1.6, windSparkle1);

    final windSparkle2 = Paint()
      ..color = const Color(0xFFFFB703).withAlpha((alpha * 0.7).round());
    canvas.drawCircle(const Offset(5, 32), 1.2, windSparkle2);

    canvas.restore(); // End person
  }

  // Keyframe table from CSS @keyframes characterTravel
  _TravelState _calculatePersonTravel(double t) {
    if (t <= 0.0) {
      return const _TravelState(x: 16, y: 46, opacity: 0.0, scale: 1.0);
    } else if (t <= 0.05) {
      final p = t / 0.05;
      return _TravelState(
        x: ui.lerpDouble(16, 22, p)!,
        y: 46,
        opacity: p,
        scale: 1.0,
      );
    } else if (t <= 0.18) {
      final p = (t - 0.05) / 0.13;
      return _TravelState(
        x: ui.lerpDouble(22, 62, p)!,
        y: ui.lerpDouble(46, 32, p)!,
        opacity: 1.0,
        scale: 1.0,
      );
    } else if (t <= 0.35) {
      final p = (t - 0.18) / 0.17;
      return _TravelState(
        x: ui.lerpDouble(62, 114, p)!,
        y: ui.lerpDouble(32, 40, p)!,
        opacity: 1.0,
        scale: 1.0,
      );
    } else if (t <= 0.52) {
      final p = (t - 0.35) / 0.17;
      return _TravelState(
        x: ui.lerpDouble(114, 168, p)!,
        y: ui.lerpDouble(40, 48, p)!,
        opacity: 1.0,
        scale: 1.0,
      );
    } else if (t <= 0.70) {
      final p = (t - 0.52) / 0.18;
      return _TravelState(
        x: ui.lerpDouble(168, 218, p)!,
        y: ui.lerpDouble(48, 42, p)!,
        opacity: 1.0,
        scale: 1.0,
      );
    } else if (t <= 0.76) {
      final p = (t - 0.70) / 0.06;
      return _TravelState(
        x: ui.lerpDouble(218, 234, p)!,
        y: 42,
        opacity: 1.0,
        scale: ui.lerpDouble(1.0, 0.85, p)!,
      );
    } else if (t <= 0.84) {
      // Entering shop door
      final p = (t - 0.76) / 0.08;
      return _TravelState(
        x: ui.lerpDouble(234, 242, p)!,
        y: 42,
        opacity: ui.lerpDouble(1.0, 0.8, p)!,
        scale: ui.lerpDouble(0.85, 0.35, p)!,
      );
    } else if (t <= 0.88) {
      // Disappearing inside
      final p = (t - 0.84) / 0.04;
      return _TravelState(
        x: ui.lerpDouble(242, 246, p)!,
        y: 42,
        opacity: ui.lerpDouble(0.8, 0.0, p)!,
        scale: ui.lerpDouble(0.35, 0.1, p)!,
      );
    } else {
      return const _TravelState(x: 16, y: 46, opacity: 0.0, scale: 1.0);
    }
  }

  // Keyframe table from CSS @keyframes characterHop
  _HopState _calculatePersonHop(double p) {
    if (p <= 0.45) {
      final norm = p / 0.45;
      return _HopState(
        dy: ui.lerpDouble(0, -16, norm)!,
        scaleX: ui.lerpDouble(1.0, 0.95, norm)!,
        scaleY: ui.lerpDouble(0.92, 1.08, norm)!,
        rotation: ui.lerpDouble(0, 4 * math.pi / 180, norm)!,
      );
    } else if (p <= 0.70) {
      final norm = (p - 0.45) / 0.25;
      return _HopState(
        dy: ui.lerpDouble(-16, -12, norm)!,
        scaleX: ui.lerpDouble(0.95, 1.0, norm)!,
        scaleY: ui.lerpDouble(1.08, 1.0, norm)!,
        rotation: ui.lerpDouble(4 * math.pi / 180, 2 * math.pi / 180, norm)!,
      );
    } else if (p <= 0.90) {
      final norm = (p - 0.70) / 0.20;
      return _HopState(
        dy: ui.lerpDouble(-12, 1, norm)!,
        scaleX: ui.lerpDouble(1.0, 1.04, norm)!,
        scaleY: ui.lerpDouble(1.0, 0.94, norm)!,
        rotation: ui.lerpDouble(2 * math.pi / 180, 0, norm)!,
      );
    } else {
      final norm = (p - 0.90) / 0.10;
      return _HopState(
        dy: ui.lerpDouble(1, 0, norm)!,
        scaleX: ui.lerpDouble(1.04, 1.0, norm)!,
        scaleY: ui.lerpDouble(0.94, 0.92, norm)!,
        rotation: 0.0,
      );
    }
  }

  // Keyframe from CSS @keyframes glassInspect (-8deg to +15deg)
  double _calculateGlassAngle(double p) {
    final sine = math.sin(p * 2 * math.pi); // -1.0 to 1.0
    // Center at ~3.5 deg, swing amplitude 11.5 deg -> range -8deg to +15deg
    final deg = 3.5 + (11.5 * sine);
    return deg * math.pi / 180.0;
  }

  @override
  bool shouldRepaint(covariant _MapTrackPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _TravelState {
  final double x;
  final double y;
  final double opacity;
  final double scale;

  const _TravelState({
    required this.x,
    required this.y,
    required this.opacity,
    required this.scale,
  });
}

class _HopState {
  final double dy;
  final double scaleX;
  final double scaleY;
  final double rotation;

  const _HopState({
    required this.dy,
    required this.scaleX,
    required this.scaleY,
    required this.rotation,
  });
}
