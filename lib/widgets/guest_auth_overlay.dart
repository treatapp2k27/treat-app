import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/treat_colors.dart';

/// A transparent, frosted glass overlay panel shown to guest users ("Explore Without Sign In")
/// when attempting to access members-only panels like 'Feed' and 'Profile'.
/// Displays the required headline 'Sign in to Unlock all the Features' and provides a direct
/// CTA button to redirect to the Log In page.
class GuestAuthOverlay extends StatelessWidget {
  final String panelType; // 'feed' or 'profile'
  final VoidCallback onSignIn;
  final VoidCallback? onBackToExplore;

  const GuestAuthOverlay({
    super.key,
    required this.panelType,
    required this.onSignIn,
    this.onBackToExplore,
  });

  bool get _isProfile => panelType.toLowerCase().contains('profile');
  bool get _isViewDetails =>
      panelType.toLowerCase().contains('view_details') ||
      panelType.toLowerCase().contains('details');
  bool get _isSelectPlatter =>
      panelType.toLowerCase().contains('select_platter') ||
      panelType.toLowerCase().contains('platter');
  bool get _isFavorites =>
      panelType.toLowerCase().contains('favorite') ||
      panelType.toLowerCase().contains('loved');

  String get _tagLabel {
    if (_isProfile) return 'MEMBER PROFILE';
    if (_isFavorites) return 'FAVORITE TREATS';
    if (_isViewDetails) return 'PLATTER DETAILS';
    if (_isSelectPlatter) return 'SELECT PLATTER';
    return 'FOODIE FEED';
  }

  String get _subtitleText {
    if (_isProfile) {
      return 'Sign in to personalize your dining persona, manage dietary tags, track budget savings, and redeem member cashbacks.';
    }
    if (_isFavorites) {
      return 'Sign in to save your favorite feast platters, create custom foodie wishlists, and receive flash price alerts.';
    }
    if (_isViewDetails) {
      return 'Sign in to view secret recipe details, claim flash drop vouchers, and unlock member group pricing.';
    }
    if (_isSelectPlatter) {
      return 'Sign in to reserve your feast platter, split the bill with your squad, and earn foodie rewards.';
    }
    return 'Sign in to join the foodie community feed, share feast photos, like & comment on deal hacks, and chat in the Food Bar.';
  }

  IconData get _heroIcon {
    if (_isProfile) return Icons.account_circle_rounded;
    if (_isFavorites) return Icons.favorite_rounded;
    if (_isViewDetails || _isSelectPlatter) return Icons.restaurant_menu_rounded;
    return Icons.lock_person_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1E0D33).withValues(alpha: 0.58),
                const Color(0xFF120622).withValues(alpha: 0.72),
              ],
            ),
          ),
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBackToExplore,
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent taps inside the card from dismissing
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFFFD6EE),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C52AA).withValues(alpha: 0.12),
                              blurRadius: 36,
                              offset: const Offset(0, 14),
                            ),
                            BoxShadow(
                              color: const Color(0xFFE040A0).withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Lock / Shield Glowing Hero Icon
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF054B0),
                                    Color(0xFF7C52AA),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE040A0).withValues(alpha: 0.38),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    _heroIcon,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFB800),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // 2. Member Exclusive Tag Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE8FC),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFDCC8E0),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.lock_rounded,
                                    size: 13,
                                    color: TreatColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _tagLabel,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      color: TreatColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 3. Main Required Headline
                            Text(
                              'Sign in to Unlock all the Features',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.25,
                                color: const Color(0xFF1F1B1A),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // 4. Subtitle Description
                            Text(
                              _subtitleText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                height: 1.45,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF5B403A),
                              ),
                            ),
                        const SizedBox(height: 20),

                        // 5. Feature Unlock Highlights
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7FC),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFEDE5F2),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildFeatureRow(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Community Feed & Live Food Bar Chat',
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureRow(
                                icon: Icons.local_offer_outlined,
                                label: 'Exclusive Secret Deals & Flash Discounts',
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureRow(
                                icon: Icons.stars_rounded,
                                label: 'Squad Bill Splits & Treat Ludo Rewards',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 6. Sign In Redirect CTA Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: const ValueKey('guest_overlay_sign_in_button'),
                            onTap: onSignIn,
                            borderRadius: BorderRadius.circular(999),
                            child: Ink(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF054B0),
                                    Color(0xFFE040A0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(224, 64, 160, 0.35),
                                    blurRadius: 18,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.login_rounded,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sign In to Unlock',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 7. Secondary "Back to Explore" option
                        if (onBackToExplore != null) ...[
                          const SizedBox(height: 12),
                          TextButton.icon(
                            key: const ValueKey('guest_overlay_back_button'),
                            onPressed: onBackToExplore,
                            icon: const Icon(
                              Icons.explore_outlined,
                              size: 16,
                              color: Color(0xFF7C52AA),
                            ),
                            label: Text(
                              'Back to Explore Platters',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF7C52AA),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
}

  Widget _buildFeatureRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE8DCFA),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: TreatColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B2F44),
            ),
          ),
        ),
      ],
    );
  }
}
