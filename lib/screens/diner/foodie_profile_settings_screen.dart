import 'package:flutter/material.dart';
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

class _FoodieProfileSettingsScreenState extends State<FoodieProfileSettingsScreen> {
  static const List<Map<String, dynamic>> allTags = [
    {'name': 'Spicy Lover', 'icon': Icons.local_fire_department},
    {'name': 'Halal', 'icon': Icons.verified},
    {'name': 'Vegetarian', 'icon': Icons.eco},
    {'name': 'Nut-Free', 'icon': Icons.no_food},
    {'name': 'Late Night Spots', 'icon': Icons.dark_mode},
    {'name': 'Platter Craver', 'icon': Icons.tapas},
    {'name': 'Gluten-Lite', 'icon': Icons.ramen_dining},
    {'name': 'Pescatarian', 'icon': Icons.set_meal},
  ];

  double _budgetSliderVal = 35.0;

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
        actionIcon: Icons.celebration,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 36),
        children: [
          // Profile & Identity Card
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: TreatColors.primaryFixed,
                          child: Text(persona.avatarEmoji, style: const TextStyle(fontSize: 36)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => dinerState.shufflePersona(),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: TreatColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_fix_high, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: TreatColors.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'ANONYMOUS VIP',
                                  style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text('#FD-882', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(persona.handle, style: TreatTypography.titleMedium.copyWith(fontSize: 18)),
                          Text('@treat_nomad', style: TreatTypography.bodySmall.copyWith(color: TreatColors.secondary)),
                          const SizedBox(height: 8),
                          TreatButton(
                            text: 'Shuffle Persona',
                            icon: Icons.casino,
                            height: 36,
                            width: 150,
                            variant: TreatButtonVariant.pinkGradient,
                            onPressed: () => dinerState.shufflePersona(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Persona Tags
                Wrap(
                  spacing: 6,
                  children: [
                    _buildPersonaPill('${persona.avatarEmoji} ${persona.handle}', TreatColors.primary, Colors.white),
                    _buildPersonaPill('🌮 Taco Fiend', TreatColors.secondaryFixed, TreatColors.onSecondaryFixedVariant),
                    _buildPersonaPill('🍩 Sweet Tooth', TreatColors.tertiaryFixed, TreatColors.onTertiaryFixedVariant),
                  ],
                ),
                const SizedBox(height: 16),

                // VIP Foodie Pass Ribbon Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: TreatColors.potBannerGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: TreatColors.pillShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VIP Pass Level ${persona.vipLevel}',
                                    style: TreatTypography.labelMedium.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    '${persona.treatsClaimed} Treats Claimed • \$${persona.totalSaved.toInt()} Saved',
                                    style: TreatTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Active',
                              style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          value: 0.68,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '6 treats to VIP Gold 🧁',
                          style: TreatTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Treat Wallet & Quick Pay Card
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance_wallet, size: 18, color: TreatColors.secondary),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Treat Wallet & Quick Pay', style: TreatTypography.titleSmall),
                            Text('Instant partner settlement credits', style: TreatTypography.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: TreatColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Auto-Settle',
                        style: TreatTypography.labelSmall.copyWith(
                          color: TreatColors.onTertiaryFixedVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Available Balance', style: TreatTypography.bodySmall),
                          Text(
                            '\$${persona.walletBalance.toStringAsFixed(2)}',
                            style: TreatTypography.headlineMedium.copyWith(
                              color: TreatColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TreatColors.primary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          elevation: 2,
                        ),
                        onPressed: () {
                          dinerState.addWalletFunds(25.0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added \$25.00 Treat Credits to your wallet! 🍰'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Funds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Taste Radar & Diet Tags
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Taste Radar & Diet Tags', style: TreatTypography.titleSmall),
                        Text('Used to personalize platter recommendations', style: TreatTypography.bodySmall),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: TreatColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${persona.dietTags.length} Active',
                        style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Multi-select chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allTags.map((tag) {
                    final isSelected = persona.dietTags.contains(tag['name']);
                    return InkWell(
                      onTap: () => dinerState.toggleDietTag(tag['name'] as String),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? TreatColors.secondary : TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: isSelected ? TreatColors.pillShadow : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tag['icon'] as IconData,
                              size: 14,
                              color: isSelected ? Colors.white : TreatColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tag['name'] as String,
                              style: TreatTypography.labelSmall.copyWith(
                                color: isSelected ? Colors.white : TreatColors.onSurface,
                                fontSize: 11,
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
          const SizedBox(height: 16),

          // 3. Budget & Split Dining Settings
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Budget & Split Dining', style: TreatTypography.titleSmall),
                Text('Default preferences applied when matching food squads', style: TreatTypography.bodySmall),
                const SizedBox(height: 14),

                // Squad Size Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.groups, size: 20, color: TreatColors.secondary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preferred Squad Size', style: TreatTypography.labelMedium),
                              Text('Including you', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: persona.preferredSquadSize > 1
                                  ? () => dinerState.setPreferredSquadSize(persona.preferredSquadSize - 1)
                                  : null,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              '${persona.preferredSquadSize}',
                              style: TreatTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: persona.preferredSquadSize < 10
                                  ? () => dinerState.setPreferredSquadSize(persona.preferredSquadSize + 1)
                                  : null,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Budget Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Target Spend / Diner', style: TreatTypography.labelMedium),
                    Text(
                      '\$$lowerBudget - \$$upperBudget',
                      style: TreatTypography.titleSmall.copyWith(
                        color: TreatColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _budgetSliderVal,
                  min: 15,
                  max: 90,
                  divisions: 15,
                  activeColor: TreatColors.secondary,
                  onChanged: (val) {
                    setState(() {
                      _budgetSliderVal = val;
                    });
                    dinerState.setBudgetTarget(val * persona.preferredSquadSize);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$15 Quick Bite', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    Text('\$50 Shared Feast', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    Text('\$90 Tasting Menu', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 14),

                // Auto-Split Bill Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.call_split, size: 20, color: TreatColors.tertiary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Auto-Split Bill via Treat Credits', style: TreatTypography.labelMedium),
                                Text('Instant settle at partner checkout', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
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
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Privacy & Ghosting Controls
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: TreatColors.secondaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.visibility_off, size: 16, color: TreatColors.secondary),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy & Ghosting', style: TreatTypography.titleSmall),
                        Text('Control who sees you at the shared table', style: TreatTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Hide real name
                _buildToggleRow(
                  title: 'Hide real name completely',
                  subtitle: "Only show persona tag '@treat_nomad'",
                  value: persona.hideRealName,
                  onChanged: (val) => dinerState.toggleHideRealName(val),
                ),
                const SizedBox(height: 8),

                // Squad invite link
                _buildToggleRow(
                  title: 'Allow squad invite via shareable link',
                  subtitle: 'Friends can hop directly onto your table',
                  value: persona.allowSquadInvite,
                  onChanged: (val) => dinerState.toggleAllowSquadInvite(val),
                ),
                const SizedBox(height: 8),

                // Ghost browsing
                _buildToggleRow(
                  title: 'Ghost browsing in Food Bar',
                  subtitle: 'Browse partner counter without live check-in tag',
                  value: persona.ghostBrowsing,
                  onChanged: (val) => dinerState.toggleGhostBrowsing(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Live Drop Alerts
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: TreatColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_active, size: 16, color: TreatColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text('Live Drop Alerts', style: TreatTypography.titleSmall),
                  ],
                ),
                const SizedBox(height: 12),

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
          const SizedBox(height: 18),

          // 6. Account Action Buttons
          TreatButton(
            text: 'Switch Active Persona',
            icon: Icons.switch_account,
            variant: TreatButtonVariant.purpleGradient,
            onPressed: () {
              dinerState.shufflePersona();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${dinerState.currentPersona.handle}! 🎉'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TreatColors.secondary,
                    side: const BorderSide(color: TreatColors.outlineVariant),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exported dining history to CSV! 📜'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_edu, size: 16),
                  label: const Text('Export History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TreatColors.error,
                    backgroundColor: TreatColors.errorContainer,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logged out of session 👋'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TreatTypography.labelMedium),
                Text(subtitle, style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
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
              ),
            ),
            const SizedBox(width: 8),
            Text(title, style: TreatTypography.bodyMedium),
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

  Widget _buildPersonaPill(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TreatTypography.labelSmall.copyWith(color: textCol, fontSize: 11),
      ),
    );
  }
}
