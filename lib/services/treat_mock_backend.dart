import 'dart:async';
import '../models/platter_deal.dart';
import '../models/reservation.dart';
import '../models/restaurant.dart';
import '../models/table_info.dart';

/// Singleton Mock Backend providing live reactive stream synchronization
/// between Diner actions and Kitchen Partner dashboard.
class TreatMockBackend {
  static final TreatMockBackend _instance = TreatMockBackend._internal();
  factory TreatMockBackend() => _instance;
  static TreatMockBackend get instance => _instance;

  TreatMockBackend._internal() {
    _tables = List.from(TableInfo.initialTables);
    _reservations = [
      Reservation.sampleActive,
      Reservation(
        id: 'res-99120',
        code: '#TR-99120',
        voucherCode: 'TR-99120-V',
        manualPin: '#3144',
        restaurant: Restaurant.sampleSpiceAndSizzle,
        platter: PlatterDeal.megaFeastPlatter,
        partySize: 2,
        timeSlot: 'Today, 09:00 PM (in 55 mins)',
        seatingPreference: 'Standard booth',
        tableAssigned: 'Table M-01',
        createdAt: DateTime.now(),
        status: ReservationStatus.inquiring,
        dinerHandle: 'TacoFiend',
      ),
    ];
  }

  late List<TableInfo> _tables;
  late List<Reservation> _reservations;

  final _reservationsController = StreamController<List<Reservation>>.broadcast();
  final _tablesController = StreamController<List<TableInfo>>.broadcast();

  Stream<List<Reservation>> get reservationsStream => _reservationsController.stream;
  Stream<List<TableInfo>> get tablesStream => _tablesController.stream;

  List<Reservation> get activeReservations => List.unmodifiable(_reservations);
  List<TableInfo> get tables => List.unmodifiable(_tables);

  /// Diner requests a platter hold (triggers 2-minute timer & sends to Kitchen Queue)
  Reservation createHoldInquiry({
    required PlatterDeal platter,
    required int partySize,
    required String seatingPreference,
    required String dinerHandle,
  }) {
    final newCode = '#TR-${88000 + _reservations.length * 111}';
    final reservation = Reservation(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      code: newCode,
      voucherCode: '$newCode-V'.replaceAll('#', ''),
      manualPin: '#${(1000 + (_reservations.length * 243) % 9000)}',
      restaurant: Restaurant.sampleSpiceAndSizzle,
      platter: platter,
      partySize: partySize,
      timeSlot: 'Today, 08:30 PM (in 25 mins)',
      seatingPreference: seatingPreference,
      createdAt: DateTime.now(),
      status: ReservationStatus.inquiring,
      dinerHandle: dinerHandle,
    );

    _reservations.insert(0, reservation);
    _reservationsController.add(List.from(_reservations));
    return reservation;
  }

  /// Kitchen confirms the inquiry -> Table is reserved & Diner slip is confirmed
  void confirmReservation(String reservationId, {String tableAssigned = 'Table P-01'}) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(
        status: ReservationStatus.confirmed,
        tableAssigned: tableAssigned,
      );
      _reservationsController.add(List.from(_reservations));

      // Update table status on floor
      final tableIdx = _tables.indexWhere((t) => t.name == tableAssigned);
      if (tableIdx != -1) {
        _tables[tableIdx] = _tables[tableIdx].copyWith(
          status: TableStatus.reserved,
          activeReservationCode: _reservations[index].code,
        );
        _tablesController.add(List.from(_tables));
      }
    }
  }

  /// Kitchen declines the inquiry
  void declineReservation(String reservationId) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(
        status: ReservationStatus.declined,
      );
      _reservationsController.add(List.from(_reservations));
    }
  }

  /// Toggle table status on floor manager
  void updateTableStatus(String tableId, TableStatus newStatus) {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx != -1) {
      _tables[idx] = _tables[idx].copyWith(status: newStatus);
      _tablesController.add(List.from(_tables));
    }
  }
}
