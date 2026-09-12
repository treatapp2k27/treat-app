import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/treat_colors.dart';

enum TreatNavTab {
  explore,
  foodBar,
  favorites,
  social,
  profile,
}

class TreatBottomNavBar extends StatelessWidget {
  final TreatNavTab currentTab;
  final ValueChanged<TreatNavTab> onTabSelected;
  final bool isGuest;

  const TreatBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEDE5F2),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isGuest
                ? [
                    _buildNavItem(
                      tab: TreatNavTab.explore,
                      label: 'Explore',
                      icon: Icons.explore_outlined,
                      activeIcon: Icons.explore,
                    ),
                    _buildNavItem(
                      tab: TreatNavTab.foodBar,
                      label: 'Food Bar',
                      icon: Icons.lunch_dining_outlined,
                      activeIcon: Icons.lunch_dining,
                    ),
                  ]
                : [
                    _buildNavItem(
                      tab: TreatNavTab.explore,
                      label: 'Explore',
                      icon: Icons.explore_outlined,
                      activeIcon: Icons.explore,
                    ),
                    _buildNavItem(
                      tab: TreatNavTab.foodBar,
                      label: 'Food Bar',
                      icon: Icons.lunch_dining_outlined,
                      activeIcon: Icons.lunch_dining,
                    ),
                    _buildNavItem(
                      tab: TreatNavTab.favorites,
                      label: 'Favorites',
                      icon: Icons.favorite_border_rounded,
                      activeIcon: Icons.favorite_rounded,
                    ),
                    _buildNavItem(
                      tab: TreatNavTab.social,
                      label: 'Social',
                      icon: Icons.forum_outlined,
                      activeIcon: Icons.forum,
                    ),
                    _buildNavItem(
                      tab: TreatNavTab.profile,
                      label: 'Profile',
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required TreatNavTab tab,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isActive = currentTab == tab;
    const activeColor = TreatColors.primary; // #7C52AA
    const inactiveColor = Color(0xFF655B6E);

    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(tab),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean icon with smooth scale - NO round overlay or button container
              SizedBox(
                height: 30,
                child: Center(
                  child: AnimatedScale(
                    scale: isActive ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      isActive ? activeIcon : icon,
                      size: 24,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // Name colored if selected with smooth text style animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: -0.2,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
