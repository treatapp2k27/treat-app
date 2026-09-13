import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/treat_colors.dart';
import '../state/diner_state.dart';
import 'squad_minigame_banner.dart';

class DinerDrawer extends StatelessWidget {
  final Function(String routeName) onNavigate;
  final String activeRoute;
  final VoidCallback? onLogOut;

  const DinerDrawer({
    super.key,
    required this.onNavigate,
    this.activeRoute = 'home',
    this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final persona = dinerState.currentPersona;

    return Drawer(
      width: 335,
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
            // 1. Profile Header Area (Profile image on left, info on right in same div)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 16),
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
                  // Top close button
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 17,
                          color: Color(0xFF4A3B4F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Main Profile Div: Image on left, Name/Categories/Level/Treats on right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT SIDE: Profile image with hot-pink border and star badge
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          onNavigate('profile');
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD6228A),
                                  width: 2.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(214, 34, 138, 0.25),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                persona.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFFFD6EE),
                                  alignment: Alignment.center,
                                  child: Text(
                                    persona.avatarEmoji,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -1,
                              right: -1,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD6228A),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // RIGHT SIDE: Name, View Profile, Categories, Level, Treats Claimed
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with Name + Pink Verified Icon and View Profile > button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onNavigate('profile');
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            persona.handle,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF1F1626),
                                              letterSpacing: -0.3,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.verified,
                                          color: Color(0xFFD6228A),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    onNavigate('profile');
                                  },
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDE8F3),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'View Profile',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFD6228A),
                                          ),
                                        ),
                                        const SizedBox(width: 1),
                                        const Icon(
                                          Icons.chevron_right_rounded,
                                          size: 12,
                                          color: Color(0xFFD6228A),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 7),

                            // Categories, Level, Treats Claimed Badges
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                // Category: Foodie Adventurer
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7.5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCEAF5),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.explore,
                                        size: 11,
                                        color: Color(0xFFB2107B),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Foodie Adventurer',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFB2107B),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Level badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7.5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0E5FF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.stars_rounded,
                                        size: 11,
                                        color: Color(0xFF7C3AED),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Level ${persona.vipLevel} Explorer',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7C3AED),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Treats Claimed badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7.5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0E6),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.card_giftcard_rounded,
                                        size: 11,
                                        color: Color(0xFFEA580C),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${persona.treatsClaimed} Treats Claimed',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFEA580C),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Navigation List + Squad Minigame
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  // Home
                  _buildNavItem(
                    route: 'home',
                    title: 'Home',
                    subtitle: 'Top Feasts & Drops',
                    icon: Icons.home_rounded,
                    iconColor: TreatColors.primary,
                    iconBg: const Color(0xFFFFEBF6),
                    isActive: activeRoute == 'home',
                  ),
                  const SizedBox(height: 6),

                  // Trending Platters
                  _buildNavItem(
                    route: 'explore',
                    title: 'Trending',
                    subtitle: 'Viral TikTok Flavors',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color(0xFFFF5252),
                    iconBg: const Color(0xFFFFEBEE),
                    isActive: activeRoute == 'explore',
                    trailingBadge: 'HOT',
                  ),
                  const SizedBox(height: 6),

                  // Treat Search
                  _buildNavItem(
                    route: 'favorites',
                    title: 'Treat',
                    subtitle: 'Saved Bites & Wishlist',
                    icon: Icons.favorite_rounded,
                    iconColor: const Color(0xFFE91E63),
                    iconBg: const Color(0xFFFCE4EC),
                    isActive: activeRoute == 'favorites',
                  ),
                  const SizedBox(height: 6),

                  // Social / Community
                  _buildNavItem(
                    route: 'social',
                    title: 'Social',
                    subtitle: 'Feast Pals & Chats',
                    icon: Icons.forum_rounded,
                    iconColor: const Color(0xFF8E24AA),
                    iconBg: const Color(0xFFF3E5F5),
                    isActive: activeRoute == 'social',
                  ),
                  const SizedBox(height: 6),

                  // Groups
                  _buildNavItem(
                    route: 'groups',
                    title: 'Groups',
                    subtitle: 'Squad Bill Splitters',
                    icon: Icons.groups_rounded,
                    iconColor: TreatColors.secondary,
                    iconBg: const Color(0xFFEDE0F8),
                    isActive: activeRoute == 'groups',
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

                  const SizedBox(height: 16),

                  // 3. Squad Minigame Banner (Relocated from Explore page to sidebar below page options)
                  const SquadMinigameBanner(),

                  const SizedBox(height: 12),

                  // 4. Treat Diner Pass VIP Card (Tappable to view Profile & VIP perks)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onNavigate('profile');
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
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
                                  'VIP treats activated • Tap to manage',
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
                  ),
                ],
              ),
            ),

            // 5. Footer Section: Log Out Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      dinerState.shufflePersona();
                      if (onLogOut != null) {
                        onLogOut!();
                      } else {
                        dinerState.setFoodieLoggedIn(false);
                        Navigator.of(context).pop();
                        onNavigate('welcome');
                      }
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEF7),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFFD6228A).withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(214, 34, 138, 0.08),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFD6228A),
                                size: 17,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Log Out',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFD6228A),
                                ),
                              ),
                              Text(
                                ' & Switch Persona',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFD6228A).withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.swap_horiz_rounded,
                                color: Color(0xFFD6228A),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
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
