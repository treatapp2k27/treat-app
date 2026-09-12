import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/diner_persona.dart';
import '../../state/diner_state.dart';

class FoodieProfileSettingsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback? onNavigateHome;
  final VoidCallback? onLogOut;

  const FoodieProfileSettingsScreen({
    super.key,
    required this.onOpenDrawer,
    this.onNavigateHome,
    this.onLogOut,
  });

  @override
  State<FoodieProfileSettingsScreen> createState() =>
      _FoodieProfileSettingsScreenState();
}

class _FoodieProfileSettingsScreenState
    extends State<FoodieProfileSettingsScreen> {
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

  double _budgetSliderVal = 45.0;

  void _showEditPersonaDialog(BuildContext context) {
    final dinerState = context.read<DinerState>();
    final controller =
        TextEditingController(text: dinerState.currentPersona.handle);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF3E8FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Color(0xFF7C52AA),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Edit Display Persona',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF201A24),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how other diners see you on public feasts & community tables:',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFF706776),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF201A24),
              ),
              decoration: InputDecoration(
                hintText: 'e.g. MidnightDumpling',
                filled: true,
                fillColor: const Color(0xFFFBF6FD),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Color(0xFF7C52AA), width: 1.5),
                ),
              ),
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
                color: const Color(0xFF706776),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C52AA),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                dinerState.setHandle(text);
              }
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Save Persona',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSwitchPersonaDialog(BuildContext context) {
    final dinerState = context.read<DinerState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD3E2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Switch Active Persona',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF201A24),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        dinerState.shufflePersona();
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.shuffle_rounded, size: 16),
                      label: const Text('Shuffle'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF7C52AA),
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...DinerPersona.presetPersonas.map((preset) {
                  final handle = preset['handle']!;
                  final emoji = preset['emoji']!;
                  final isCurrent =
                      dinerState.currentPersona.handle == handle;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFFF2E8FC)
                            : const Color(0xFFF6F3F7),
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: const Color(0xFF7C52AA), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    title: Text(
                      handle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight:
                            isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isCurrent
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFF201A24),
                      ),
                    ),
                    subtitle: Text(
                      '@treat_nomad • Foodie Adventurer',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF7C52AA), size: 20)
                        : null,
                    onTap: () {
                      dinerState.setHandle(handle);
                      dinerState.setAvatarEmoji(emoji);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDietaryPreferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final dinerState = context.watch<DinerState>();
            final tags = dinerState.currentPersona.dietTags;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2E8FC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_outlined,
                      color: Color(0xFF7C52AA),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Dietary Preferences',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: const Color(0xFF201A24),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to toggle tags matched on platter menus:',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allTags.map((t) {
                        final name = t['name'] as String;
                        final icon = t['icon'] as IconData;
                        final isSelected = tags.contains(name);

                        return FilterChip(
                          selected: isSelected,
                          avatar: Icon(
                            icon,
                            size: 15,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF7C52AA),
                          ),
                          label: Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF201A24),
                            ),
                          ),
                          backgroundColor: const Color(0xFFF9F4FC),
                          selectedColor: const Color(0xFF7C52AA),
                          checkmarkColor: Colors.white,
                          shape: const StadiumBorder(
                            side: BorderSide(color: Color(0xFFE2D6EE)),
                          ),
                          onSelected: (_) {
                            dinerState.toggleDietTag(name);
                            setDialogState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C52AA),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Done',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTargetSpendDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final lower = (_budgetSliderVal - 15).clamp(15, 80).toInt();
            final upper = (_budgetSliderVal + 15).clamp(30, 150).toInt();

            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDD3E2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Target Spend per Diner',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF201A24),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Adjust your comfort dining range for platter splits:',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '\$$lower - \$$upper • Shared Feast',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF7C52AA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF7C52AA),
                        inactiveTrackColor: const Color(0xFFF0E5F7),
                        thumbColor: const Color(0xFF7C52AA),
                        overlayColor:
                            const Color(0xFF7C52AA).withValues(alpha: 0.15),
                      ),
                      child: Slider(
                        value: _budgetSliderVal,
                        min: 25.0,
                        max: 95.0,
                        divisions: 14,
                        onChanged: (val) {
                          setState(() => _budgetSliderVal = val);
                          setSheetState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C52AA),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Save Target Spend',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSquadSizeDialog(BuildContext context) {
    final dinerState = context.read<DinerState>();
    final options = [
      {'size': 2, 'label': '2-3 guests • Duo Nibble'},
      {'size': 4, 'label': '4-5 guests • Standard Squad Feast'},
      {'size': 6, 'label': '6-8 guests • Mega Group Feast'},
      {'size': 10, 'label': '10+ guests • Party Reservation'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD3E2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Default Squad Size',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFF201A24),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Preferred table reservation headcount for group platters:',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFF706776),
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((opt) {
                  final size = opt['size'] as int;
                  final label = opt['label'] as String;
                  final isCurrent =
                      dinerState.currentPersona.preferredSquadSize == size;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFFF2E8FC)
                            : const Color(0xFFF6F3F7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCurrent
                            ? Icons.check_circle_rounded
                            : Icons.groups_outlined,
                        color: isCurrent
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFFA098A5),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight:
                            isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isCurrent
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFF201A24),
                      ),
                    ),
                    onTap: () {
                      dinerState.setPreferredSquadSize(size);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSquadLudoModal() {
    showDialog(
      context: context,
      builder: (ctx) => _SquadLudoProfileModal(
        onRewardClaimed: (reward) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Awesome! You won $reward!'),
              backgroundColor: TreatColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  void _showExportHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF2E8FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF7C52AA),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Export Dining History',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF201A24),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your anonymous dining transactions, redeemed platter vouchers, and group split receipts are compiled.',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFF706776),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6FD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEADBEE)),
              ),
              child: Text(
                'treat_diner_pass_history_2026.csv\n• 34 Verified Treats Claimed\n• \$185 Total Community Savings\n• Zero PII Disclosed',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11,
                  color: const Color(0xFF493B52),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Dismiss',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF706776),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C52AA),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Downloaded treat_diner_pass_history_2026.csv! 📜'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: Text(
              'Download CSV',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Log Out of Foodie?',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF201A24),
              ),
            ),
          ],
        ),
        content: Text(
          'You will return to the Welcome & Explore screen in Guest mode. Your saved personas and vouchers will be preserved.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: const Color(0xFF706776),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF706776),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<DinerState>().setFoodieLoggedIn(false);
              if (widget.onLogOut != null) {
                widget.onLogOut!();
              } else if (widget.onNavigateHome != null) {
                widget.onNavigateHome!();
              }
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final persona = dinerState.currentPersona;

    final lowerBudget = (_budgetSliderVal - 15).clamp(15, 80).toInt();
    final upperBudget = (_budgetSliderVal + 15).clamp(30, 150).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: _buildTopAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 44),
        children: [
          // ==========================================
          // 1. Hero Profile & Identity Card
          // ==========================================
          _buildHeroProfileCard(context, dinerState, persona),
          const SizedBox(height: 22),

          // ==========================================
          // 2. Section: ACCOUNT & PERSONA
          // ==========================================
          _buildSectionHeader('ACCOUNT & PERSONA'),
          const SizedBox(height: 8),
          _buildCardContainer(
            children: [
              _buildSettingRow(
                icon: Icons.badge_outlined,
                title: 'Display Persona',
                subtitle: '${persona.handle} (@treat_nomad)',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFA098A5),
                  size: 20,
                ),
                onTap: () => _showEditPersonaDialog(context),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.visibility_off_outlined,
                title: 'Anonymous Mode',
                subtitle: 'Hide real name on public food tables',
                trailing: Switch(
                  value: persona.hideRealName,
                  onChanged: (val) => dinerState.toggleHideRealName(val),
                  activeColor: const Color(0xFF7C52AA),
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.restaurant_outlined,
                title: 'Dietary Preferences',
                subtitle: persona.dietTags.isNotEmpty
                    ? persona.dietTags.join(', ')
                    : 'Spicy, Halal, Veg +3',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFA098A5),
                  size: 20,
                ),
                onTap: () => _showDietaryPreferencesDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ==========================================
          // 3. Section: PREFERENCES & DINING
          // ==========================================
          _buildSectionHeader('PREFERENCES & DINING'),
          const SizedBox(height: 8),
          _buildCardContainer(
            children: [
              _buildSettingRow(
                icon: Icons.payments_outlined,
                title: 'Target Spend per Diner',
                subtitle: '\$$lowerBudget – \$$upperBudget • Shared Feast',
                trailing: IconButton(
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF706776),
                    size: 20,
                  ),
                  onPressed: () => _showTargetSpendDialog(context),
                ),
                onTap: () => _showTargetSpendDialog(context),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.groups_outlined,
                title: 'Default Squad Size',
                subtitle:
                    '${persona.preferredSquadSize}-${persona.preferredSquadSize + 1} guests including you',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFA098A5),
                  size: 20,
                ),
                onTap: () => _showSquadSizeDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ==========================================
          // 4. Section: TREAT SQUAD & GAMES
          // ==========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: _buildSectionHeader('TREAT SQUAD & GAMES')),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE4F7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.casino_outlined,
                      size: 13,
                      color: Color(0xFF653993),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4-Player Live',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF653993),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSquadLudoCard(context),
          const SizedBox(height: 22),

          // ==========================================
          // 5. Section: PRIVACY & DISCOVERY
          // ==========================================
          _buildSectionHeader('PRIVACY & DISCOVERY'),
          const SizedBox(height: 8),
          _buildCardContainer(
            children: [
              _buildSettingRow(
                icon: Icons.radar_rounded,
                title: 'Ghost Browsing in Food Bar',
                subtitle: 'Browse counters without live check-in tag',
                trailing: Switch(
                  value: persona.ghostBrowsing,
                  onChanged: (val) => dinerState.toggleGhostBrowsing(val),
                  activeColor: const Color(0xFF7C52AA),
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.link_rounded,
                title: 'Direct Squad Invites',
                subtitle: 'Allow friends to join table via link',
                trailing: Switch(
                  value: persona.allowSquadInvite,
                  onChanged: (val) => dinerState.toggleAllowSquadInvite(val),
                  activeColor: const Color(0xFF7C52AA),
                ),
              ),
              _buildDivider(),
              _buildSettingRow(
                icon: Icons.location_on_outlined,
                title: 'Neighborhood Location Sharing',
                subtitle: 'Show nearby platter drops & offers',
                trailing: Switch(
                  value: dinerState.isFoodieLoggedIn,
                  onChanged: (val) => dinerState.setFoodieLoggedIn(val),
                  activeColor: const Color(0xFF7C52AA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ==========================================
          // 6. Section: NOTIFICATIONS
          // ==========================================
          _buildSectionHeader('NOTIFICATIONS'),
          const SizedBox(height: 8),
          _buildCardContainer(
            children: [
              _buildSettingRow(
                icon: Icons.notifications_active_outlined,
                title: 'Platter Drops & Deal Radar',
                subtitle: 'Instant alerts when dishes open up',
                trailing: Switch(
                  value: persona.dealRadarAlerts,
                  onChanged: (val) => dinerState.toggleDealRadarAlerts(val),
                  activeColor: const Color(0xFF7C52AA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ==========================================
          // 7. Bottom Action Buttons
          // ==========================================
          // Button 1: Export Dining History
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showExportHistoryDialog(context),
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFE2D6EE),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(124, 82, 170, 0.06),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFF7C52AA),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Export Dining History',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7C52AA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Button 2: Log Out
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLogOutDialog(context),
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF0ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Header App Bar matching screenshot
  // -------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1.5,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      toolbarHeight: 62,
      title: Row(
        children: [
          // Drawer / Logo Leading
          Expanded(
            child: InkWell(
              onTap: widget.onOpenDrawer,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Image.asset(
                    AssetConstants.logo,
                    height: 28,
                    errorBuilder: (_, __, ___) => Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFE040A0), Color(0xFF7C52AA)],
                        ),
                      ),
                      child: const Center(
                        child: Text('🎉', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TREATS & CO',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: const Color(0xFF7C52AA),
                          ),
                        ),
                        Text(
                          'Community Treats',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF201A24),
                            letterSpacing: -0.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notification Bell Icon Button
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new alerts! You are all caught up. 🎉'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF201A24),
              size: 24,
            ),
            tooltip: 'Notifications',
          ),

          // Profile Avatar Icon Button
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD6228A),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. Hero Profile & Identity Card
  // -------------------------------------------------------------
  Widget _buildHeroProfileCard(
      BuildContext context, DinerState dinerState, DinerPersona persona) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF3E8FC),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Verified Checkmark Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7C52AA),
                        width: 2.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(224, 64, 160, 0.20),
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
                        color: const Color(0xFFF3E8FC),
                        alignment: Alignment.center,
                        child: Text(
                          persona.avatarEmoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7C52AA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Name, Tag, Handle, and VIP Row
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            persona.handle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF201A24),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '#FD-882',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8E8295),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@treat_nomad',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5E8FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.card_giftcard_rounded,
                                size: 12,
                                color: Color(0xFF7C52AA),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'VIP Level 2',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF7C52AA),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '34 Treats Claimed',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF706776),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom Action Buttons: Switch Persona & Edit
          Row(
            children: [
              // Button 1: Switch Persona
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showSwitchPersonaDialog(context),
                    borderRadius: BorderRadius.circular(999),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F4FC),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.switch_account_outlined,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Switch Persona',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Button 2: Edit
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showEditPersonaDialog(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8EEFC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 15,
                          color: Color(0xFF6A1B9A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Edit',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF6A1B9A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Helpers for Setting Rows & Cards
  // -------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: const Color(0xFF7C52AA),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF3E8FC),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.05),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        child: Row(
          children: [
            // Circular icon container
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF3E8FC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF7C52AA),
                size: 19,
              ),
            ),
            const SizedBox(width: 12),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF201A24),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF706776),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFFF7EFFB),
      height: 1,
      thickness: 1,
      indent: 48,
    );
  }

  // -------------------------------------------------------------
  // 4. Treat Squad & Games Card
  // -------------------------------------------------------------
  Widget _buildSquadLudoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF4FA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFCE7F3),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(224, 64, 160, 0.08),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Magenta Square Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE040A0),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(224, 64, 160, 0.30),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.casino_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Treat Squad Ludo',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF201A24),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Challenge your foodie crew, roll the dice, and win exclusive feast vouchers!',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF706776),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFF3DCEB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.groups_rounded,
                            size: 13,
                            color: Color(0xFF7C52AA),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Live Squad Rooms',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF7C52AA),
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
          const SizedBox(height: 14),

          // Play Squad Ludo Magenta Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showSquadLudoModal,
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                height: 44,
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
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Play Squad Ludo',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Interactive Squad Ludo Minigame Dialog for Profile Settings
// -------------------------------------------------------------
class _SquadLudoProfileModal extends StatefulWidget {
  final ValueChanged<String> onRewardClaimed;

