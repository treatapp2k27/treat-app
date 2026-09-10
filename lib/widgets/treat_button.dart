import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';

enum TreatButtonVariant {
  purpleGradient,
  pinkGradient,
  solidSecondary,
  softSecondary,
  outline,
}

class TreatButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? trailing;
  final TreatButtonVariant variant;
  final double? width;
  final double height;
  final bool isLoading;

  const TreatButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.trailing,
    this.variant = TreatButtonVariant.purpleGradient,
    this.width,
    this.height = 52.0,
    this.isLoading = false,
  });

  @override
  State<TreatButton> createState() => _TreatButtonState();
}

class _TreatButtonState extends State<TreatButton> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_anim);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Gradient? gradient;
    Color? bgColor;
    Color textColor = Colors.white;
    Border? border;
    List<BoxShadow> shadows = [];

    switch (widget.variant) {
      case TreatButtonVariant.purpleGradient:
        gradient = TreatColors.purpleGradient;
        shadows = TreatColors.pillShadow;
        break;
      case TreatButtonVariant.pinkGradient:
        gradient = TreatColors.pinkGradient;
        shadows = TreatColors.pinkPillShadow;
        break;
      case TreatButtonVariant.solidSecondary:
        bgColor = TreatColors.secondary;
        shadows = TreatColors.pillShadow;
        break;
      case TreatButtonVariant.softSecondary:
        bgColor = TreatColors.surfaceContainerLow;
        textColor = TreatColors.secondary;
        border = Border.all(color: TreatColors.outlineVariant);
        break;
      case TreatButtonVariant.outline:
        bgColor = Colors.transparent;
        textColor = TreatColors.secondary;
        border = Border.all(color: TreatColors.secondary, width: 1.5);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => _anim.forward(),
      onTapUp: (_) {
        _anim.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _anim.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: gradient,
            color: bgColor,
            borderRadius: BorderRadius.circular(999),
            border: border,
            boxShadow: shadows,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: textColor, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.text,
                        style: TreatTypography.labelLarge.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      const SizedBox(width: 8),
                      widget.trailing!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
