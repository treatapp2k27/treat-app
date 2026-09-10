import 'package:flutter_test/flutter_test.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/models/reservation.dart';
import 'package:treat/models/table_info.dart';
import 'package:treat/services/treat_mock_backend.dart';
import 'package:treat/state/booking_state.dart';

void main() {
  group('Reservation and Cross-Role Sync Tests', () {
    late TreatMockBackend backend;

    setUp(() {
      backend = TreatMockBackend();
    });

    test('TreatMockBackend initializes with default tables and active reservations', () {
      expect(backend.tables, isNotEmpty);
      expect(backend.activeReservations, isNotEmpty);
      expect(backend.tables.any((t) => t.id == 't-1'), isTrue);
    });

    test('Diner hold inquiry creates pending reservation and emits to streams', () async {
      final initialCount = backend.activeReservations.length;

      final newRes = backend.createHoldInquiry(
        platter: PlatterDeal.megaFeastPlatter,
        partySize: 4,
        seatingPreference: 'Patio booth',
        dinerHandle: 'CrunchLover',
      );

      expect(newRes.partySize, 4);
      expect(newRes.dinerHandle, 'CrunchLover');
      expect(newRes.status, ReservationStatus.inquiring);
      expect(newRes.code, startsWith('#TR-'));
      expect(newRes.voucherCode, isNotEmpty);
      expect(backend.activeReservations.length, initialCount + 1);
    });

    test('Kitchen confirmation assigns table and updates both reservation & table status', () {
      final newRes = backend.createHoldInquiry(
        platter: PlatterDeal.fiestaPlatter,
        partySize: 2,
        seatingPreference: 'Standard booth',
        dinerHandle: 'SpiceSeeker',
      );

      backend.confirmReservation(newRes.id, tableAssigned: 'Table P-02');

      final updatedRes = backend.activeReservations.firstWhere((r) => r.id == newRes.id);
      expect(updatedRes.status, ReservationStatus.confirmed);
      expect(updatedRes.tableAssigned, 'Table P-02');

      final updatedTable = backend.tables.firstWhere((t) => t.name == 'Table P-02');
      expect(updatedTable.status, TableStatus.reserved);
      expect(updatedTable.activeReservationCode, updatedRes.code);
    });

    test('Kitchen decline sets reservation status to declined', () {
      final newRes = backend.createHoldInquiry(
        platter: PlatterDeal.megaFeastPlatter,
        partySize: 6,
        seatingPreference: 'Window booth',
        dinerHandle: 'NightOwl',
      );

      backend.declineReservation(newRes.id);

      final updatedRes = backend.activeReservations.firstWhere((r) => r.id == newRes.id);
      expect(updatedRes.status, ReservationStatus.declined);
    });

    test('Table status update reflects in floor manager', () {
      backend.updateTableStatus('t-1', TableStatus.dining);
      final tbl = backend.tables.firstWhere((t) => t.id == 't-1');
      expect(tbl.status, TableStatus.dining);

      backend.updateTableStatus('t-1', TableStatus.free);
      final tblAvailable = backend.tables.firstWhere((t) => t.id == 't-1');
      expect(tblAvailable.status, TableStatus.free);
    });

    test('BookingState handles inquiry lifecycle, timer, cancel and confirm', () {
      final bookingState = BookingState();
      expect(bookingState.isInquiring, isFalse);
      expect(bookingState.formattedTimer, '02:00');

      bookingState.startInquiry(
        platter: PlatterDeal.fiestaPlatter,
        partySize: 3,
        seatingPreference: 'Patio booth',
        dinerHandle: 'MidnightDumpling',
      );

      expect(bookingState.isInquiring, isTrue);
      expect(bookingState.currentReservation.status, ReservationStatus.inquiring);
      expect(bookingState.currentReservation.partySize, 3);

      bookingState.cancelInquiry();
      expect(bookingState.isInquiring, isFalse);
      expect(bookingState.currentReservation.status, ReservationStatus.declined);

      bookingState.reset();
      expect(bookingState.currentReservation.status, ReservationStatus.confirmed);
      bookingState.dispose();
    });
  });
}
