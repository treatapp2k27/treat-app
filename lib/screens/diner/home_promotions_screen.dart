import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/platter_deal.dart';
import '../../state/budget_planner_state.dart';
import '../../widgets/treat_header.dart';

class HomePromotionsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal) onSelectDeal;
  final VoidCallback onNavigateBudgetPlanner;

  const HomePromotionsScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectDeal,
    required this.onNavigateBudgetPlanner,
  });

  @override
  State<HomePromotionsScreen> createState() => _HomePromotionsScreenState();
}

class _HomePromotionsScreenState extends State<HomePromotionsScreen> {
  int _selectedFilterIndex = 0;
  final Set<String> _favoritedSpots = {'spot_1'};
  String? _copiedVoucherCode;
  Timer? _copyResetTimer;

  final List<Map<String, dynamic>> _filters = [
    {
      'label': 'Trending Treats',
      'icon': Icons.local_fire_department,
      'bg': TreatColors.secondary,
      'text': Colors.white,
    },
    {
      'label': 'Group Feasts',
      'icon': Icons.group,
      'bg': TreatColors.primaryFixed,
      'text': TreatColors.onPrimaryFixed,
    },
    {
      'label': 'Mega Deals',
      'icon': Icons.percent,
      'bg': TreatColors.tertiaryFixed,
      'text': TreatColors.onTertiaryFixed,
    },
    {
      'label': 'Dessert Craze',
      'icon': Icons.cake,
      'bg': TreatColors.surfaceContainerHigh,
      'text': TreatColors.onSurfaceVariant,
    },
  ];

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    super.dispose();
  }

  void _handleCopyVoucher(String code) {
    Clipboard.setData(ClipboardData(text: code));
    setState(() {
      _copiedVoucherCode = code;
    });

    _copyResetTimer?.cancel();
    _copyResetTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _copiedVoucherCode = null;
        });
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Voucher "$code" copied to clipboard!',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: TreatColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSpinWheelDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return _SpinWheelModal(
          onRewardClaimed: (points) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 Congratulations! You won $points bonus Sweet Points!'),
                backgroundColor: TreatColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Treat',
        actionIcon: Icons.celebration,
        onActionTap: widget.onNavigateBudgetPlanner,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 36),
        children: [
          // 1. Filter Chips Carousel
          _buildFilterChipsCarousel(),
          const SizedBox(height: 22),

          // 2. Section: Hottest Promotions
          _buildHottestPromotionsSection(),
          const SizedBox(height: 24),

          // 3. Section: Exclusive Vouchers
          _buildExclusiveVouchersSection(),
          const SizedBox(height: 26),

          // 4. Section: Featured Group Feast Spots
          _buildFeaturedGroupFeastSpotsSection(),
          const SizedBox(height: 22),

          // 5. Section: Gamified Loyalty Perks Banner
          _buildLoyaltyPerksBanner(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Filter Chips Carousel
  // -------------------------------------------------------------
  Widget _buildFilterChipsCarousel() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = index == _selectedFilterIndex;
          final colorBg = isSelected ? TreatColors.secondary : (filter['bg'] as Color);
          final colorText = isSelected ? Colors.white : (filter['text'] as Color);

          return InkWell(
            onTap: () => setState(() => _selectedFilterIndex = index),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorBg,
                borderRadius: BorderRadius.circular(999),
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color.fromRGBO(124, 82, 170, 0.30),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: colorText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // Section 1: Hottest Promotions
  // -------------------------------------------------------------
  Widget _buildHottestPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      color: TreatColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Hottest Promotions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: TreatColors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: TreatColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'POPULAR',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: TreatColors.onPrimaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Swipe',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TreatColors.secondary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: TreatColors.secondary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Carousel of 2 Cards
        SizedBox(
          height: 196,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              // Promo Card 1: Neon Glaze Fiesta Platter
              _buildPromotionCard(
                badgeText: '2-FOR-1 DEAL',
                badgeIcon: Icons.auto_awesome,
                badgeBg: TreatColors.primary,
                emoji: '🍕✨',
                title: 'Neon Glaze Fiesta Platter',
                description: 'Buy 1 signature mega dessert & group taco tray, get second 100% free!',
                metaLabel: 'Limited Slots',
                metaValue: 'Ends in 2h 14m',
                metaValueColor: TreatColors.primary,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD6EE),
                    Colors.white,
                    Color(0xFFEEDCFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                glowColor: const Color(0xFFE040A0),
                buttonLabel: 'Claim',
                buttonIcon: Icons.bolt,
                onAction: () {
                  context.read<BudgetPlannerState>().selectPlatter(PlatterDeal.sampleDeals[2]);
                  widget.onSelectDeal(PlatterDeal.sampleDeals[2]);
                },
              ),
              const SizedBox(width: 14),

              // Promo Card 2: 35% Off Squad Crunch Bar
              _buildPromotionCard(
                badgeText: 'SQUAD FEAST',
                badgeIcon: Icons.groups_rounded,
                badgeBg: TreatColors.tertiary,
                emoji: '🍔🍧',
                title: '35% Off Squad Crunch Bar',
                description: 'Valid for 4+ sweeties! Signature slushies and loaded waffle towers.',
                metaLabel: 'Vibe Check',
                metaValue: '4.9 ★ (340+ reviews)',
                metaValueColor: TreatColors.secondary,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFC8EAFF),
                    Colors.white,
                    Color(0xFFEEDCFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                glowColor: const Color(0xFF0096CC),
                buttonLabel: 'Snag',
                buttonIcon: Icons.local_activity,
                onAction: () {
                  context.read<BudgetPlannerState>().selectPlatter(PlatterDeal.fiestaPlatter);
                  widget.onSelectDeal(PlatterDeal.fiestaPlatter);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCard({
    required String badgeText,
    required IconData badgeIcon,
    required Color badgeBg,
    required String emoji,
    required String title,
    required String description,
    required String metaLabel,
    required String metaValue,
    required Color metaValueColor,
    required LinearGradient gradient,
    required Color glowColor,
    required String buttonLabel,
    required IconData buttonIcon,
    required VoidCallback onAction,
  }) {
    return Container(
      width: 295,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.16),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Corner Ambient Glow
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor.withValues(alpha: 0.12),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Badge + Bouncing Emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: badgeBg.withValues(alpha: 0.40),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badgeIcon, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            badgeText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),

                // Middle Content: Title + Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                        color: TreatColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        height: 1.35,
                        color: TreatColors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Bottom Row: Meta Text + Claim Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            metaLabel.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: TreatColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            metaValue,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: metaValueColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: TreatColors.secondary,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(124, 82, 170, 0.35),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              buttonLabel,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(buttonIcon, size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Section 2: Exclusive Vouchers
  // -------------------------------------------------------------
  Widget _buildExclusiveVouchersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      color: TreatColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Exclusive Vouchers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: TreatColors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: TreatColors.secondaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'TAP TO COPY',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: TreatColors.onSecondaryFixed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Voucher 1: 50% Off First Treat
        _buildVoucherTile(
          code: 'TREAT50',
          title: '50% Off First Treat',
          tag: 'HOT',
          tagBg: TreatColors.primary.withValues(alpha: 0.12),
          tagText: TreatColors.primary,
          subtitle: 'Min spend \$15 • All Bakeries',
          icon: Icons.confirmation_number,
          iconBg: TreatColors.primaryFixed,
          iconColor: TreatColors.primary,
          buttonBg: TreatColors.primaryFixed,
          buttonTextColor: TreatColors.onPrimaryFixed,
        ),
        const SizedBox(height: 10),

        // Voucher 2: $20 Weekend Chill
        _buildVoucherTile(
          code: 'WEEKENDVIBE',
          title: '\$20 Weekend Chill',
          tag: 'NEW',
          tagBg: TreatColors.secondary.withValues(alpha: 0.12),
          tagText: TreatColors.secondary,
          subtitle: 'Table of 3+ • Drink Lounges',
          icon: Icons.celebration,
          iconBg: TreatColors.secondaryFixed,
          iconColor: TreatColors.secondary,
          buttonBg: TreatColors.secondaryFixed,
          buttonTextColor: TreatColors.onSecondaryFixed,
        ),
      ],
    );
  }

  Widget _buildVoucherTile({
    required String code,
    required String title,
    required String tag,
    required Color tagBg,
    required Color tagText,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color buttonBg,
    required Color buttonTextColor,
  }) {
    final isCopied = _copiedVoucherCode == code;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 12),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: TreatColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: tagText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: TreatColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Copy Code Button
          InkWell(
            onTap: () => _handleCopyVoucher(code),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isCopied ? TreatColors.secondary : buttonBg,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                isCopied ? 'COPIED!' : code,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: isCopied ? Colors.white : buttonTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Section 3: Featured Group Feast Spots
  // -------------------------------------------------------------
  Widget _buildFeaturedGroupFeastSpotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(
                      color: TreatColors.tertiary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Featured Group Feast Spots',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: TreatColors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: widget.onNavigateBudgetPlanner,
              child: Text(
                'View All',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TreatColors.tertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Spot 1: Sprinkle & Sizzle Social
        _buildFeastSpotCard(
          spotId: 'spot_1',
          name: 'Sprinkle & Sizzle Social',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAI0nXAGOn5z6bdt7tUpeXQ25PdhR9-ArKdCBUnDu9K7fVgHVT7dnjTfUlS6m7Aobwkgcl3Mo4AFhIWAbVYlF2si30TPDz5ZhXQrbAcGIAdEIhYjhxsxjQqKQjoum3cSJJ3kJ7ibeXlHS-c635oq6v8XOjaiM0sLKr-Nw031Gs1NBkRCNltcjvFPQ-4GGfb3PvvCMdq8AnHJUyiszsBm1oZqbLOTpMfeMaJ36mJClJa8iw__UzGVePMkQ',
          ratingText: '4.9 (1.2k)',
          statusBadge: '⚡ Instant Table',
          statusBadgeBg: TreatColors.primary,
          locationText: 'Soho Quarter • 0.4 miles away',
          priceTier: '\$\$ • Feasts',
          priceTierBg: TreatColors.tertiaryFixed,
          priceTierText: TreatColors.onTertiaryFixed,
          tags: ['Waffle Sliders', 'Boba Cocktails', 'Funky Booths', '+FREE Sparkler Sundae'],
          avgPrice: '\$28',
          onBookTable: () {
            context.read<BudgetPlannerState>().selectPlatter(PlatterDeal.fiestaPlatter);
            widget.onSelectDeal(PlatterDeal.fiestaPlatter);
          },
        ),
        const SizedBox(height: 18),

        // Spot 2: Sugar Smash & Patty Lounge
        _buildFeastSpotCard(
          spotId: 'spot_2',
          name: 'Sugar Smash & Patty Lounge',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC-sDzPusqpFUmqYi-cDYUoEfIVm_LEL-RisEaCn8vxp-Gpt08mdYjdg6WQH4P3Sz5_NW3faaPeSvNbliasdcrO6AjC_Xa0faUiPJ51iaM14qc-TUXY88sBmJN5CX9Qeu0SZ0FWpvmLdMr2Mjbv8QxwgF8EI9Zaixke5qRW0PY-2joDD3DkONh0RRmbsktg-s1HmnjMro86czBsyZx2c344F2tlOVhzRpdf9OosaI4_rXIiurSWCEtm2Q',
          ratingText: '4.8 (890)',
          statusBadge: 'Squad Deal -20%',
          statusBadgeBg: TreatColors.secondary,
          locationText: 'Midtown Carnival • 1.1 miles away',
          priceTier: '\$\$\$ • Gourmet',
          priceTierBg: TreatColors.secondaryFixed,
          priceTierText: TreatColors.onSecondaryFixed,
          tags: ['Smash Platters', 'Glow Cocktails', 'Arcade Games'],
          avgPrice: '\$32',
          onBookTable: () {
            context.read<BudgetPlannerState>().selectPlatter(PlatterDeal.sampleDeals[1]);
            widget.onSelectDeal(PlatterDeal.sampleDeals[1]);
          },
        ),
      ],
    );
  }

  Widget _buildFeastSpotCard({
    required String spotId,
    required String name,
    required String imageUrl,
    required String ratingText,
    required String statusBadge,
    required Color statusBadgeBg,
    required String locationText,
    required String priceTier,
    required Color priceTierBg,
    required Color priceTierText,
    required List<String> tags,
    required String avgPrice,
    required VoidCallback onBookTable,
  }) {
    final isFavorite = _favoritedSpots.contains(spotId);

    return Container(
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.12),
            blurRadius: 22,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header with Badges
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 176,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 176,
                  color: TreatColors.primaryFixed,
                  child: const Center(
                    child: Text('🍕 Delicious Platter Spot', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),

              // Gradient Shade Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.72),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),

              // Top Badges (Rating + Instant Status)
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            ratingText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: TreatColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBadgeBg,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Text(
                        statusBadge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Top Right Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isFavorite) {
                        _favoritedSpots.remove(spotId);
                      } else {
                        _favoritedSpots.add(spotId);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: isFavorite ? TreatColors.primary : TreatColors.onSurface,
                    ),
                  ),
                ),
              ),

              // Bottom Overlay on Image (Name, Location, Price Pill)
              Positioned(
                bottom: 12,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: Colors.white70),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  locationText,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: priceTierBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        priceTier,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: priceTierText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Card Details Below Image
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: tags.map((t) {
                      final isSpecial = t.startsWith('+');
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: isSpecial ? TreatColors.secondaryFixed : TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          t,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isSpecial ? FontWeight.w800 : FontWeight.w700,
                            color: isSpecial
                                ? TreatColors.onSecondaryFixed
                                : TreatColors.onSurfaceVariant,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Pricing and CTA Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            avgPrice,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: TreatColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '/ person avg',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: TreatColors.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Share Button
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: 'Check out $name on Treat!'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Link for $name copied!'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: TreatColors.secondary,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.share_rounded,
                              size: 18,
                              color: TreatColors.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Book Table Button
                        InkWell(
                          onTap: onBookTable,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: TreatColors.secondary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.35),
                                  blurRadius: 12,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Book Table',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_rounded, size: 15, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Section 4: Gamified Loyalty Perks Banner
  // -------------------------------------------------------------
  Widget _buildLoyaltyPerksBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TreatColors.primary.withValues(alpha: 0.12),
            TreatColors.secondary.withValues(alpha: 0.10),
            TreatColors.tertiary.withValues(alpha: 0.12),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TreatColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: TreatColors.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.loyalty_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mia's Sweet Treat Perks",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: TreatColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'You have 450 points ready to redeem!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: TreatColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _showSpinWheelDialog,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: TreatColors.secondary,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.25),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Spin Wheel 🎡',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive Gamified Spin Wheel Modal Dialog
class _SpinWheelModal extends StatefulWidget {
  final ValueChanged<int> onRewardClaimed;

  const _SpinWheelModal({required this.onRewardClaimed});

  @override
  State<_SpinWheelModal> createState() => _SpinWheelModalState();
}

class _SpinWheelModalState extends State<_SpinWheelModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  bool _isSpinning = false;
  int? _wonReward;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
    });

    _spinController.forward(from: 0.0).then((_) {
      final rewards = [50, 100, 150, 250];
      final won = rewards[math.Random().nextInt(rewards.length)];
      setState(() {
        _isSpinning = false;
        _wonReward = won;
      });
      widget.onRewardClaimed(won);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: TreatColors.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎡 Sweet Treat Wheel',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: TreatColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Spin for bonus sweet points & dessert discounts!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: TreatColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Animated Wheel
            AnimatedBuilder(
              animation: _spinAnimation,
              builder: (context, child) {
                final angle = _spinAnimation.value * 2 * math.pi * 5;
                return Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          Color(0xFFE040A0),
                          Color(0xFF7C52AA),
                          Color(0xFF0096CC),
                          Color(0xFFFFD6EE),
                          Color(0xFFE040A0),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TreatColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '🍰\n🍬  🍭\n🍩',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            if (_wonReward != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: TreatColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '+$_wonReward Sweet Points!',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: TreatColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isSpinning ? null : _spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TreatColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(
                  _isSpinning
                      ? 'Spinning...'
                      : (_wonReward != null ? 'Spin Again' : 'Spin Now!'),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(
                  color: TreatColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
