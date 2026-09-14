import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/asset_constants.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';

/// Two-tier glassmorphic header faithful to the Treat HTML/Tailwind wireframe:
/// Tier 1: Centered Treat Brand Logo
/// Tier 2: Drawer toggle (44x44), full rounded Search input, and Treat celebration button
class TreatHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onActionTap;
  final String actionLabel;
  final IconData actionIcon;
  final bool showSearch;
  final ValueChanged<String>? onSearchChanged;

  const TreatHeader({
    super.key,
    this.onMenuTap,
    this.onActionTap,
    this.actionLabel = 'Filters',
    this.actionIcon = Icons.tune,
    this.showSearch = true,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 104 : 68);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: TreatColors.surface.withValues(alpha: 0.90),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(224, 64, 160, 0.08),
                blurRadius: 24,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 2,
            left: 16,
            right: 16,
            bottom: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showSearch) ...[
                // Tier 1: Centered Brand Logo
                SizedBox(
                  height: 32,
                  child: Center(
                    child: Image.asset(
                      AssetConstants.logo,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Treat',
                            style: GoogleFonts.plusJakartaSans(
                              color: TreatColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(left: 3, top: 10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: TreatColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Tier 2: Drawer Toggle + Search Input + Treat CTA Button
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      // Menu Drawer Button (Sleek 3-Line Hamburger Bar)
                      if (onMenuTap != null)
                        InkWell(
                          onTap: onMenuTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.14),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: TreatColors.secondary,
                              size: 24,
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),

                      // Pill Search Input
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: TreatColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: TreatColors.outlineVariant.withValues(alpha: 0.4),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(124, 82, 170, 0.08),
                                blurRadius: 12,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                size: 20,
                                color: TreatColors.tertiary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: onSearchChanged,
                                  style: TreatTypography.bodyMedium.copyWith(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'Search sweets, spots & treats...',
                                    hintStyle: TreatTypography.bodySmall.copyWith(
                                      color: TreatColors.onSurfaceVariant.withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Action Button (e.g. Treat Celebration Pill)
                      if (onActionTap != null)
                        InkWell(
                          onTap: onActionTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: TreatColors.secondary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.35),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(actionIcon, size: 18, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  actionLabel,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ] else ...[
                // Single Tier compact mode (for sub-screens)
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      if (onMenuTap != null)
                        InkWell(
                          onTap: onMenuTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.12),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: TreatColors.secondary,
                              size: 22,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            AssetConstants.logo,
                            height: 28,
                            errorBuilder: (_, __, ___) => Text(
                              'Treat',
                              style: GoogleFonts.plusJakartaSans(
                                color: TreatColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (onActionTap != null)
                        InkWell(
                          onTap: onActionTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: TreatColors.secondary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                Icon(actionIcon, size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  actionLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
