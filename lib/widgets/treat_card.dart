import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';

class TreatCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  const TreatCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius = 24.0,
    this.border,
    this.shadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (gradient == null ? TreatColors.surfaceContainerLowest : null),
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: const Color.fromRGBO(124, 82, 170, 0.14),
              width: 1.2,
            ),
        boxShadow: shadows ?? TreatColors.candyShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }
    return card;
  }
}
