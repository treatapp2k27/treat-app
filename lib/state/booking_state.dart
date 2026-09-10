import 'dart:async';
import 'package:flutter/material.dart';
import '../models/platter_deal.dart';
import '../models/reservation.dart';
import '../services/treat_mock_backend.dart';

class BookingState extends ChangeNotifier {
  final TreatMockBackend _backend = TreatMockBackend();
  StreamSubscription<List<Reservation>>? _sub;

  Reservation _currentReservation = Reservation.sampleActive;
  int _countdownSeconds = 120;
  Timer? _timer;
  bool _isInquiring = false;

  BookingState() {
    _sub = _backend.reservationsStream.listen(_onReservationsUpdated);
  }

  Reservation get currentReservation => _currentReservation;
  int get countdownSeconds => _countdownSeconds;
  bool get isInquiring => _isInquiring;
  double get timerProgress => _countdownSeconds / 120.0;

  String get formattedTimer {
    final mins = (_countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_countdownSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _onReservationsUpdated(List<Reservation> list) {
    final updated = list.firstWhere(
      (r) => r.id == _currentReservation.id,
      orElse: () => _currentReservation,
    );
    if (updated.status != _currentReservation.status) {
      _currentReservation = updated;
      if (updated.status == ReservationStatus.confirmed) {
        _timer?.cancel();
        _isInquiring = false;
      }
      notifyListeners();
    }
  }

  void startInquiry({
    required PlatterDeal platter,
    required int partySize,
    required String seatingPreference,
    required String dinerHandle,
  }) {
    _timer?.cancel();
    _countdownSeconds = 120;
    _isInquiring = true;

    _currentReservation = _backend.createHoldInquiry(
      platter: platter,
      partySize: partySize,
      seatingPreference: seatingPreference,
      dinerHandle: dinerHandle,
    );
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        t.cancel();
        _isInquiring = false;
        _backend.declineReservation(_currentReservation.id);
        _currentReservation = _currentReservation.copyWith(status: ReservationStatus.declined);
        notifyListeners();
      }
    });
  }

  /// Cancels an active reservation inquiry
  void cancelInquiry() {
    _timer?.cancel();
    _isInquiring = false;
    _backend.declineReservation(_currentReservation.id);
    _currentReservation = _currentReservation.copyWith(status: ReservationStatus.declined);
    notifyListeners();
  }

  /// Resets to default sample state
  void reset() {
    _timer?.cancel();
    _isInquiring = false;
    _countdownSeconds = 120;
    _currentReservation = Reservation.sampleActive;
    notifyListeners();
  }

  /// Helper to test or simulate expiration
  void expireInquiryForTest() {
    _countdownSeconds = 0;
    _timer?.cancel();
    _isInquiring = false;
    _backend.declineReservation(_currentReservation.id);
    _currentReservation = _currentReservation.copyWith(status: ReservationStatus.declined);
    notifyListeners();
  }

  /// Simulate instant auto-confirm if user wants demo flow
  void simulateInstantConfirm() {
    _backend.confirmReservation(_currentReservation.id);
    _currentReservation = _currentReservation.copyWith(status: ReservationStatus.confirmed);
    _timer?.cancel();
    _isInquiring = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
