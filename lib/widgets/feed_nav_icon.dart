import 'package:flutter/material.dart';

class FeedNavIcon extends StatelessWidget {
  final Color color;
  final double size;
  final bool isActive;

  const FeedNavIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FeedNavIconPainter(color: color, isActive: isActive),
    );
  }
}

class _FeedNavIconPainter extends CustomPainter {
  final Color color;
  final bool isActive;

  _FeedNavIconPainter({required this.color, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final dim = size.width < size.height ? size.width : size.height;
    final s = dim / 50.0;

    final dx = (size.width - dim) / 2;
    final dy = (size.height - dim) / 2;

    canvas.save();
    canvas.translate(dx, dy);

    // 1. Outer L-shaped Card (Bottom-leftmost corner)
    final pathOuter = Path();
    pathOuter.moveTo(4.0 * s, 26.0 * s);
    pathOuter.lineTo(4.0 * s, 38.0 * s);
    pathOuter.arcToPoint(
      Offset(10.0 * s, 44.0 * s),
      radius: Radius.circular(6.0 * s),
      clockwise: false,
    );
    pathOuter.lineTo(26.0 * s, 44.0 * s);
    pathOuter.lineTo(26.0 * s, 40.0 * s);
    pathOuter.lineTo(10.0 * s, 40.0 * s);
    pathOuter.arcToPoint(
      Offset(8.0 * s, 38.0 * s),
      radius: Radius.circular(2.0 * s),
      clockwise: true,
    );
    pathOuter.lineTo(8.0 * s, 26.0 * s);
    pathOuter.close();
    canvas.drawPath(pathOuter, fillPaint);

    // 2. Middle L-shaped Card
    final pathMiddle = Path();
    pathMiddle.moveTo(13.0 * s, 18.0 * s);
    pathMiddle.lineTo(13.0 * s, 29.0 * s);
    pathMiddle.arcToPoint(
      Offset(19.0 * s, 35.0 * s),
      radius: Radius.circular(6.0 * s),
      clockwise: false,
    );
    pathMiddle.lineTo(35.0 * s, 35.0 * s);
    pathMiddle.lineTo(35.0 * s, 31.0 * s);
    pathMiddle.lineTo(19.0 * s, 31.0 * s);
    pathMiddle.arcToPoint(
      Offset(17.0 * s, 29.0 * s),
      radius: Radius.circular(2.0 * s),
      clockwise: true,
    );
    pathMiddle.lineTo(17.0 * s, 18.0 * s);
    pathMiddle.close();
    canvas.drawPath(pathMiddle, fillPaint);

    // 3. Top-right Card with solid header bar and inner cutout
    final outerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(21.0 * s, 7.0 * s, 24.0 * s, 20.0 * s),
      Radius.circular(4.5 * s),
    );

    final innerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(25.5 * s, 15.0 * s, 15.0 * s, 8.0 * s),
      Radius.circular(2.0 * s),
    );

    final pathTop = Path()
      ..addRRect(outerRRect)
      ..addRRect(innerRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(pathTop, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FeedNavIconPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isActive != isActive;
}
