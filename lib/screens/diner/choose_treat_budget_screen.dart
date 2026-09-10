import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/platter_deal.dart';
import '../../state/budget_planner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

class ChooseTreatBudgetScreen extends StatelessWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal) onSelectDeal;

  const ChooseTreatBudgetScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectDeal,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BudgetPlannerState>();
    final matches = state.matchedPlatters;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: onOpenDrawer,
        actionLabel: 'Radar',
        actionIcon: Icons.radar,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 36),
        children: [
          // Smart Matcher Card
          TreatCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: TreatColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune, size: 12, color: TreatColors.onPrimaryFixedVariant),
                          const SizedBox(width: 4),
                          Text(
                            'SMART MATCHER',
                            style: TreatTypography.labelSmall.copyWith(
                              fontSize: 9,
                              color: TreatColors.onPrimaryFixedVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: TreatColors.tertiaryFixed,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 150, 204, 0.2),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Icon(Icons.savings, color: TreatColors.onTertiaryFixed, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Calculate & Find Treats in Your Budget',
                  style: TreatTypography.headlineSmall.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set your sweet spot & feast like royalty without wallet shock!',
                  style: TreatTypography.bodySmall,
                ),
                const SizedBox(height: 18),

                // Party Crew Stepper
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
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: TreatColors.secondaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.groups, color: TreatColors.secondary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Party Crew', style: TreatTypography.titleSmall),
                              Text("Who's joining the table?", style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(124, 82, 170, 0.08),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => state.decrementPartySize(),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: TreatColors.surfaceContainerHigh,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove, size: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${state.partySize}',
                                style: TreatTypography.titleMedium.copyWith(color: TreatColors.secondary),
                              ),
                            ),
                            InkWell(
                              onTap: () => state.incrementPartySize(),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: TreatColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Squad Budget Slider
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payments, size: 18, color: TreatColors.primary),
                              const SizedBox(width: 6),
                              Text('Total Squad Budget', style: TreatTypography.titleSmall),
                            ],
                          ),
                          Text(
                            '\$${state.budget.toInt()}',
                            style: TreatTypography.headlineSmall.copyWith(
                              color: TreatColors.secondary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: TreatColors.secondary,
                          inactiveTrackColor: TreatColors.outlineVariant,
                          thumbColor: TreatColors.primary,
                          overlayColor: TreatColors.primary.withValues(alpha: 0.15),
                          trackHeight: 6,
                        ),
                        child: Slider(
                          min: 30,
                          max: 400,
                          divisions: 74,
                          value: state.budget,
                          onChanged: (val) => state.setBudget(val),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Min: \$30', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: TreatColors.primaryFixed,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_activity, size: 12, color: TreatColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${state.perPersonBudget.toStringAsFixed(2)} / sweetie',
                                  style: TreatTypography.labelSmall.copyWith(
                                    color: TreatColors.onPrimaryFixedVariant,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('Max: \$400', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Food Category Craving Chips
                Text('FOOD CATEGORY CRAVING', style: TreatTypography.labelSmall.copyWith(fontSize: 10)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: state.categories.map((cat) {
                    final isSel = cat == state.selectedCategory;
                    return InkWell(
                      onTap: () => state.setCategory(cat),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? TreatColors.secondary : TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: isSel ? TreatColors.pillShadow : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(cat),
                              size: 14,
                              color: isSel ? Colors.white : TreatColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              cat,
                              style: TreatTypography.labelSmall.copyWith(
                                color: isSel ? Colors.white : TreatColors.onSurface,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Quick Toggles
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tax & Tip', style: TreatTypography.labelSmall.copyWith(fontSize: 11)),
                                Text('Add 18%', style: TreatTypography.bodySmall.copyWith(fontSize: 9)),
                              ],
                            ),
                            Switch(
                              value: state.includeTax,
                              onChanged: (val) => state.toggleIncludeTax(val),
                              activeThumbColor: TreatColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Walkable', style: TreatTypography.labelSmall.copyWith(fontSize: 11)),
                                Text('< 15 mins', style: TreatTypography.bodySmall.copyWith(fontSize: 9)),
                              ],
                            ),
                            Switch(
                              value: state.walkableOnly,
                              onChanged: (val) => state.toggleWalkableOnly(val),
                              activeThumbColor: TreatColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Matched Results Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasty Matches for Your Crew', style: TreatTypography.titleMedium),
                  Text('Found ${matches.length} feast platters within your budget', style: TreatTypography.bodySmall),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: TreatColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${matches.length} Matches',
                  style: TreatTypography.labelSmall.copyWith(
                    color: TreatColors.onTertiaryFixed,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Platter Match Cards
          ...matches.map((deal) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: TreatColors.candyShadow,
                border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.4)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        deal.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: 150, color: TreatColors.primaryFixed),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TreatColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            deal.badgeText,
                            style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '\$${deal.price.toStringAsFixed(2)}',
                            style: TreatTypography.headlineSmall.copyWith(
                              color: TreatColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(deal.title, style: TreatTypography.titleMedium),
                        const SizedBox(height: 2),
                        Text(deal.subtitle, style: TreatTypography.bodySmall),
                        const SizedBox(height: 12),
                        TreatButton(
                          text: 'View Platter Packages',
                          icon: Icons.fastfood,
                          height: 44,
                          variant: TreatButtonVariant.solidSecondary,
                          onPressed: () {
                            state.selectPlatter(deal);
                            onSelectDeal(deal);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Casual Dining':
        return Icons.restaurant;
      case 'Fast Treat':
        return Icons.bolt;
      case 'Fine Dining':
        return Icons.hotel_class;
      case 'All-You-Can-Eat':
        return Icons.all_inclusive;
      case 'Street Bites':
        return Icons.tapas;
      default:
        return Icons.fastfood;
    }
  }
}