  const _SquadLudoProfileModal({required this.onRewardClaimed});

  @override
  State<_SquadLudoProfileModal> createState() => _SquadLudoProfileModalState();
}

class _SquadLudoProfileModalState extends State<_SquadLudoProfileModal>
    with SingleTickerProviderStateMixin {
  int _currentDice = 6;
  bool _isRolling = false;
  String? _wonPerk;
  int _score = 420;
  late final AnimationController _diceController;

  final List<String> _rewards = [
    '25% OFF Squad Feast Platter Voucher 🎫',
    'Free Mochi Dessert Tower 🍓',
    '1 Free Pitcher of Craft Berry Slush 🍹',
    '\$10 Treat Quick Credit for Group 💰',
    'VIP Fast Pass Table Hold ⚡',
  ];

  @override
  void initState() {
    super.initState();
    _diceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _diceController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
      _wonPerk = null;
    });

    _diceController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      final roll = math.Random().nextInt(6) + 1;
      final reward = _rewards[math.Random().nextInt(_rewards.length)];
      setState(() {
        _currentDice = roll;
        _isRolling = false;
        _score += roll * 10;
        _wonPerk = reward;
      });
      widget.onRewardClaimed(reward);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🎲', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Treat Squad Ludo',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF201A24),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF706776)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Roll the magic dice with your squad to land on sweet perks & discount platters!',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFF706776),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Animated Dice Box
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C52AA), Color(0xFFE040A0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(224, 64, 160, 0.35),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 2.0)
                      .animate(_diceController),
                  child: Text(
                    _isRolling ? '🎲' : '$_currentDice',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Squad Score: $_score pts',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF7C52AA),
              ),
            ),

            if (_wonPerk != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2D6EE)),
                ),
                child: Text(
                  '🎁 You Won:\n$_wonPerk',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF653993),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C52AA),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                    onPressed: _isRolling ? null : _rollDice,
                    child: Text(
                      _isRolling ? 'Rolling...' : 'Roll Dice! 🎲',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF706776),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
