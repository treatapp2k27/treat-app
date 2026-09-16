import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/ludo_match_result.dart';
import '../../widgets/treat_bottom_nav_bar.dart';

/// Treat Ludo Match Standings & Leaderboard Screen
/// Joyful Pop Redesign with App Logo, Tokens-In-Home Standings, and Celebratory Accolades.
class TreatLudoLeaderboardScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRematch;
  final VoidCallback onBackToProfile;
  final Function(TreatNavTab tab)? onNavigateTab;
  final List<LudoPlayerStanding>? standings;
  final LudoMatchResult? matchResult;
  final int roundsPlayed;

  const TreatLudoLeaderboardScreen({
    super.key,
    required this.onBack,
    required this.onRematch,
    required this.onBackToProfile,
    this.onNavigateTab,
    this.standings,
    this.matchResult,
    this.roundsPlayed = 4,
  });

  List<LudoPlayerStanding> get _resolvedStandings =>
      matchResult?.standings ?? standings ?? LudoPlayerStanding.defaultStandings;

  List<LudoRoundMemory> get _resolvedRoundHistory =>
      matchResult?.resolvedRoundHistory ?? LudoRoundMemory.defaultFourRoundHistory;

  LudoPlayerStanding get _winner =>
      _resolvedStandings.isNotEmpty ? _resolvedStandings.first : LudoPlayerStanding.defaultStandings.first;

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
            // Top Navigation Bar (Logo replacing Treat text)
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

                    // Winner Showcase & Reward Card (Joyful Pop)
                    _buildWinnerCard(context),
                    const SizedBox(height: 16),

                    // Squad Match Standings Card (Arranged by tokens got inside)
                    _buildStandingsCard(),
                    const SizedBox(height: 16),

                    // Round-by-Round Cached Memory Scorecard (4 Matches)
                    _buildCachedRoundMemoryScorecard(),
                    const SizedBox(height: 16),

                    // Joyful Match Highlights & Banter Card
                    _buildMatchHighlightsCard(),
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
  // TOP APP BAR (Treat text removed, Main App Logo shown)
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

          // Main App Branded Logo (Replacing "Treat" text)
          Semantics(
            label: 'Treat App Logo',
            child: Image.asset(
              AssetConstants.logo,
              height: 34,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE040A0), Color(0xFF653993)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'TREAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          // Share / Celebrate Button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('🎉 Match victory shared with your squad!'),
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
                Icons.share_outlined,
                size: 19,
                color: Color(0xFF1F1B1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MATCH FINISHED PILL BANNER (4 Rounds Match)
  // ==========================================
  Widget _buildMatchBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDE8F4), Color(0xFFF3EAF8), Color(0xFFFFF0D4)],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFD6EE), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'MATCH FINISHED • FEAST CLASH #482',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
                color: const Color(0xFF653993),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text('⚡', style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // ==========================================
  // WINNER SHOWCASE & REWARD CARD (Joyful Pop Redesign)
  // ==========================================
  Widget _buildWinnerCard(BuildContext context) {
    final winner = _winner;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFD6EE), width: 1.8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.16),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 183, 3, 0.12),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Winner Avatar with Radiant Rainbow Halo & Confetti Aura
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Radiant Ring with Joyful Gradient
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const SweepGradient(
                    colors: [
                      Color(0xFFFFB703),
                      Color(0xFFFF2A85),
                      Color(0xFF7C3AED),
                      Color(0xFF06B6D4),
                      Color(0xFFFFB703),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(255, 179, 0, 0.45),
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(224, 64, 160, 0.35),
                      blurRadius: 14,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF7ED),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(winner.emoji, style: const TextStyle(fontSize: 46)),
                ),
              ),

              // ⭐ WINNER Badge with Crown on top
              Positioned(
                top: -12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD166), Color(0xFFFFB703), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(245, 158, 11, 0.5),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('👑', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        'WINNER',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: const Color(0xFF5A2E00),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Player Name & You Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  winner.name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1B1A),
                  ),
                ),
              ),
              if (winner.isUser) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE0F2), Color(0xFFFFD6EE)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFF472B6), width: 1),
                  ),
                  child: Text(
                    'You',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFE040A0),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Subtitle (First to enter all four dumplings or tokens into home)
          Text(
            'Champion of the Table • ${winner.tokensHome} Tokens Home',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF653993),
            ),
          ),
          const SizedBox(height: 14),

          // Unlocked Profile Reward Card (Joyful Pop - Points & Accolades)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6B21A8),
                  Color(0xFF9333EA),
                  Color(0xFFC026D3),
                  Color(0xFFE040A0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(147, 51, 234, 0.4),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Star Trophy Icon Box
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🏆', style: TextStyle(fontSize: 22)),
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
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                          color: const Color(0xFFFFD166),
                        ),
                      ),
                      Text(
                        '+${winner.pointsAwarded} Treat Gold Coins Credited',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '+${winner.pointsAwarded} Treat Profile Points Credited',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF3E8FF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Star Checkmark Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB703)),
                      const SizedBox(width: 2),
                      Text(
                        'CLAIMED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF6B21A8),
                        ),
                      ),
                    ],
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
  // SQUAD MATCH STANDINGS CARD (Arranged by tokens got inside home)
  // ==========================================
  Widget _buildStandingsCard() {
    final standingsList = _resolvedStandings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE4F7), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.07),
            blurRadius: 16,
            offset: Offset(0, 4),
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
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3EAF8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.leaderboard_rounded, size: 16, color: Color(0xFF653993)),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'SQUAD MATCH STANDINGS',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: const Color(0xFF653993),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // 4 Rounds Played Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EAF8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$roundsPlayed Rounds Played',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF653993),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Subtitle explicitly noting sorting by tokens got inside home
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Arranged by tokens safely entered inside home 🎯',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8A7A90),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Standings Rows
          ...List.generate(standingsList.length, (index) {
            final standing = standingsList[index];
            return Column(
              children: [
                _buildJoyfulStandingRow(standing),
                if (index < standingsList.length - 1)
                  const Divider(color: Color(0xFFF5EEF6), height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJoyfulStandingRow(LudoPlayerStanding standing) {
    // Medal decoration by rank
    Color rankBg;
    Color rankTextColor;
    String rankSymbol;

    switch (standing.rank) {
      case 1:
        rankBg = const Color(0xFFFFD166);
        rankTextColor = const Color(0xFF5A2E00);
        rankSymbol = '🥇';
        break;
      case 2:
        rankBg = const Color(0xFFE2E8F0);
        rankTextColor = const Color(0xFF334155);
        rankSymbol = '🥈';
        break;
      case 3:
        rankBg = const Color(0xFFFFD8BE);
        rankTextColor = const Color(0xFF7C2D12);
        rankSymbol = '🥉';
        break;
      default:
        rankBg = const Color(0xFFF1EAFA);
        rankTextColor = const Color(0xFF653993);
        rankSymbol = '${standing.rank}';
        break;
    }

    return Row(
      children: [
        // Rank Badge
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: rankBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: rankBg.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            rankSymbol,
            style: GoogleFonts.plusJakartaSans(
              fontSize: standing.rank <= 3 ? 14 : 11.5,
              fontWeight: FontWeight.w900,
              color: rankTextColor,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Character Emoji Avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: standing.themeColor.withOpacity(0.14),
            shape: BoxShape.circle,
            border: Border.all(
              color: standing.themeColor.withOpacity(0.35),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(standing.emoji, style: const TextStyle(fontSize: 22)),
        ),
        const SizedBox(width: 10),

        // Player Name & Visual Token In-Home Progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      standing.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F1B1A),
                      ),
                    ),
                  ),
                  if (standing.isUser) ...[
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
              const SizedBox(height: 2),

              // Visual Token Meter (Tokens that got inside home)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '${standing.tokensHome}/4 Inside Home',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: standing.tokensHome > 0
                            ? standing.themeColor
                            : const Color(0xFF8A7A90),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Visual dots for tokens in home
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (dotIdx) {
                      final isHome = dotIdx < standing.tokensHome;
                      return Container(
                        margin: const EdgeInsets.only(right: 2.5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHome ? standing.themeColor : const Color(0xFFE2D9EC),
                          border: isHome
                              ? null
                              : Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Points & Coins Pill (Joyful Pop)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                standing.themeColor.withOpacity(0.12),
                standing.themeColor.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: standing.themeColor.withOpacity(0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, size: 14, color: Color(0xFFFFB703)),
              const SizedBox(width: 3),
              Text(
                '+${standing.pointsAwarded}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: standing.themeColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // JOYFUL MATCH HIGHLIGHTS & BANTER CARD
  // ==========================================
  Widget _buildMatchHighlightsCard() {
    final winner = _winner;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF9E6), Color(0xFFFFF0F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE3B3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'FEAST CLASH HIGHLIGHTS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  color: const Color(0xFF9A5B00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '🔥 ${winner.emoji} ${winner.name} locked in the win with ${winner.tokensHome} tokens safely inside home! All 4 rounds delivered electric squad energy.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5A3E1B),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // REMATCH BUTTON (Joyful Pop Gradient)
  // ==========================================
  Widget _buildRematchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRematch,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE040A0),
                Color(0xFFD6228A),
                Color(0xFFB2107B),
                Color(0xFF7C3AED),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(224, 64, 160, 0.45),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.casino_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Rematch Treat Squad',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ROUND-BY-ROUND CACHED MEMORY SCORECARD
  // ==========================================
  Widget _buildCachedRoundMemoryScorecard() {
    final history = _resolvedRoundHistory;
    final winner = _winner;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2D9F3), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(99, 57, 144, 0.08),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title & 4 Rounds Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROUND-BY-ROUND CACHED MEMORY',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: const Color(0xFF633990),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4-Match History & Round Progression',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1B1A),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD166), Color(0xFFFFB703)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(255, 183, 3, 0.4),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    Text(
                      '4 ROUNDS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF5A2E00),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Render each round's cached memory
          ...List.generate(history.length, (idx) {
            final roundMem = history[idx];
            final isLastRound = roundMem.roundNumber == 4;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLastRound
                    ? const Color(0xFFFFF7FC)
                    : const Color(0xFFFBF8FE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLastRound
                      ? const Color(0xFFFFD6EE)
                      : const Color(0xFFEDE5F7),
                  width: isLastRound ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Round Title Strip & Highlight
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: isLastRound
                              ? const Color(0xFFE040A0)
                              : const Color(0xFF633990),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isLastRound ? 'Round 4 (Final)' : 'Round ${roundMem.roundNumber}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          isLastRound ? 'Championship Round 🏆' : 'Round Scored & Cached 💾',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isLastRound
                                ? const Color(0xFFB2107B)
                                : const Color(0xFF7C52AA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    roundMem.highlight,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A3B5A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Player Round Score Chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: roundMem.playerScores.map((score) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE8DEF0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(score.emoji, style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              score.playerName == 'MidnightDumpling' ? 'Dumpling' : score.playerName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2A1C3D),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EAF8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${score.tokensHome}🏠 • +${score.roundPoints}p',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF633990),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),

          // Original Winner Declared Summary Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF633990), Color(0xFFB2107B), Color(0xFFE040A0)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(224, 64, 160, 0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('👑', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORIGINAL 4-ROUND WINNER DECLARED',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFD166),
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        '${winner.name} crowned Champion with ${winner.tokensHome}/4 Inside Home!',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
