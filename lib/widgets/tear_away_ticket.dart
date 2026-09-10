import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';

class PerforatedDivider extends StatelessWidget {
  final Color backgroundColor;
  final Color dashColor;

  const PerforatedDivider({
    super.key,
    this.backgroundColor = TreatColors.background,
    this.dashColor = TreatColors.outlineVariant,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left notch
        Container(
          width: 16,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        // Dashed line
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.constrainWidth();
                const dashWidth = 6.0;
                const dashHeight = 1.5;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: dashHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: dashColor),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
        // Right notch
        Container(
          width: 16,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
