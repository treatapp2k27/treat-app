import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';

class TerminalKeypad extends StatelessWidget {
  final String pin;
  final Function(String) onDigitTap;
  final VoidCallback onClear;
  final VoidCallback onBackspace;

  const TerminalKeypad({
    super.key,
    required this.pin,
    required this.onDigitTap,
    required this.onClear,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Masked PIN Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = index < pin.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? TreatColors.secondary : TreatColors.surfaceContainerHigh,
                border: isFilled
                    ? Border.all(color: TreatColors.secondaryFixed, width: 3)
                    : null,
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // 3x4 Numeric Keypad
        SizedBox(
          width: 260,
          child: Column(
            children: [
              _buildRow(['1', '2', '3']),
              const SizedBox(height: 10),
              _buildRow(['4', '5', '6']),
              const SizedBox(height: 10),
              _buildRow(['7', '8', '9']),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton('C', onTap: onClear, isSpecial: true),
                  _buildButton('0', onTap: () => onDigitTap('0')),
                  _buildIconButton(Icons.backspace_outlined, onTap: onBackspace),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((d) => _buildButton(d, onTap: () => onDigitTap(d))).toList(),
    );
  }

  Widget _buildButton(String label, {required VoidCallback onTap, bool isSpecial = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 76,
        height: 48,
        decoration: BoxDecoration(
          color: isSpecial ? TreatColors.surfaceContainerHigh : TreatColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TreatTypography.headlineSmall.copyWith(
            color: isSpecial ? TreatColors.onSurfaceVariant : TreatColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 76,
        height: 48,
        decoration: BoxDecoration(
          color: TreatColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: TreatColors.onSurfaceVariant),
      ),
    );
  }
}
