import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../state/booking_state.dart';
import '../../widgets/tear_away_ticket.dart';
import '../../widgets/treat_button.dart';

class ScannedVoucherReceiptScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onHome;

  const ScannedVoucherReceiptScreen({
    super.key,
    required this.onBack,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final bookingState = context.watch<BookingState>();
    final res = bookingState.currentReservation;

    return Scaffold(
      backgroundColor: TreatColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Top Navigation & Live Status Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TreatColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'LIVE REDEMPTION',
                      style: TreatTypography.labelSmall.copyWith(
                        color: TreatColors.secondary,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text('Voucher Receipt', style: TreatTypography.titleMedium),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: res.voucherCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voucher Serial Copied!'), duration: Duration(seconds: 1)),
                    );
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TreatColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.copy, size: 18, color: TreatColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Live Verified Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.08),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
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
                      const SizedBox(width: 8),
                      Text(
                        'VERIFIED & READY TO SERVE',
                        style: TreatTypography.labelSmall.copyWith(fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: TreatColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '8:32 PM • Stand #01',
                      style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Receipt Body Container
            Container(
              decoration: BoxDecoration(
                color: TreatColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: TreatColors.candyShadow,
              ),
              child: Column(
                children: [
                  // Merchant Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: TreatColors.primaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.ramen_dining, color: TreatColors.primary, size: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(res.restaurant.name, style: TreatTypography.headlineSmall),
                        Text('${res.restaurant.address} • Patio Stand', style: TreatTypography.bodySmall),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('MID: #${res.restaurant.code}', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10)),
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(color: TreatColors.outlineVariant)),
                            const SizedBox(width: 6),
                            Text('TERM #02', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10)),
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(color: TreatColors.outlineVariant)),
                            const SizedBox(width: 6),
                            Text(res.restaurant.phone, style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: TreatColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, size: 14, color: TreatColors.onTertiaryFixed),
                              const SizedBox(width: 4),
                              Text(
                                'TREAT AUTHORIZED VOUCHER',
                                style: TreatTypography.labelSmall.copyWith(
                                  color: TreatColors.onTertiaryFixed,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Perforated Separation
                  const PerforatedDivider(),

                  // Reservation & Diner Overview
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildReceiptRow('Voucher Serial', res.voucherCode, isCode: true),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Guest Diner', res.dinerHandle, badge: 'VIP'),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Party Seating', '${res.tableAssigned} (${res.partySize} Guests)'),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Redemption Window', '08:30 PM (Grace till 09:15)'),
                      ],
                    ),
                  ),

                  const Divider(color: TreatColors.outlineVariant, height: 1),

                  // Itemized Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ITEMIZED SERVICE DETAILS', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10)),
                            Text('Qty: 1 Platter', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Item 1
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TreatColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${res.platter.title} Special', style: TreatTypography.titleSmall),
                                    Text(
                                      res.platter.subtitle,
                                      style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('৳${res.platter.price.toStringAsFixed(2)}', style: TreatTypography.titleSmall),
                                  Text(
                                    '৳${res.platter.originalPrice.toStringAsFixed(2)}',
                                    style: TreatTypography.bodySmall.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Gratuity
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Host Service Gratuity & Match', style: TreatTypography.bodySmall),
                            Text('৳${res.gratuity.toStringAsFixed(2)}', style: TreatTypography.labelSmall),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal & Taxes', style: TreatTypography.bodySmall),
                            Text('৳${res.totalWithGratuity.toStringAsFixed(2)}', style: TreatTypography.labelSmall),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Source', style: TreatTypography.bodySmall),
                            Text('Treat In-App Wallet', style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Auth Code', style: TreatTypography.bodySmall),
                            Text('TRT-AUTH-99214X', style: TreatTypography.ticketCode.copyWith(fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Highlight Balance: ৳0.00
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: TreatColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('AMOUNT DUE AT TABLE', style: TreatTypography.labelSmall.copyWith(color: TreatColors.onSecondaryFixedVariant, fontSize: 10)),
                                  Text('Final table balance', style: TreatTypography.bodySmall.copyWith(fontSize: 11)),
                                ],
                              ),
                              Text(
                                '৳${res.amountDueAtTable.toStringAsFixed(2)}',
                                style: TreatTypography.headlineMedium.copyWith(
                                  color: TreatColors.secondary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Perforated Divider
                  const PerforatedDivider(),

                  // Attendant Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: TreatColors.primaryFixed,
                          child: Text('SM', style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary)),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verified by Stand Host SM', style: TreatTypography.titleSmall.copyWith(fontSize: 12)),
                            Text('Checked in via NFC Stand Reader #01', style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Return Button
            TreatButton(
              text: 'Return to Home Deals',
              icon: Icons.home,
              variant: TreatButtonVariant.solidSecondary,
              onPressed: onHome,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isCode = false, String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TreatTypography.bodySmall),
        Row(
          children: [
            Text(
              value,
              style: isCode
                  ? TreatTypography.ticketCode.copyWith(fontSize: 13)
                  : TreatTypography.labelSmall,
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TreatColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
