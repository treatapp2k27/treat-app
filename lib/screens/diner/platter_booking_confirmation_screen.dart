import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../models/reservation.dart';
import '../../state/booking_state.dart';
import '../../state/budget_planner_state.dart';
import '../../state/diner_state.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

class PlatterBookingConfirmationScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback onConfirmed;
  final VoidCallback onBack;

  const PlatterBookingConfirmationScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onConfirmed,
    required this.onBack,
  });

  @override
  State<PlatterBookingConfirmationScreen> createState() => _PlatterBookingConfirmationScreenState();
}

class _PlatterBookingConfirmationScreenState extends State<PlatterBookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingState = context.watch<BookingState>();
    final plannerState = context.watch<BudgetPlannerState>();
    final dinerState = context.watch<DinerState>();
    final platter = plannerState.selectedPlatter;
    final reservation = bookingState.currentReservation;

    // If reservation becomes confirmed, notify user
    if (reservation.status == ReservationStatus.confirmed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onConfirmed();
      });
    }

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Help',
        actionIcon: Icons.help_outline,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Step 2 Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: TreatColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STEP 2 OF 3 • REAL-TIME HOLD',
                    style: TreatTypography.labelSmall.copyWith(
                      color: TreatColors.secondary,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
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
                  'Ref: ${reservation.code}',
                  style: TreatTypography.labelSmall.copyWith(
                    color: TreatColors.onPrimaryFixedVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Selected Platter Summary Card
          TreatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.storefront, color: TreatColors.secondary, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(platter.restaurantName, style: TreatTypography.titleSmall),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: TreatColors.secondaryFixed,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '#${platter.restaurantCode}',
                                    style: TreatTypography.labelSmall.copyWith(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                            Text('Boutique Kitchen & Taproom', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bookingState.isInquiring ? TreatColors.errorContainer : TreatColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: bookingState.isInquiring ? TreatColors.error : TreatColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bookingState.isInquiring ? 'Awaiting Kitchen' : 'Ready to Check',
                            style: TreatTypography.labelSmall.copyWith(
                              color: bookingState.isInquiring ? TreatColors.error : TreatColors.onPrimaryFixedVariant,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Visual Platter feature
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        platter.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: 150, color: TreatColors.primaryFixed),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: TreatColors.tertiary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'FEATURED SPECIAL',
                                  style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                platter.title,
                                style: TreatTypography.titleMedium.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '\$${platter.price.toStringAsFixed(2)}',
                              style: TreatTypography.titleMedium.copyWith(
                                color: TreatColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Booking details meta
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildMetaRow(Icons.schedule, 'Slot', 'Today, 08:30 PM (in 25 mins)', isHighlight: true),
                      const Divider(height: 14, color: TreatColors.outlineVariant),
                      _buildMetaRow(Icons.person_outline, 'Party Size', '${plannerState.partySize} Guests'),
                      const Divider(height: 14, color: TreatColors.outlineVariant),
                      _buildMetaRow(Icons.deck_outlined, 'Seating', 'Patio Area Requested', isBadge: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Actions
          if (!bookingState.isInquiring) ...[
            TreatButton(
              text: 'Is it available?',
              icon: Icons.chat_bubble_outline,
              trailing: const Icon(Icons.bolt, size: 20, color: Colors.white),
              variant: TreatButtonVariant.solidSecondary,
              onPressed: () {
                bookingState.startInquiry(
                  platter: platter,
                  partySize: plannerState.partySize,
                  seatingPreference: 'Outdoor patio table requested',
                  dinerHandle: dinerState.currentPersona.handle,
                );
              },
            ),
            const SizedBox(height: 10),
            TreatButton(
              text: 'Choose Another Option',
              icon: Icons.arrow_back,
              variant: TreatButtonVariant.softSecondary,
              onPressed: widget.onBack,
            ),
          ] else ...[
            // Status & 2-Minute Timer Tracker Card
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
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: TreatColors.tertiaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.sensors, size: 16, color: TreatColors.onTertiaryFixed),
                          ),
                          const SizedBox(width: 8),
                          Text('Live Kitchen Sync', style: TreatTypography.labelMedium),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TreatColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: TreatColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('Active Signal', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Notification description
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TreatColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.outdoor_grill, size: 20, color: TreatColors.secondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Inquiry Sent to Kitchen Partner #${platter.restaurantCode}',
                                style: TreatTypography.labelSmall.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Line cook queue notified for "${platter.title}" slot hold.',
                                style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Countdown & Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.hourglass_top, size: 16, color: TreatColors.secondary),
                          const SizedBox(width: 4),
                          Text('Kitchen Response Timer', style: TreatTypography.labelSmall),
                        ],
                      ),
                      Text(
                        '${bookingState.formattedTimer} • Line Priority',
                        style: TreatTypography.labelMedium.copyWith(
                          color: TreatColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: bookingState.timerProgress,
                      backgroundColor: TreatColors.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation<Color>(TreatColors.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kitchen partners usually respond in under 2 minutes. Direct phone activates below.',
                    style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 14),

                  // Demo simulation button: Instant kitchen confirmation
                  TreatButton(
                    text: '⚡ Instant Confirm (Demo Simulation)',
                    height: 42,
                    variant: TreatButtonVariant.pinkGradient,
                    onPressed: () {
                      bookingState.simulateInstantConfirm();
                    },
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value, {bool isHighlight = false, bool isBadge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: TreatColors.secondary),
            const SizedBox(width: 6),
            Text(label, style: TreatTypography.bodySmall),
          ],
        ),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TreatColors.tertiaryFixed,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              value,
              style: TreatTypography.labelSmall.copyWith(
                color: TreatColors.onTertiaryFixedVariant,
                fontSize: 10,
              ),
            ),
          )
        else
          Text(
            value,
            style: TreatTypography.labelSmall.copyWith(
              color: isHighlight ? TreatColors.primary : TreatColors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}
