import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kitchen_partner.dart';
import '../models/reservation.dart';
import '../models/table_info.dart';
import '../services/treat_mock_backend.dart';

class KitchenPartnerState extends ChangeNotifier {
  final TreatMockBackend _backend = TreatMockBackend();
  StreamSubscription<List<Reservation>>? _resSub;
  StreamSubscription<List<TableInfo>>? _tableSub;

  KitchenPartner _partner = const KitchenPartner();
  List<Reservation> _reservations = [];
  List<TableInfo> _tables = [];

  // Terminal Auth
  String _enteredPin = '12';
  bool _isAuthenticated = false;
  String _selectedArea = 'All';

  KitchenPartnerState() {
    _reservations = _backend.activeReservations;
    _tables = _backend.tables;

    _resSub = _backend.reservationsStream.listen((list) {
      _reservations = list;
      notifyListeners();
    });

    _tableSub = _backend.tablesStream.listen((list) {
      _tables = list;
      notifyListeners();
    });
  }

  KitchenPartner get partner => _partner;
  List<Reservation> get reservations => _reservations;
  List<TableInfo> get tables => _tables;
  String get enteredPin => _enteredPin;
  bool get isAuthenticated => _isAuthenticated;
  String get selectedArea => _selectedArea;

  List<Reservation> get pendingReservations => _reservations
      .where((r) => r.status == ReservationStatus.inquiring)
      .toList();

  List<TableInfo> get filteredTables {
    if (_selectedArea == 'All') return _tables;
    return _tables.where((t) => t.area == _selectedArea).toList();
  }

  int get availableTablesCount =>
      _tables.where((t) => t.status == TableStatus.free).length;

  // Pin Keypad Interactions
  void appendPinDigit(String digit) {
    if (_enteredPin.length < 4) {
      _enteredPin += digit;
      if (_enteredPin.length == 4) {
        // Authenticate automatically with 4 digits
        _isAuthenticated = true;
      }
      notifyListeners();
    }
  }

  void backspacePin() {
    if (_enteredPin.isNotEmpty) {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      notifyListeners();
    }
  }

  void clearPin() {
    _enteredPin = '';
    notifyListeners();
  }

  void setStation(TerminalStation station) {
    _partner = _partner.copyWith(activeStation: station);
    notifyListeners();
  }

  void toggleAcceptingBookings(bool val) {
    _partner = _partner.copyWith(isAcceptingBookings: val);
    notifyListeners();
  }

  void toggleRushMode(bool val) {
    _partner = _partner.copyWith(rushMode: val);
    notifyListeners();
  }

  void toggleAutoAccept(bool val) {
    _partner = _partner.copyWith(autoAcceptBundles: val);
    notifyListeners();
  }

  void setGraceWindow(int mins) {
    _partner = _partner.copyWith(graceWindowMins: mins);
    notifyListeners();
  }

  void setAreaFilter(String area) {
    _selectedArea = area;
    notifyListeners();
  }

  // Reservation Actions
  void confirmReservation(String id) {
    _backend.confirmReservation(id);
    _partner = _partner.copyWith(
      reservationsToday: _partner.reservationsToday + 1,
      treatSalesToday: _partner.treatSalesToday + 45.0,
    );
    notifyListeners();
  }

  void declineReservation(String id) {
    _backend.declineReservation(id);
    notifyListeners();
  }

  void setTableStatus(String tableId, TableStatus status) {
    _backend.updateTableStatus(tableId, status);
  }

  void logOut() {
    _isAuthenticated = false;
    _enteredPin = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _resSub?.cancel();
    _tableSub?.cancel();
    super.dispose();
  }
}
