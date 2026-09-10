import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/platter_deal.dart';
import '../../state/budget_planner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_header.dart';

class PlatterPackagesScreen extends StatelessWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal platter) onSelectPlatter;
  final VoidCallback onEditBudget;

  const PlatterPackagesScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectPlatter,
    required this.onEditBudget,
  });

  @override
  Widget build(BuildContext context) {
    final plannerState = context.watch<BudgetPlannerState>();
    final platters = PlatterDeal.sampleDeals;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: onOpenDrawer,
        actionLabel: 'Filter',
        actionIcon: Icons.tune,
        onActionTap: onEditBudget,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 36),
        children: [
          // Filter Review Capsule
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TreatColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: TreatColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, color: TreatColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Budget: \$${plannerState.budget.toInt()}', style: TreatTypography.labelSmall),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text('•', style: TextStyle(color: TreatColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          Text('${plannerState.partySize} Guests', style: TreatTypography.bodySmall),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text('•', style: TextStyle(color: TreatColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          Text(plannerState.selectedCategory, style: TreatTypography.bodySmall),
                        ],
                      ),
                      Text(
                        'Tax Included & Service Matched • \$${(plannerState.budget / plannerState.partySize).toStringAsFixed(0)}/person',
                        style: TreatTypography.bodySmall.copyWith(color: TreatColors.secondary, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                TreatButton(
                  text: 'Edit',
                  height: 32,
                  width: 64,
                  variant: TreatButtonVariant.softSecondary,
                  onPressed: onEditBudget,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Header Title Box
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platter Packages', style: TreatTypography.headlineSmall),
                  Text('Community feasts ready for instant reserve', style: TreatTypography.bodySmall),
                ],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: TreatColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.celebration, color: TreatColors.secondary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Squad Savings Mini Meter
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TreatColors.secondaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.savings, color: TreatColors.secondary, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Squad Allocation: \$${plannerState.budget.toStringAsFixed(2)}',
                          style: TreatTypography.labelSmall.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'All platters leave ample budget for drinks & dessert!',
                          style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${platters.length} Matched',
                    style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Platters Feed Cards
          ...platters.map((platter) {
            final perPerson = platter.perPersonCost(plannerState.partySize);

            return Container(
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: TreatColors.candyShadow,
                border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top badge
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
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
                              const Icon(Icons.verified, size: 13, color: TreatColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                platter.badgeText,
                                style: TreatTypography.labelSmall.copyWith(
                                  color: TreatColors.onPrimaryFixedVariant,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border, size: 20, color: TreatColors.primary),
                      ],
                    ),
                  ),

                  // Image banner
                  Stack(
                    children: [
                      Image.network(
                        platter.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: 150, color: TreatColors.primaryFixed),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.storefront, size: 12, color: TreatColors.primaryFixed),
                              const SizedBox(width: 4),
                              Text(
                                '${platter.restaurantName} (#${platter.restaurantCode})',
                                style: TreatTypography.bodySmall.copyWith(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(platter.title, style: TreatTypography.titleMedium),
                                Text(
                                  'Serves ${platter.servesCountMin}-${platter.servesCountMax} Foodies (\$${perPerson.toStringAsFixed(2)} / person)',
                                  style: TreatTypography.bodySmall.copyWith(color: TreatColors.secondary),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$${platter.originalPrice.toStringAsFixed(2)}',
                                      style: TreatTypography.bodySmall.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '\$${platter.price.toStringAsFixed(2)}',
                                      style: TreatTypography.headlineSmall.copyWith(
                                        color: TreatColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Save \$${platter.savings.toStringAsFixed(0)} today',
                                  style: TreatTypography.labelSmall.copyWith(
                                    color: TreatColors.secondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Package Inclusions
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TreatColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PACKAGE INCLUSIONS',
                                style: TreatTypography.labelSmall.copyWith(
                                  color: TreatColors.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 10,
                                runSpacing: 6,
                                children: platter.inclusions.map((inc) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle, size: 13, color: TreatColors.tertiary),
                                      const SizedBox(width: 4),
                                      Text(inc, style: TreatTypography.bodySmall),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Select button
                        TreatButton(
                          text: 'Select This Platter',
                          icon: Icons.arrow_forward,
                          height: 48,
                          variant: TreatButtonVariant.solidSecondary,
                          onPressed: () {
                            plannerState.selectPlatter(platter);
                            onSelectPlatter(platter);
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
}
