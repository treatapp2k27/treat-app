import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/favorite_item.dart';
import '../../models/platter_deal.dart';
import '../../state/budget_planner_state.dart';
import '../../state/diner_state.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

class ChooseTreatBudgetScreen extends StatelessWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal) onSelectDeal;
  final VoidCallback? onBackToFoodBar;
  final VoidCallback? onFindWithinBudget;
  final VoidCallback? onOpenFilters;

  const ChooseTreatBudgetScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectDeal,
    this.onBackToFoodBar,
    this.onFindWithinBudget,
    this.onOpenFilters,
  });

  void _showFilterSheet(BuildContext context, BudgetPlannerState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: TreatColors.secondaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.tune, color: TreatColors.secondary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Smart Filters',
                              style: TreatTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            state.setBudget(15000.0);
                            state.toggleWalkableOnly(false);
                            state.toggleIncludeTax(true);
                            setModalState(() {});
                            Navigator.of(modalCtx).pop();
                          },
                          child: const Text('Reset All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Squad Budget',
                          style: TreatTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '৳${state.budget.toInt()}',
                            style: TreatTypography.labelSmall.copyWith(
                              color: TreatColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: TreatColors.secondary,
                        inactiveTrackColor: TreatColors.surfaceContainerHighest,
                        thumbColor: TreatColors.secondary,
                      ),
                      child: Slider(
                        value: state.budget.clamp(500.0, 30000.0),
                        min: 500.0,
                        max: 30000.0,
                        divisions: 59,
                        onChanged: (val) {
                          state.setBudget(val);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Min: ৳500', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                        Text('Max: ৳30000', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Party Size (${state.partySize} guests)', style: TreatTypography.labelMedium),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: state.partySize > 1
                                  ? () {
                                      state.decrementPartySize();
                                      setModalState(() {});
                                    }
                                  : null,
                            ),
                            Text('${state.partySize}', style: TreatTypography.titleSmall),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: state.partySize < 12
                                  ? () {
                                      state.incrementPartySize();
                                      setModalState(() {});
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Walkable Only (< 15 mins)'),
                      value: state.walkableOnly,
                      activeColor: TreatColors.secondary,
                      onChanged: (v) {
                        state.toggleWalkableOnly(v);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TreatColors.secondary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.of(modalCtx).pop(),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontWeight: FontWeight.w800),
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

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BudgetPlannerState>();
    final matches = state.matchedPlatters;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: onOpenDrawer,
        actionLabel: 'Filters',
        actionIcon: Icons.tune,
        onActionTap: onOpenFilters ?? () => _showFilterSheet(context, state),
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
                  'Set your sweet spot & feast like royalty without the wallet shock!',
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
                      Expanded(
                        child: Row(
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Party Crew', style: TreatTypography.titleSmall),
                                  Text("Who's joining the table?", style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.payments, size: 18, color: TreatColors.primary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Squad Budget',
                                        style: TreatTypography.titleSmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Adjust up to ৳30000',
                                        style: TreatTypography.bodySmall.copyWith(
                                          fontSize: 10,
                                          color: TreatColors.onSurfaceVariant.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '৳${state.budget.toInt()}',
                            style: TreatTypography.headlineSmall.copyWith(
                              color: TreatColors.secondary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: TreatColors.secondary,
                          inactiveTrackColor: TreatColors.outlineVariant,
                          thumbColor: TreatColors.primary,
                          overlayColor: TreatColors.primary.withValues(alpha: 0.15),
                          trackHeight: 6,
                        ),
                        child: Slider(
                          min: 500,
                          max: 30000,
                          divisions: 59,
                          value: state.budget.clamp(500.0, 30000.0),
                          onChanged: (val) => state.setBudget(val),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Min: ৳500', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: TreatColors.primaryFixed,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.credit_card, size: 12, color: TreatColors.primary),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '৳${state.perPersonBudget.toStringAsFixed(0)} / sweetie',
                                      style: TreatTypography.labelSmall.copyWith(
                                        color: TreatColors.onPrimaryFixedVariant,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text('Max: ৳30000', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
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
                          color: isSel ? const Color(0xFFD6228A) : TreatColors.surfaceContainerLow,
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
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Quick Checkbox Toggles
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => state.toggleIncludeTax(!state.includeTax),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                    Text(
                                      'Tax & Service',
                                      style: TreatTypography.labelSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Include extra 18%',
                                      style: TreatTypography.bodySmall.copyWith(
                                        color: TreatColors.onSurfaceVariant.withValues(alpha: 0.7),
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: state.includeTax ? TreatColors.secondary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: state.includeTax ? TreatColors.secondary : TreatColors.outlineVariant,
                                    width: 1.5,
                                  ),
                                ),
                                child: state.includeTax
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => state.toggleWalkableOnly(!state.walkableOnly),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                    Text(
                                      'Walkable Only',
                                      style: TreatTypography.labelSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '< 15 mins away',
                                      style: TreatTypography.bodySmall.copyWith(
                                        color: TreatColors.onSurfaceVariant.withValues(alpha: 0.7),
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: state.walkableOnly ? TreatColors.secondary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: state.walkableOnly ? TreatColors.secondary : TreatColors.outlineVariant,
                                    width: 1.5,
                                  ),
                                ),
                                child: state.walkableOnly
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Find It Within Budget Button
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C52AA), Color(0xFF673AB7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(124, 82, 170, 0.35),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onFindWithinBudget?.call();
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.diamond_outlined, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'FIND IT WITHIN BUDGET',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Matched Results Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tasty Matches for Your Crew', style: TreatTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                    Text(
                      'Found ${matches.length} feast spots within your exact budget',
                      style: TreatTypography.bodySmall.copyWith(
                        color: TreatColors.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${matches.length} Spots',
                  style: TreatTypography.labelSmall.copyWith(
                    color: const Color(0xFF0284C7),
                    fontWeight: FontWeight.w800,
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
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.08),
                    blurRadius: 18,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.35)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        deal.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          color: TreatColors.primaryFixed,
                          child: const Center(
                            child: Icon(Icons.restaurant, size: 40, color: TreatColors.secondary),
                          ),
                        ),
                      ),
                      // Walk distance & time overlay
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_walk, size: 14, color: Color(0xFF67E8F9)),
                              const SizedBox(width: 4),
                              Text(
                                deal.walkTime,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Rating & review count overlay
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 13, color: Color(0xFFFBBF24)),
                              const SizedBox(width: 4),
                              Text(
                                '${deal.rating.toStringAsFixed(1)} (${deal.reviewsCount})',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                deal.restaurantName.isNotEmpty ? deal.restaurantName : deal.title,
                                style: TreatTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '৳${deal.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD6228A),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  deal.perPersonText ?? '৳${(deal.price / state.partySize).toStringAsFixed(0)}/person',
                                  style: TreatTypography.bodySmall.copyWith(
                                    color: TreatColors.onSurfaceVariant.withValues(alpha: 0.7),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deal.subtitle,
                          style: TreatTypography.bodySmall.copyWith(
                            color: TreatColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            // Save & Pass button
                            Expanded(
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      state.selectPlatter(deal);
                                      onSelectDeal(deal);
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    child: Center(
                                      child: Text(
                                        deal.saveText ?? 'Save ৳28 • Pass',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF7C52AA),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Loved It ♡ button
                            Expanded(
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD6228A),
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(214, 34, 138, 0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Builder(
                                    builder: (context) {
                                      final isLoved = context.watch<DinerState>().isFavorite(deal.id);
                                      return InkWell(
                                        onTap: () {
                                          final added = context.read<DinerState>().toggleFavorite(FavoriteItem.fromPlatterDeal(deal));
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    added ? Icons.favorite : Icons.favorite_border,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      added ? 'Added to your Loved Favorites! ❤️' : 'Removed from Favorites',
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
                                        },
                                        borderRadius: BorderRadius.circular(999),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Loved It',
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                isLoved ? Icons.favorite : Icons.favorite_border,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
