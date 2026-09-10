import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/reservation.dart';
import '../../state/kitchen_partner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';

class KitchenDashboardScreen extends StatelessWidget {
  final VoidCallback onOpenFloorManager;
  final VoidCallback onOpenSettings;
  final VoidCallback onLogOut;

  const KitchenDashboardScreen({
    super.key,
    required this.onOpenFloorManager,
    required this.onOpenSettings,
    required this.onLogOut,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<KitchenPartnerState>();
    final partner = state.partner;
    final pending = state.pendingReservations;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text('treat', style: TreatTypography.headlineLarge.copyWith(color: TreatColors.primary)),
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(left: 2, top: 12),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: TreatColors.tertiary),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: TreatColors.primaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'PARTNER',
                style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 9),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: TreatColors.successContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: TreatColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Accepting',
                  style: TreatTypography.labelSmall.copyWith(color: TreatColors.success, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: onOpenSettings,
          ),
          IconButton(
            icon: const Icon(Icons.table_restaurant_outlined),
            onPressed: onOpenFloorManager,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Partner Identity & Live Table Capacity Hero Strip
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                            color: TreatColors.primaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.soup_kitchen, color: TreatColors.primary, size: 24),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(partner.venueName, style: TreatTypography.titleSmall),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: TreatColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '#${partner.merchantCode}',
                                    style: TreatTypography.labelSmall.copyWith(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                            Text('★ 4.9 • Verified Chef Studio', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TreatColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: TreatColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Kitchen Live',
                            style: TreatTypography.labelSmall.copyWith(color: TreatColors.success, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Master Toggle Switch
                Container(
                  padding: const EdgeInsets.all(12),
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
                          Row(
                            children: [
                              Text('Accepting Treat Bookings', style: TreatTypography.labelMedium),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: TreatColors.tertiaryFixed,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('LIVE PULSE', style: TreatTypography.labelSmall.copyWith(fontSize: 8)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.table_restaurant, size: 14, color: TreatColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                'Instant Capacity: ${state.availableTablesCount} Free Tables',
                                style: TreatTypography.bodySmall.copyWith(
                                  color: TreatColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: partner.isAcceptingBookings,
                        onChanged: (val) => state.toggleAcceptingBookings(val),
                        activeThumbColor: TreatColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Key Metrics Bar
          Row(
            children: [
              Expanded(
                child: _metricPill(
                  Icons.celebration,
                  '${partner.reservationsToday}',
                  'Reservations Today',
                  TreatColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricPill(
                  Icons.hourglass_top,
                  '${pending.length}',
                  'Pending Action',
                  TreatColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metricPill(
                  Icons.attach_money,
                  '\$${partner.treatSalesToday.toInt()}',
                  'Treat Sales',
                  TreatColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Urgent Action Section: Incoming Reservations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.notification_important, color: TreatColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text('Incoming Treat Reservations', style: TreatTypography.titleMedium),
                ],
              ),
              if (pending.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TreatColors.secondary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'ACTION REQUIRED',
                    style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (pending.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline, size: 40, color: TreatColors.success),
                  const SizedBox(height: 8),
                  Text('All Clear on the Line!', style: TreatTypography.titleSmall),
                  Text('No pending booking inquiries awaiting decision.', style: TreatTypography.bodySmall),
                ],
              ),
            ),
          ] else ...[
            ...pending.map((res) => _buildIncomingReservationCard(res, state)),
          ],

          const SizedBox(height: 20),

          // Quick Navigation Actions
          Row(
            children: [
              Expanded(
                child: TreatButton(
                  text: 'Floor & Tables',
                  icon: Icons.table_chart_outlined,
                  height: 46,
                  variant: TreatButtonVariant.softSecondary,
                  onPressed: onOpenFloorManager,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TreatButton(
                  text: 'Kitchen Pacing',
                  icon: Icons.tune,
                  height: 46,
                  variant: TreatButtonVariant.softSecondary,
                  onPressed: onOpenSettings,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _metricPill(IconData icon, String value, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 4),
              Text(
                value,
                style: TreatTypography.headlineSmall.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TreatTypography.bodySmall.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingReservationCard(Reservation res, KitchenPartnerState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TreatColors.primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: TreatColors.candyShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: TreatColors.secondaryContainer,
                    child: Text('MD', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${res.dinerHandle} (${res.partySize} guests)',
                        style: TreatTypography.titleSmall,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.alarm, size: 12, color: TreatColors.tertiary),
                          const SizedBox(width: 4),
                          Text(res.timeSlot, style: TreatTypography.bodySmall.copyWith(fontSize: 11, color: TreatColors.tertiary)),
                        ],
                      ),
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
                child: Text('Table Prep', style: TreatTypography.labelSmall.copyWith(fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Requested Package Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TreatColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fastfood, size: 16, color: TreatColors.primary),
                        const SizedBox(width: 6),
                        Text(res.platter.title, style: TreatTypography.labelSmall.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Text('\$${res.platter.price.toStringAsFixed(2)}', style: TreatTypography.labelMedium.copyWith(color: TreatColors.secondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(res.platter.subtitle, style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.deck, size: 14, color: TreatColors.secondary),
                      const SizedBox(width: 6),
                      Text('"${res.seatingPreference}"', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 1-Tap Action Confirmation Buttons
          Row(
            children: [
              Expanded(
                child: TreatButton(
                  text: '✓ Confirm (Yes)',
                  height: 44,
                  variant: TreatButtonVariant.pinkGradient,
                  onPressed: () {
                    state.confirmReservation(res.id);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TreatButton(
                  text: '✕ Decline',
                  height: 44,
                  variant: TreatButtonVariant.softSecondary,
                  onPressed: () {
                    state.declineReservation(res.id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
