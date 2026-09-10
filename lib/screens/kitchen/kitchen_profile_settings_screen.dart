import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/kitchen_partner.dart';
import '../../state/kitchen_partner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';

class KitchenProfileSettingsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onLogOut;

  const KitchenProfileSettingsScreen({
    super.key,
    required this.onBack,
    required this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<KitchenPartnerState>();
    final partner = state.partner;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text('Kitchen Operations & Pacing', style: TreatTypography.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Venue Identity Card
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
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.storefront, color: TreatColors.secondary, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(partner.venueName, style: TreatTypography.titleSmall),
                            Text('MID: #${partner.merchantCode} • King St West', style: TreatTypography.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: TreatColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('LIVE PORTAL', style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Active Terminal Station
                Text('ACTIVE TERMINAL UNIT', style: TreatTypography.labelSmall.copyWith(fontSize: 9)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _stationPill('KDS #1 (Hot Line)', Icons.outdoor_grill, TerminalStation.mainKds, state),
                    _stationPill('Host Stand', Icons.table_restaurant, TerminalStation.hostStand, state),
                    _stationPill('Bar Terminal', Icons.local_bar, TerminalStation.barTerminal, state),
                    _stationPill('Floor Lead', Icons.badge_outlined, TerminalStation.floorLeadTablet, state),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pacing & Capacity Control
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KITCHEN PACING & RUSH MODE', style: TreatTypography.labelSmall.copyWith(fontSize: 10)),
                const SizedBox(height: 10),

                // Kitchen Rush Mode Switch
                Container(
                  padding: const EdgeInsets.all(12),
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
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: TreatColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bolt, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kitchen Rush Mode', style: TreatTypography.titleSmall),
                              Text('Adds +10m to diner pickup estimates', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: partner.rushMode,
                        onChanged: (val) => state.toggleRushMode(val),
                        activeThumbColor: TreatColors.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Auto-accept Platter Bundles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto-accept Platter Bundles', style: TreatTypography.titleSmall),
                        Text('Instantly confirm prep slots for pre-paid platters', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                      ],
                    ),
                    Switch(
                      value: partner.autoAcceptBundles,
                      onChanged: (val) => state.toggleAutoAccept(val),
                      activeThumbColor: TreatColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Table Hold Grace Window
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Table Hold Grace Window', style: TreatTypography.titleSmall),
                    Text('${partner.graceWindowMins} Mins', style: TreatTypography.labelMedium.copyWith(color: TreatColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [10, 15, 20, 30].map((mins) {
                    final isSel = partner.graceWindowMins == mins;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => state.setGraceWindow(mins),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? TreatColors.primary : TreatColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${mins}m',
                              style: TreatTypography.labelSmall.copyWith(
                                color: isSel ? Colors.white : TreatColors.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Log Out / Exit Terminal
          TreatButton(
            text: 'Exit Terminal to Diner View',
            icon: Icons.logout,
            variant: TreatButtonVariant.softSecondary,
            onPressed: onLogOut,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _stationPill(String name, IconData icon, TerminalStation station, KitchenPartnerState state) {
    final isSel = state.partner.activeStation == station;
    return InkWell(
      onTap: () => state.setStation(station),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? TreatColors.secondary : TreatColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSel ? Colors.white : TreatColors.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              name,
              style: TreatTypography.labelSmall.copyWith(
                color: isSel ? Colors.white : TreatColors.onSurface,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
