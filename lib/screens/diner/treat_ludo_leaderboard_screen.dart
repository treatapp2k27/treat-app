import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/treat_colors.dart';
import '../../widgets/treat_bottom_nav_bar.dart';

/// Treat Ludo Match Standings & Leaderboard Screen
/// Faithfully recreates the post-match Feast Clash victory & leaderboard panel from Image 2.
class TreatLudoLeaderboardScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRematch;
  final VoidCallback onBackToProfile;
  final Function(TreatNavTab tab)? onNavigateTab;

  const TreatLudoLeaderboardScreen({
    super.key,
    required this.onBack,
    required this.onRematch,
    required this.onBackToProfile,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7FC),
      bottomNavigationBar: TreatBottomNavBar(
        currentTab: TreatNavTab.profile,
        onTabSelected: (tab) {
          if (onNavigateTab != null) {
            onNavigateTab!(tab);
          } else {
            onBackToProfile();
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            _buildTopBar(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: Column(
                  children: [
                    // Match Finished Pill Banner
                    _buildMatchBanner(),
                    const SizedBox(height: 14),

                    // Winner Showcase & Reward Card
                    _buildWinnerCard(context),
                    const SizedBox(height: 16),

                    // Squad Match Standings Card
                    _buildStandingsCard(),
                    const SizedBox(height: 14),

                    // Voucher Stored in Wallet Card
                    _buildWalletVoucherCard(context),
                    const SizedBox(height: 18),

                    // Rematch Treat Squad Button
                    _buildRematchButton(),
                    const SizedBox(height: 12),

                    // Back to Diner Profile & Games Link
                    InkWell(
                      onTap: onBackToProfile,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          'Back to Diner Profile & Games',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF7C52AA),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEADBEE)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.08),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 19,
                color: Color(0xFF1F1B1A),
              ),
            ),
          ),

          // Treat Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Treat',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: const Color(0xFF653993),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFE040A0),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          // Share Button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('🎉 Match victory shared with squad!'),
                  backgroundColor: TreatColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEADBEE)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.08),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.share_rounded,
                size: 18,
                color: Color(0xFF1F1B1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MATCH BANNER PILL
  // ==========================================
  Widget _buildMatchBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAF8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_activity_outlined,
            size: 14,
            color: Color(0xFF653993),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'MATCH FINISHED • FEAST CLASH #482',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: const Color(0xFF653993),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WINNER SHOWCASE & REWARD CARD
  // ==========================================
  Widget _buildWinnerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFD6EE), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.12),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Winner Avatar with Crown & Rainbow Glow
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Radiant Ring
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const SweepGradient(
                    colors: [
                      Color(0xFFFFB300),
                      Color(0xFFE040A0),
                      Color(0xFF7C3AED),
                      Color(0xFFFFB300),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(255, 179, 0, 0.4),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3.5),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF7ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🥟', style: TextStyle(fontSize: 44)),
                ),
              ),

              // ⭐ WINNER Badge on top
              Positioned(
                top: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(255, 160, 0, 0.4),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(
                        'WINNER',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Player Name & You Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MidnightDumpling',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F1B1A),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD6EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'You',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE040A0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Subtitle
          Text(
            'Champion of the Table • 4 Tokens Home',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF706776),
            ),
          ),
          const SizedBox(height: 14),

          // Unlocked Reward Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6B21A8),
                  Color(0xFF9333EA),
                  Color(0xFFC026D3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(147, 51, 234, 0.35),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Gift Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Reward Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UNLOCKED REWARD',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      Text(
                        '50% Off Feast Platter',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '+500 Treat Gold Coins Credited',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE9D5FF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Checked Circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF9333EA),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SQUAD MATCH STANDINGS CARD (Image 2)
  // ==========================================
  Widget _buildStandingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDE4F7)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bar_chart_rounded, size: 16, color: Color(0xFF653993)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'SQUAD MATCH STANDINGS',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: const Color(0xFF653993),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '15 Rounds Played',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8A7A90),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1st Place: MidnightDumpling (YOU)
          _buildStandingRow(
            rank: '1',
            rankColor: const Color(0xFFFFB300),
            rankTextColor: const Color(0xFF4A3400),
            avatarEmoji: '🥟',
            avatarBg: const Color(0xFFFFEBF6),
            name: 'MidnightDumpling',
            isUser: true,
            statusText: 'Finished in Round 14 • 4 In',
            coinsText: '+500',
            discountBadge: '50%\nPass',
            discountColor: const Color(0xFF059669),
          ),
          const Divider(color: Color(0xFFF5EEF6), height: 16),

          // 2nd Place: TacoFiend
          _buildStandingRow(
            rank: '2',
            rankColor: const Color(0xFFEDE4F7),
            rankTextColor: const Color(0xFF653993),
            avatarEmoji: '🌮',
            avatarBg: const Color(0xFFFFF3E0),
            name: 'TacoFiend',
            isUser: false,
            statusText: '3 Tokens In • Safe House',
            coinsText: '+200',
            discountBadge: '20% Off',
            discountColor: const Color(0xFF7C52AA),
          ),
          const Divider(color: Color(0xFFF5EEF6), height: 16),

          // 3rd Place: BobaBandit
          _buildStandingRow(
            rank: '3',
            rankColor: const Color(0xFFF3EDF5),
            rankTextColor: const Color(0xFF706776),
            avatarEmoji: '🧋',
            avatarBg: const Color(0xFFE0F7FA),
            name: 'BobaBandit',
            isUser: false,
            statusText: '2 Tokens In',
            coinsText: '+100',
            discountBadge: '10% Off',
            discountColor: const Color(0xFF706776),
          ),
          const Divider(color: Color(0xFFF5EEF6), height: 16),

          // 4th Place: PizzaSlice99
          _buildStandingRow(
            rank: '4',
            rankColor: const Color(0xFFF7F2F8),
            rankTextColor: const Color(0xFF8A7A90),
            avatarEmoji: '🍕',
            avatarBg: const Color(0xFFFFEBEE),
            name: 'PizzaSlice99',
            isUser: false,
            statusText: '1 Token In • Captured x2',
            coinsText: '+50',
            discountBadge: '5% Treat',
            discountColor: const Color(0xFF8A7A90),
          ),
        ],
      ),
    );
  }

  Widget _buildStandingRow({
    required String rank,
    required Color rankColor,
    required Color rankTextColor,
    required String avatarEmoji,
    required Color avatarBg,
    required String name,
    required bool isUser,
    required String statusText,
    required String coinsText,
    required String discountBadge,
    required Color discountColor,
  }) {
    return Row(
      children: [
        // Rank Circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: rankColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            rank,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: rankTextColor,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Character Emoji Avatar
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: avatarBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(avatarEmoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 10),

        // Player Name & Detail
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F1B1A),
                      ),
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD6EE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'YOU',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFE040A0),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                statusText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF706776),
                ),
              ),
            ],
          ),
        ),

        // Coins & Discount Tag
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  coinsText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF653993),
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD54F),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🪙', style: TextStyle(fontSize: 8)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              discountBadge,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: discountColor,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // VOUCHER STORED IN WALLET CARD
  // ==========================================
  Widget _buildWalletVoucherCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD6EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE0F2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🎟️', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voucher Stored in Wallet',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1F1B1A),
                  ),
                ),
                Text(
                  'Valid for 48 hrs on all Group Feasts',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF706776),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDCC8E0), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('🎫 Feast voucher ready in your Treat Wallet!'),
                  backgroundColor: TreatColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(
              'View Pass',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF653993),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // REMATCH BUTTON
  // ==========================================
  Widget _buildRematchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRematch,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFD6228A),
                Color(0xFFE040A0),
                Color(0xFFF43F5E),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(214, 34, 138, 0.35),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Rematch Treat Squad',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
