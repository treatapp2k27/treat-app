import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/table_info.dart';
import '../../state/kitchen_partner_state.dart';
import '../../widgets/treat_card.dart';

class FloorTableAvailabilityScreen extends StatelessWidget {
  final VoidCallback onBack;

  const FloorTableAvailabilityScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<KitchenPartnerState>();
    final tables = state.filteredTables;
    final areas = ['All', 'Main Hall', 'Outdoor Patio', 'Bar Counter'];

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text('Floor & Table Manager', style: TreatTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Capacity Summary Card
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: TreatColors.secondaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.table_restaurant, color: TreatColors.secondary, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Table Capacity Live', style: TreatTypography.titleSmall),
                        Text(
                          '${state.availableTablesCount} of ${state.tables.length} tables open for hold',
                          style: TreatTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
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
                    '${((state.availableTablesCount / state.tables.length) * 100).toInt()}% FREE',
                    style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Area Filter Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: areas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final area = areas[index];
                final isSel = area == state.selectedArea;
                return InkWell(
                  onTap: () => state.setAreaFilter(area),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? TreatColors.secondary : TreatColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      area,
                      style: TreatTypography.labelSmall.copyWith(
                        color: isSel ? Colors.white : TreatColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tables Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.35,
            ),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final t = tables[index];
              return _buildTableCard(context, t, state);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, TableInfo t, KitchenPartnerState state) {
    Color statusColor;
    Color statusBg;
    String statusLabel;

    switch (t.status) {
      case TableStatus.free:
        statusColor = TreatColors.success;
        statusBg = TreatColors.successContainer;
        statusLabel = 'Free';
        break;
      case TableStatus.dining:
        statusColor = TreatColors.warning;
        statusBg = TreatColors.warningContainer;
        statusLabel = 'Dining';
        break;
      case TableStatus.reserved:
        statusColor = TreatColors.primary;
        statusBg = TreatColors.primaryFixed;
        statusLabel = 'Reserved';
        break;
      case TableStatus.cleaning:
        statusColor = TreatColors.onSurfaceVariant;
        statusBg = TreatColors.surfaceContainerHigh;
        statusLabel = 'Cleaning';
        break;
    }

    return InkWell(
      onTap: () => _showStatusPicker(context, t, state),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TreatColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: t.status == TableStatus.reserved
                ? TreatColors.primary.withValues(alpha: 0.4)
                : TreatColors.outlineVariant.withValues(alpha: 0.4),
            width: t.status == TableStatus.reserved ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 82, 170, 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.name, style: TreatTypography.titleSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: TreatTypography.labelSmall.copyWith(color: statusColor, fontSize: 9),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.people_alt_outlined, size: 14, color: TreatColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${t.capacity} seats', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                const SizedBox(width: 6),
                Text('•', style: TextStyle(color: TreatColors.outlineVariant)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.area,
                    style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (t.activeReservationCode != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TreatColors.primaryFixed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  t.activeReservationCode!,
                  style: TreatTypography.ticketCode.copyWith(fontSize: 10, color: TreatColors.primary),
                ),
              ),
            ] else ...[
              Text('Tap to toggle status', style: TreatTypography.bodySmall.copyWith(fontSize: 9, color: TreatColors.outline)),
            ],
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(BuildContext context, TableInfo t, KitchenPartnerState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TreatColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set Status for ${t.name}', style: TreatTypography.titleMedium),
                const SizedBox(height: 14),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: TreatColors.success),
                  title: const Text('Free (Available for Hold)'),
                  onTap: () {
                    state.setTableStatus(t.id, TableStatus.free);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant, color: TreatColors.warning),
                  title: const Text('Dining (Currently Seated)'),
                  onTap: () {
                    state.setTableStatus(t.id, TableStatus.dining);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark, color: TreatColors.primary),
                  title: const Text('Reserved (Treat Hold Active)'),
                  onTap: () {
                    state.setTableStatus(t.id, TableStatus.reserved);
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cleaning_services, color: TreatColors.outline),
                  title: const Text('Cleaning (Bussing Table)'),
                  onTap: () {
                    state.setTableStatus(t.id, TableStatus.cleaning);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
