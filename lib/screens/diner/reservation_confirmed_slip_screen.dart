import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../state/booking_state.dart';
import '../../widgets/stylized_qr_stub.dart';
import '../../widgets/tear_away_ticket.dart';
import '../../widgets/treat_button.dart';
import '../../widgets/treat_header.dart';

class ReservationConfirmedSlipScreen extends StatelessWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback onViewReceipt;
  final VoidCallback onDone;

  const ReservationConfirmedSlipScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onViewReceipt,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final bookingState = context.watch<BookingState>();
    final res = bookingState.currentReservation;

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: onOpenDrawer,
        actionLabel: 'Receipt',
        actionIcon: Icons.receipt_long,
        onActionTap: onViewReceipt,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Celebration Hero
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: TreatColors.secondary,
                        shape: BoxShape.circle,
                        boxShadow: TreatColors.pillShadow,
                      ),
                      child: const Icon(Icons.check_circle, color: Colors.white, size: 36),
                    ),
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: TreatColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '1m 14s!',
                          style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: TreatColors.primaryFixed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 14, color: TreatColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'CONFIRMED BY RESTAURANT!',
                        style: TreatTypography.labelSmall.copyWith(
                          color: TreatColors.onPrimaryFixedVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("You're Set to Sizzle!", style: TreatTypography.headlineMedium.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(
                  'Table is held & kitchen is prepping your platter for Party of ${res.partySize}',
                  textAlign: TextAlign.center,
                  style: TreatTypography.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Digital Reservation Boarding Pass Slip
          Container(
            decoration: BoxDecoration(
              color: TreatColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              boxShadow: TreatColors.candyShadow,
            ),
            child: Column(
              children: [
                // Top Color Gradient Stripe
                Container(
                  height: 8,
                  decoration: const BoxDecoration(
                    gradient: TreatColors.brandGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),

                // Main Ticket Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: TreatColors.secondaryFixed,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'Patio VIP',
                                      style: TreatTypography.labelSmall.copyWith(fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '#${res.restaurant.code}',
                                    style: TreatTypography.labelSmall.copyWith(
                                      color: TreatColors.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(res.restaurant.name, style: TreatTypography.titleMedium),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: TreatColors.tertiary),
                                  const SizedBox(width: 4),
                                  Text(res.restaurant.address, style: TreatTypography.bodySmall.copyWith(fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions, size: 18, color: TreatColors.tertiary),
                                Text('Go', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: TreatColors.tertiary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Reserved Table & Time Slot Grid
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: TreatColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('RESERVED TABLE', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSurfaceVariant, fontSize: 9)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.deck, size: 16, color: TreatColors.primary),
                                      const SizedBox(width: 4),
                                      Text(res.tableAssigned, style: TreatTypography.titleSmall.copyWith(color: TreatColors.primary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: TreatColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('TIME SLOT', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSurfaceVariant, fontSize: 9)),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 16, color: TreatColors.secondary),
                                      const SizedBox(width: 4),
                                      Text('08:30 PM', style: TreatTypography.titleSmall),
                                    ],
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

                // Perforated Divider
                const PerforatedDivider(),

                // Mid Ticket: Pass Details, ID, QR Stub
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Reservation ID with Copy
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RESERVATION ID', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSurfaceVariant, fontSize: 8)),
                                Text(
                                  res.code,
                                  style: TreatTypography.ticketCode.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: res.code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reservation Code copied!'), duration: Duration(seconds: 1)),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.copy, size: 13, color: TreatColors.secondary),
                                    const SizedBox(width: 4),
                                    Text('Copy', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Grace period notice
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: TreatColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text('Hold Active: Until 08:45 PM', style: TreatTypography.bodySmall),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: TreatColors.secondaryFixed,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '15m Grace',
                              style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Stylized Vector QR Code Stub
                      const StylizedQrStub(size: 140),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: TreatColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Show to Host or Server at Door',
                          style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Manual Entry PIN
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: TreatColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MANUAL ENTRY PIN', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSurfaceVariant, fontSize: 9)),
                                Text('Use if scanner is busy', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: TreatColors.primaryFixed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                res.manualPin,
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Bottom Action Buttons
          TreatButton(
            text: 'View Scanned Voucher Receipt',
            icon: Icons.receipt_long,
            variant: TreatButtonVariant.pinkGradient,
            onPressed: onViewReceipt,
          ),
          const SizedBox(height: 10),
          TreatButton(
            text: 'Back to Home Deals',
            icon: Icons.home,
            variant: TreatButtonVariant.softSecondary,
            onPressed: onDone,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
