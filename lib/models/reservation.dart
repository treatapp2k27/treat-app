import 'platter_deal.dart';
import 'restaurant.dart';

enum ReservationStatus {
  inquiring, // 2-min countdown timer
  confirmed, // celebration boarding pass
  declined,
  completed,
}

class Reservation {
  final String id;
  final String code; // e.g. TR-88219
  final String voucherCode; // TR-88219-V
  final String manualPin; // #8402
  final Restaurant restaurant;
  final PlatterDeal platter;
  final int partySize;
  final String timeSlot;
  final String seatingPreference;
  final String tableAssigned;
  final DateTime createdAt;
  final int holdDurationSeconds;
  final ReservationStatus status;
  final double gratuity;
  final double taxes;
  final String dinerHandle;

  const Reservation({
    required this.id,
    required this.code,
    required this.voucherCode,
    required this.manualPin,
    required this.restaurant,
    required this.platter,
    required this.partySize,
    required this.timeSlot,
    required this.seatingPreference,
    this.tableAssigned = 'Table P-01',
    required this.createdAt,
    this.holdDurationSeconds = 120, // 2 minutes countdown
    this.status = ReservationStatus.inquiring,
    this.gratuity = 5.85,
    this.taxes = 0.0,
    this.dinerHandle = 'MidnightDumpling',
  });

  double get subtotal => platter.price;
  double get totalWithGratuity => subtotal + gratuity + taxes;
  double get amountDueAtTable => 0.00; // Paid via Treat In-App Wallet

  Reservation copyWith({
    String? id,
    String? code,
    String? voucherCode,
    String? manualPin,
    Restaurant? restaurant,
    PlatterDeal? platter,
    int? partySize,
    String? timeSlot,
    String? seatingPreference,
    String? tableAssigned,
    DateTime? createdAt,
    int? holdDurationSeconds,
    ReservationStatus? status,
    double? gratuity,
    double? taxes,
    String? dinerHandle,
  }) {
    return Reservation(
      id: id ?? this.id,
      code: code ?? this.code,
      voucherCode: voucherCode ?? this.voucherCode,
      manualPin: manualPin ?? this.manualPin,
      restaurant: restaurant ?? this.restaurant,
      platter: platter ?? this.platter,
      partySize: partySize ?? this.partySize,
      timeSlot: timeSlot ?? this.timeSlot,
      seatingPreference: seatingPreference ?? this.seatingPreference,
      tableAssigned: tableAssigned ?? this.tableAssigned,
      createdAt: createdAt ?? this.createdAt,
      holdDurationSeconds: holdDurationSeconds ?? this.holdDurationSeconds,
      status: status ?? this.status,
      gratuity: gratuity ?? this.gratuity,
      taxes: taxes ?? this.taxes,
      dinerHandle: dinerHandle ?? this.dinerHandle,
    );
  }

  static Reservation sampleActive = Reservation(
    id: 'res-88219',
    code: '#TR-88219',
    voucherCode: 'TR-88219-V',
    manualPin: '#8402',
    restaurant: Restaurant.sampleSpiceAndSizzle,
    platter: PlatterDeal.fiestaPlatter,
    partySize: 3,
    timeSlot: 'Today, 08:30 PM (in 25 mins)',
    seatingPreference: 'Outdoor patio table requested',
    tableAssigned: 'Table P-01',
    createdAt: DateTime.now(),
    status: ReservationStatus.confirmed,
    dinerHandle: 'MidnightDumpling',
  );
}
