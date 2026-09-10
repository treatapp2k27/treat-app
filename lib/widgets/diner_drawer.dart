import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/treat_colors.dart';
import '../state/diner_state.dart';

class DinerDrawer extends StatelessWidget {
  final Function(String routeName) onNavigate;
  final String activeRoute;

  const DinerDrawer({
    super.key,
    required this.onNavigate,
    this.activeRoute = 'home',
  });

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final persona = dinerState.currentPersona;

    return Drawer(
      width: 325,
      backgroundColor: TreatColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 1. Profile Header Area matching Stitch wireframe
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFEBF6),
                    Color(0xFFFBF2FB),
                    Color(0xFFEEDCFF),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar and Close Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar with verified star
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TreatColors.primary,
                                width: 2.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(224, 64, 160, 0.25),
                                  blurRadius: 14,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              persona.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: TreatColors.primaryFixed,
                                alignment: Alignment.center,
                                child: Text(
                                  persona.avatarEmoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: TreatColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4),
                                ],
                              ),
                              child: const Icon(
                                Icons.stars,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Close Button
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.90),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: TreatColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Handle & Verified Badge
                  Row(
                    children: [
                      Text(
                        persona.handle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: TreatColors.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: TreatColors.primary,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Foodie Adventurer Persona Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEAF5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.explore,
                          size: 14,
                          color: TreatColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Foodie Adventurer',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFB2107B),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Navigation List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  // Home (Active Style matching wireframe)
                  _buildNavItem(
                    route: 'home',
                    title: 'Home',
                    subtitle: 'Top Feasts & Drops',
                    icon: Icons.home_rounded,
                    iconColor: TreatColors.primary,
                    iconBg: const Color(0xFFFFE5F3),
                    isActive: activeRoute == 'home' || activeRoute == 'explore',
                  ),
                  const SizedBox(height: 6),

                  // Trending
                  _buildNavItem(
                    route: 'trending',
                    title: 'Trending',
                    subtitle: 'Top Hotspots',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: TreatColors.primary,
                    iconBg: const Color(0xFFFFE5F3),
                    onTapOverride: () => onNavigate('home'),
                  ),
                  const SizedBox(height: 6),

                  // Treat
                  _buildNavItem(
                    route: 'budget',
                    title: 'Treat',
                    subtitle: 'Flash Perks & Deals',
                    icon: Icons.icecream_rounded,
                    iconColor: TreatColors.secondary,
                    iconBg: const Color(0xFFEEDCFF),
                    trailingBadge: 'NEW',
                    trailingBadgeBg: TreatColors.primary,
                  ),
                  const SizedBox(height: 6),

                  // Social
                  _buildNavItem(
                    route: 'social',
                    title: 'Social',
                    subtitle: 'Foodie Circle & Feeds',
                    icon: Icons.forum_rounded,
                    iconColor: TreatColors.tertiary,
                    iconBg: const Color(0xFFC8EAFF),
                    isActive: activeRoute == 'social',
                  ),
                  const SizedBox(height: 6),

                  // Groups
                  _buildNavItem(
                    route: 'platters',
                    title: 'Groups',
                    subtitle: 'Squad Bill Splitters',
                    icon: Icons.group_work_rounded,
                    iconColor: TreatColors.secondary,
                    iconBg: const Color(0xFFEEDCFF),
                    isActive: activeRoute == 'platters',
                  ),
                  const SizedBox(height: 6),

                  // Reviews
                  _buildNavItem(
                    route: 'food_bar',
                    title: 'Reviews',
                    subtitle: 'Honest Bite Takes',
                    icon: Icons.rate_review_rounded,
                    iconColor: TreatColors.secondary,
                    iconBg: const Color(0xFFF2E8F2),
                    isActive: activeRoute == 'food_bar',
                  ),
                  const SizedBox(height: 10),

                  const Divider(color: Color(0xFFEDE5F2), thickness: 1),
                  const SizedBox(height: 6),

                  // Kitchen Portal
                  _buildNavItem(
                    route: 'kitchen_portal',
                    title: 'Kitchen Portal',
                    subtitle: 'Staff Orders & Floor',
                    icon: Icons.storefront_rounded,
                    iconColor: TreatColors.secondary,
                    iconBg: const Color(0xFFF3E6FB),
                  ),
                ],
              ),
            ),

            // 3. Treat Diner Pass VIP Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: TreatColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: TreatColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cookie_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Treat Diner Pass',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: TreatColors.onPrimaryFixed,
                          ),
                        ),
                        Text(
                          'VIP treats activated',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: TreatColors.onPrimaryFixedVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.verified,
                    size: 18,
                    color: TreatColors.primary,
                  ),
                ],
              ),
            ),

            // 4. Footer Section: Switch Persona / Log Out Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      dinerState.shufflePersona();
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: TreatColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.swap_horiz_rounded,
                            color: TreatColors.outline,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Switch Persona / Log Out',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: TreatColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© TREAT APP FUNKY LIFE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: TreatColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String route,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool isActive = false,
    String? trailingBadge,
    Color? trailingBadgeBg,
    VoidCallback? onTapOverride,
  }) {
    if (isActive) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFDBFF),
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 82, 170, 0.18),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: TreatColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF633990),
                  ),
                ),
              ],
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: TreatColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTapOverride ?? () => onNavigate(route),
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Circular leading badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: TreatColors.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: TreatColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing badge or chevron
            if (trailingBadge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: trailingBadgeBg ?? TreatColors.primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(224, 64, 160, 0.35),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  trailingBadge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: TreatColors.outline,
              ),
          ],
        ),
      ),
    );
  }
}
