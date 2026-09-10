import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';

class StylizedQrStub extends StatelessWidget {
  final double size;

  const StylizedQrStub({super.key, this.size = 140.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(46, 26, 40, 0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: CustomPaint(
        size: Size(size - 16, size - 16),
        painter: _StylizedQrPainter(),
      ),
    );
  }
}

class _StylizedQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()..color = TreatColors.onSurface;
    final pinkPaint = Paint()..color = TreatColors.primary;
    final purplePaint = Paint()..color = TreatColors.secondary;
    final cyanPaint = Paint()..color = TreatColors.tertiary;

    final scale = size.width / 100.0;

    void drawCornerFinder(double x, double y) {
      // Outer rect
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x * scale, y * scale, 28 * scale, 28 * scale),
          Radius.circular(4 * scale),
        ),
        darkPaint,
      );
      // White inner ring
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH((x + 6) * scale, (y + 6) * scale, 16 * scale, 16 * scale),
          Radius.circular(2 * scale),
        ),
        Paint()..color = Colors.white,
      );
      // Pink center dot
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH((x + 10) * scale, (y + 10) * scale, 8 * scale, 8 * scale),
          Radius.circular(1.5 * scale),
        ),
        pinkPaint,
      );
    }

    // Three QR corners
    drawCornerFinder(5, 5); // Top-left
    drawCornerFinder(67, 5); // Top-right
    drawCornerFinder(5, 67); // Bottom-left

    // Decorative matrix data blocks
    void drawBlock(double x, double y, double w, double h, Paint p) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x * scale, y * scale, w * scale, h * scale),
          Radius.circular(2 * scale),
        ),
        p,
      );
    }

    drawBlock(38, 7, 6, 6, purplePaint);
    drawBlock(48, 7, 8, 6, darkPaint);
    drawBlock(38, 18, 8, 8, darkPaint);
    drawBlock(52, 18, 7, 7, cyanPaint);
    drawBlock(8, 38, 6, 6, darkPaint);
    drawBlock(18, 38, 8, 7, purplePaint);
    drawBlock(8, 50, 7, 6, darkPaint);
    drawBlock(20, 50, 6, 9, pinkPaint);
    drawBlock(36, 36, 9, 9, pinkPaint);
    drawBlock(50, 36, 7, 7, darkPaint);
    drawBlock(63, 38, 9, 7, purplePaint);
    drawBlock(78, 38, 14, 6, darkPaint);
    drawBlock(38, 52, 7, 10, darkPaint);
    drawBlock(50, 49, 12, 6, cyanPaint);
    drawBlock(68, 50, 6, 12, darkPaint);
    drawBlock(80, 50, 12, 7, purplePaint);
    drawBlock(38, 68, 12, 7, darkPaint);
    drawBlock(54, 68, 7, 7, pinkPaint);
    drawBlock(68, 68, 10, 6, darkPaint);
    drawBlock(84, 65, 8, 10, cyanPaint);
    drawBlock(38, 81, 8, 11, purplePaint);
    drawBlock(50, 81, 15, 6, darkPaint);
    drawBlock(70, 80, 8, 12, pinkPaint);
    drawBlock(83, 82, 9, 10, darkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
