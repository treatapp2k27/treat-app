import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../state/diner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

class FoodieProfileSettingsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;

  const FoodieProfileSettingsScreen({super.key, required this.onOpenDrawer});

  @override
  State<FoodieProfileSettingsScreen> createState() => _FoodieProfileSettingsScreenState();
}

class _FoodieProfileSettingsScreenState extends State<FoodieProfileSettingsScreen>
    with SingleTickerProviderStateMixin {
  static const List<Map<String, dynamic>> allTags = [
    {'name': 'Spicy Lover', 'icon': Icons.local_fire_department_rounded},
    {'name': 'Halal', 'icon': Icons.verified_rounded},
    {'name': 'Vegetarian', 'icon': Icons.eco_rounded},
    {'name': 'Nut-Free', 'icon': Icons.no_food_rounded},
    {'name': 'Late Night Spots', 'icon': Icons.dark_mode_rounded},
    {'name': 'Platter Craver', 'icon': Icons.tapas_rounded},
    {'name': 'Gluten-Lite', 'icon': Icons.ramen_dining_rounded},
    {'name': 'Pescatarian', 'icon': Icons.set_meal_rounded},
    {'name': 'Sweet Treats', 'icon': Icons.cake_rounded},
    {'name': 'Boba Lover', 'icon': Icons.local_cafe_rounded},
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _budgetSliderVal = 35.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showAddCustomFundsDialog(BuildContext context, DinerState dinerState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: TreatColors.surfaceContainerLowest,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: TreatColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: TreatColors.secondary, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Add Treat Credits',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: TreatColors.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the custom amount to add to your Treat Wallet for instant partner table settlements:',
              style: TreatTypography.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: TreatColors.secondary,
                ),
                hintText: '25.00',
                filled: true,
                fillColor: TreatColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [15.0, 30.0, 75.0].map((amt) {
                return InkWell(
                  onTap: () {
                    controller.text = amt.toStringAsFixed(2);
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: TreatColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+\$${amt.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: TreatColors.onPrimaryFixed,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: TreatColors.outline,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TreatColors.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              final val = double.tryParse(controller.text.trim());
              if (val != null && val > 0) {
                dinerState.addWalletFunds(val);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added \$${val.toStringAsFixed(2)} Treat Credits! 🍰'),
                    backgroundColor: TreatColors.secondary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Confirm Top Up',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog(BuildContext context, DinerState dinerState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: TreatColors.surfaceContainerLowest,
        title: Text(
          'Add Custom Taste Tag',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: TreatColors.onSurface,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Truffle Fanatic',
            filled: true,
            fillColor: TreatColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TreatColors.secondary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                dinerState.toggleDietTag(text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add Tag'),
          ),
        ],
      ),
    );
  }

  void _showExportHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.history_edu_rounded, color: TreatColors.secondary),
            const SizedBox(width: 8),
            Text(
              'Export Dining History',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your anonymous dining transactions, redeemed platter vouchers, and group split receipts are compiled.',
              style: TreatTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'treat_diner_pass_history_2026.csv\n• 34 Verified Treats Claimed\n• \$185 Total Community Savings\n• Zero PII Disclosed',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11,
                  color: TreatColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Dismiss'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: TreatColors.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloaded treat_diner_pass_history_2026.csv! 📜'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Download CSV'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final persona = dinerState.currentPersona;

    final lowerBudget = (_budgetSliderVal - 15).clamp(10, 90).toInt();
    final upperBudget = (_budgetSliderVal + 15).clamp(15, 120).toInt();

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Treat',
        actionIcon: Icons.celebration_rounded,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 44),
        children: [
          // ==========================================
          // 1. Hero Profile & Identity Card
          // ==========================================
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Ambient Glow Decor Blobs behind card
              Positioned(
                top: -16,
                right: -16,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: TreatColors.primaryFixed.withValues(alpha: 0.70),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(224, 64, 160, 0.25),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                left: -12,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: TreatColors.secondaryFixed.withValues(alpha: 0.60),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(124, 82, 170, 0.20),
                        blurRadius: 36,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              TreatCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with Glow & Magic Wand Shuffle Button
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: TreatColors.primary,
                                  width: 2.8,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(224, 64, 160, 0.30),
                                    blurRadius: 16,
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
                                    style: const TextStyle(fontSize: 34),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -3,
                              right: -3,
                              child: InkWell(
                                onTap: () {
                                  dinerState.shufflePersona();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Shuffled to ${dinerState.currentPersona.handle}! ✨'),
                                      duration: const Duration(milliseconds: 1400),
                                      backgroundColor: TreatColors.secondary,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: TreatColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.auto_fix_high_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Identity Meta: VIP Pill, Handle, Tagline & Shuffle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      gradient: TreatColors.pinkGradient,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(224, 64, 160, 0.30),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'ANONYMOUS VIP',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '#FD-882',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: TreatColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      persona.handle,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: TreatColors.onSurface,
                                        letterSpacing: -0.4,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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

                              Text(
                                '@treat_nomad • Foodie Adventurer',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: TreatColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Shuffle Persona Pill Button
                              InkWell(
                                onTap: () {
                                  dinerState.shufflePersona();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Shuffled to ${dinerState.currentPersona.handle}! 🎲'),
                                      duration: const Duration(milliseconds: 1400),
                                      backgroundColor: TreatColors.primary,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    gradient: TreatColors.pinkGradient,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(224, 64, 160, 0.35),
                                        blurRadius: 12,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.casino_rounded,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Shuffle Persona',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
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
                    ),
                    const SizedBox(height: 18),

                    // Persona Tag Chips Row with Add Button
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildPersonaPill(
                          '${persona.avatarEmoji} ${persona.handle}',
                          TreatColors.primary,
                          Colors.white,
                          isPrimary: true,
                        ),
                        _buildPersonaPill(
                          '🌮 Taco Fiend',
                          TreatColors.secondaryFixed,
                          TreatColors.onSecondaryFixedVariant,
                        ),
                        _buildPersonaPill(
                          '🍩 Sweet Tooth',
                          TreatColors.tertiaryFixed,
                          TreatColors.onTertiaryFixedVariant,
                        ),
                        InkWell(
                          onTap: () => _showAddTagDialog(context, dinerState),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerHigh,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TreatColors.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: TreatColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // ==========================================
                    // VIP Foodie Pass Ribbon Card
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: TreatColors.potBannerGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(224, 64, 160, 0.28),
                            blurRadius: 18,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.22),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.workspace_premium_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'VIP PASS LEVEL ${persona.vipLevel}',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                              color: Colors.white,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          FadeTransition(
                                            opacity: _pulseAnimation,
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${persona.treatsClaimed} Treats Claimed • \$${persona.totalSaved.toInt()} Total Saved',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(alpha: 0.90),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  'Active VIP',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Stack(
                              children: [
                                Container(
                                  height: 8,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.68,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '6 treats to VIP Gold 🧁',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
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
          const SizedBox(height: 18),

          // ==========================================
          // 2. Treat Wallet & Quick Pay Card
          // ==========================================
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 20,
                            color: TreatColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Treat Wallet & Quick Pay',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: TreatColors.onSurface,
                              ),
                            ),
                            Text(
                              'Instant partner settlement credits',
                              style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: TreatColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Auto-Settle',
                        style: GoogleFonts.plusJakartaSans(
                          color: TreatColors.onTertiaryFixedVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Balance Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF0E4F2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Balance',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: TreatColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${persona.walletBalance.toStringAsFixed(2)}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: TreatColors.secondary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TreatColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              elevation: 3,
                              shadowColor: TreatColors.primary.withValues(alpha: 0.4),
                            ),
                            onPressed: () =>
                                _showAddCustomFundsDialog(context, dinerState),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(
                              'Add Funds',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Quick Top-Up Preset Chips
                      Row(
                        children: [
                          Text(
                            'Quick Top-Up:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: TreatColors.outline,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [10.0, 25.0, 50.0].map((amt) {
                                return InkWell(
                                  onTap: () {
                                    dinerState.addWalletFunds(amt);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Added +\$${amt.toInt()}.00 Treat Credits! 🍰'),
                                        backgroundColor: TreatColors.secondary,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: TreatColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: TreatColors.secondary
                                            .withValues(alpha: 0.30),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '+\$${amt.toInt()}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: TreatColors.secondary,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ==========================================
          // 3. Taste Radar & Diet Tags
          // ==========================================
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Taste Radar & Diet Tags',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: TreatColors.onSurface,
                          ),
                        ),
                        Text(
                          'Used to personalize platter recommendations',
                          style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: TreatColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${persona.dietTags.length} Active',
                        style: GoogleFonts.plusJakartaSans(
                          color: TreatColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Multi-select tags grid
                Wrap(
                  spacing: 8,
                  runSpacing: 9,
                  children: allTags.map((tag) {
                    final isSelected = persona.dietTags.contains(tag['name']);
                    return InkWell(
                      onTap: () => dinerState.toggleDietTag(tag['name'] as String),
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TreatColors.secondary
                              : TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? TreatColors.secondary
                                : const Color(0xFFEADBEE),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: TreatColors.secondary
                                        .withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tag['icon'] as IconData,
                              size: 15,
                              color: isSelected
                                  ? Colors.white
                                  : TreatColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tag['name'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected
                                    ? Colors.white
                                    : TreatColors.onSurface,
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ==========================================
          // 4. Budget & Split Dining Settings
          // ==========================================
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget & Split Dining',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: TreatColors.onSurface,
                  ),
                ),
                Text(
                  'Default preferences applied when matching food squads',
                  style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 16),

                // Squad Size Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEADBEE)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: TreatColors.secondaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              size: 18,
                              color: TreatColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preferred Squad Size',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: TreatColors.onSurface,
                                ),
                              ),
                              Text(
                                'Including you',
                                style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              onPressed: persona.preferredSquadSize > 1
                                  ? () => dinerState.setPreferredSquadSize(
                                      persona.preferredSquadSize - 1)
                                  : null,
                              constraints:
                                  const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              color: TreatColors.onSurface,
                            ),
                            Text(
                              '${persona.preferredSquadSize}',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: TreatColors.onSurface,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded, size: 18),
                              onPressed: persona.preferredSquadSize < 12
                                  ? () => dinerState.setPreferredSquadSize(
                                      persona.preferredSquadSize + 1)
                                  : null,
                              constraints:
                                  const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              color: TreatColors.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Target Spend Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target Spend / Diner',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: TreatColors.onSurface,
                      ),
                    ),
                    Text(
                      '\$$lowerBudget - \$$upperBudget',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: TreatColors.secondary,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: TreatColors.secondary,
                    inactiveTrackColor: TreatColors.surfaceContainerHighest,
                    thumbColor: TreatColors.secondary,
                    overlayColor: TreatColors.secondary.withValues(alpha: 0.15),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _budgetSliderVal,
                    min: 15,
                    max: 90,
                    divisions: 15,
                    onChanged: (val) {
                      setState(() {
                        _budgetSliderVal = val;
                      });
                      dinerState.setBudgetTarget(val * persona.preferredSquadSize);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$15 Quick Bite',
                        style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    Text('\$50 Shared Feast',
                        style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    Text('\$90 Tasting Menu',
                        style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 16),

                // Auto-Split Bill Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: TreatColors.tertiaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.call_split_rounded,
                                size: 18,
                                color: TreatColors.tertiary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Auto-Split Bill via Treat Credits',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Instant settle at partner checkout',
                                    style: TreatTypography.bodySmall
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: persona.autoSplitBill,
                        activeThumbColor: TreatColors.secondary,
                        onChanged: (val) => dinerState.toggleAutoSplitBill(val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ==========================================
          // 5. Privacy & Ghosting Controls
          // ==========================================
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: TreatColors.secondaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.visibility_off_rounded,
                        size: 18,
                        color: TreatColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy & Ghosting',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: TreatColors.onSurface,
                          ),
                        ),
                        Text(
                          'Control who sees you at the shared table',
                          style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _buildToggleRow(
                  title: 'Hide real name completely',
                  subtitle: "Only show persona tag '@treat_nomad'",
                  value: persona.hideRealName,
                  onChanged: (val) => dinerState.toggleHideRealName(val),
                ),
                const SizedBox(height: 10),

                _buildToggleRow(
                  title: 'Allow squad invite via shareable link',
                  subtitle: 'Friends can hop directly onto your table',
                  value: persona.allowSquadInvite,
                  onChanged: (val) => dinerState.toggleAllowSquadInvite(val),
                ),
                const SizedBox(height: 10),

                _buildToggleRow(
                  title: 'Ghost browsing in Food Bar',
                  subtitle: 'Browse partner counter without live check-in tag',
                  value: persona.ghostBrowsing,
                  onChanged: (val) => dinerState.toggleGhostBrowsing(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ==========================================
          // 6. Live Drop Alerts
          // ==========================================
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: TreatColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        size: 18,
                        color: TreatColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Live Drop Alerts',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: TreatColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                _buildAlertToggle(
                  dotColor: TreatColors.primary,
                  title: 'Instant Platter Drop Alerts',
                  value: persona.instantDropAlerts,
                  onChanged: (val) => dinerState.toggleInstantDropAlerts(val),
                ),
                const SizedBox(height: 8),

                _buildAlertToggle(
                  dotColor: TreatColors.secondary,
                  title: '15-min Table Hold Reminders',
                  value: persona.tableHoldReminders,
                  onChanged: (val) => dinerState.toggleTableHoldReminders(val),
                ),
                const SizedBox(height: 8),

                _buildAlertToggle(
                  dotColor: TreatColors.tertiary,
                  title: 'Neighborhood Deal Radar',
                  value: persona.dealRadarAlerts,
                  onChanged: (val) => dinerState.toggleDealRadarAlerts(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ==========================================
          // 7. Account Action Buttons
          // ==========================================
          TreatButton(
            text: 'Switch Active Persona',
            icon: Icons.switch_account_rounded,
            variant: TreatButtonVariant.purpleGradient,
            onPressed: () {
              dinerState.shufflePersona();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Switched to ${dinerState.currentPersona.handle}! 🎉'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: TreatColors.secondary,
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TreatColors.secondary,
                    side: const BorderSide(color: TreatColors.outlineVariant),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () => _showExportHistoryDialog(context),
                  icon: const Icon(Icons.history_edu_rounded, size: 17),
                  label: Text(
                    'Export History',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TreatColors.error,
                    backgroundColor: TreatColors.errorContainer,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Text('Log Out of Treat?'),
                        content: const Text(
                            'Are you sure you want to end your current anonymous session?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TreatColors.error,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logged out of session 👋'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 17),
                  label: Text(
                    'Log Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E4F2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: TreatColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: TreatColors.secondary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertToggle({
    required Color dotColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: TreatColors.onSurface,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          activeThumbColor: TreatColors.secondary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPersonaPill(
    String text,
    Color bg,
    Color textCol, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: isPrimary
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(224, 64, 160, 0.30),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: textCol,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
