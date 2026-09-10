import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/treat_animated_logo.dart';

/// The high-converting, streamlined Gateway / Explore Landing Screen.
/// Provides two clear, user-friendly options for diners:
/// 1. Explore without sign in (Instant guest pass to flash deals & secret menus)
/// 2. Sign in as Foodie (Personalized rewards, saved spots, and bill splits)
class GatewayExploreScreen extends StatefulWidget {
  final VoidCallback onExploreGuest;
  final VoidCallback onFoodieSignInTap;

  const GatewayExploreScreen({
    super.key,
    required this.onExploreGuest,
    required this.onFoodieSignInTap,
  });

  @override
  State<GatewayExploreScreen> createState() => _GatewayExploreScreenState();
}

class _GatewayExploreScreenState extends State<GatewayExploreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildPulsingDot() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: const Color(0xFF825500),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF825500).withValues(alpha: 0.4),
                blurRadius: 6 * _pulseAnimation.value,
                spreadRadius: 2 * (_pulseAnimation.value - 1.0),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarItem(String emoji, Color bg) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECEB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5B403A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    IconData? leadingIcon,
    IconData? trailingIcon,
    required LinearGradient gradient,
    required Color shadowColor,
    required VoidCallback onTap,
    double height = 50,
    double fontSize = 15,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.32),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: Colors.white),
                const SizedBox(width: 7),
              ],
              Flexible(
                child: Text(
                  text,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 7),
                Icon(trailingIcon, size: 18, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFEF7FF),
              Color(0xFFF8F1F9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Atmospheric Ambient Glows
            Positioned(
              top: -60,
              right: -50,
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 214, 238, 0.40),
                ),
              ),
            ),
            Positioned(
              top: 320,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(238, 220, 255, 0.45),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. Top Pill Badge: "Bite-sized feasts & local dining"
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE8F8),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFDBB8FF), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.restaurant_menu,
                                  size: 14,
                                  color: Color(0xFFB52603),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Bite-sized feasts & local dining',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF633990),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Brand Hero Animated Logo
                        const TreatAnimatedLogo(
                          height: 80,
                        ),
                        const SizedBox(height: 8),

                        // Tagline Subtitle
                        Text(
                          'Flash food deals, secret menus &\nneighborhood kitchen treats.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B403A),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 3. Social Proof Badge Pill: "3,400+ foodies exploring"
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBF2EF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Overlapping foodie avatars
                                SizedBox(
                                  width: 34,
                                  height: 22,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        child: _buildAvatarItem('🍜', const Color(0xFFFFE0D2)),
                                      ),
                                      Positioned(
                                        left: 13,
                                        child: _buildAvatarItem('🍕', const Color(0xFFFFD6EA)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: const Color(0xFF5B403A),
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: '3,400+ ',
                                        style: TextStyle(
                                          color: Color(0xFF825500),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'foodies exploring',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 4. OPTION 1 (Hero Card): Explore Treats ⚡ (Explore Without Sign In)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: const Color(0x387C52AA),
                              width: 1.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(124, 82, 170, 0.12),
                                blurRadius: 26,
                                offset: Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(178, 16, 123, 0.05),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Guest Pass pill + Live Deals status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Guest Pass pill badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCEAF5),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bolt, size: 14, color: Color(0xFFB2107B)),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Guest Pass',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFB2107B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Live Deals status beacon
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildPulsingDot(),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Live Deals',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF825500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Explore Treats',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.4,
                                        color: const Color(0xFF1F1B1A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('⚡', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Description
                              Text(
                                "Instant access to today's flash food deals, secret late-night menus, and trending snacks nearby.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: const Color(0xFF5B403A),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Feature Chips
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  _buildFeatureChip(Icons.local_pizza, 'Feast Deals', const Color(0xFF7C52AA)),
                                  _buildFeatureChip(Icons.near_me, 'Near You', const Color(0xFFB52603)),
                                  _buildFeatureChip(Icons.percent, 'Up to 50% Off', const Color(0xFF006C49)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // OPTION 1 CTA: Explore Without Sign In ➔
                              _buildGradientButton(
                                text: 'Explore Without Sign In',
                                trailingIcon: Icons.arrow_forward_rounded,
                                height: 50,
                                fontSize: 15,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7C52AA), Color(0xFF633990)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shadowColor: const Color(0xFF7C52AA),
                                onTap: widget.onExploreGuest,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 5. Elegant Divider: "OR SIGN IN TO YOUR ACCOUNT"
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Divider(color: Color(0xFFE8DEEC), thickness: 1),
                              Container(
                                color: const Color(0xFFFEF7FF),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                child: Text(
                                  'OR PERSONALIZE YOUR FOODIE PROFILE',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: const Color(0xFF7A6472),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 6. OPTION 2: Foodie & Diner Login
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0x30E040A0),
                              width: 1.1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(224, 64, 160, 0.08),
                                blurRadius: 18,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCEAF5),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFFFD6EA),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      size: 20,
                                      color: Color(0xFFE040A0),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Foodie & Diner Login',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: const Color(0xFF1F1B1A),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFCEAF5),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                'Member',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFFB2107B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Saved spots, loyalty rewards & split bills',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.5,
                                            color: const Color(0xFF5B403A),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // OPTION 2 CTA: Sign In as Foodie
                              _buildGradientButton(
                                text: 'Sign In as Foodie',
                                leadingIcon: Icons.login_rounded,
                                height: 46,
                                fontSize: 14,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF054B0), Color(0xFFE040A0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shadowColor: const Color(0xFFE040A0),
                                onTap: widget.onFoodieSignInTap,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 7. Trust Guarantee & Micro-copy Footer
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                size: 14,
                                color: Color(0xFF006C49),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Safe, cashless and verified local spots',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF5B403A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'New to Treat? Instant guest access available anytime.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: const Color(0xFF8F7069),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
