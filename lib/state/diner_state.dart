import 'package:flutter/material.dart';
import '../models/diner_persona.dart';
import '../models/voucher.dart';

class DinerState extends ChangeNotifier {
  DinerPersona _currentPersona = const DinerPersona(
    id: 'user-1',
    handle: 'MidnightDumpling',
    avatarEmoji: '🥟',
  );

  int _shuffleIndex = 0;
  List<Voucher> _vouchers = List.from(Voucher.sampleVouchers);
  final Set<String> _wishlistIds = {'platter-1'};

  DinerPersona get currentPersona => _currentPersona;
  List<Voucher> get vouchers => _vouchers;
  Set<String> get wishlistIds => _wishlistIds;

  void shufflePersona() {
    _shuffleIndex = (_shuffleIndex + 1) % DinerPersona.presetPersonas.length;
    final preset = DinerPersona.presetPersonas[_shuffleIndex];
    _currentPersona = _currentPersona.copyWith(
      handle: preset['handle']!,
      avatarEmoji: preset['emoji']!,
    );
    notifyListeners();
  }

  void setHandle(String newHandle) {
    _currentPersona = _currentPersona.copyWith(handle: newHandle);
    notifyListeners();
  }

  void setAvatarEmoji(String emoji) {
    _currentPersona = _currentPersona.copyWith(avatarEmoji: emoji);
    notifyListeners();
  }

  void toggleDietTag(String tag) {
    final current = List<String>.from(_currentPersona.dietTags);
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    _currentPersona = _currentPersona.copyWith(dietTags: current);
    notifyListeners();
  }

  void copyVoucher(String code) {
    _vouchers = _vouchers.map((v) {
      if (v.code == code) {
        return Voucher(
          code: v.code,
          title: v.title,
          description: v.description,
          tag: v.tag,
          discountAmount: v.discountAmount,
          isPercentage: v.isPercentage,
          minSpend: v.minSpend,
          isCopied: true,
        );
      }
      return v;
    }).toList();
    notifyListeners();
  }

  void toggleWishlist(String id) {
    if (_wishlistIds.contains(id)) {
      _wishlistIds.remove(id);
    } else {
      _wishlistIds.add(id);
    }
    notifyListeners();
  }

  void addWalletFunds(double amount) {
    _currentPersona = _currentPersona.copyWith(
      walletBalance: _currentPersona.walletBalance + amount,
    );
    notifyListeners();
  }

  void setPreferredSquadSize(int size) {
    _currentPersona = _currentPersona.copyWith(preferredSquadSize: size);
    notifyListeners();
  }

  void setBudgetTarget(double target) {
    _currentPersona = _currentPersona.copyWith(budgetTarget: target);
    notifyListeners();
  }

  void toggleAutoSplitBill(bool val) {
    _currentPersona = _currentPersona.copyWith(autoSplitBill: val);
    notifyListeners();
  }

  void toggleHideRealName(bool val) {
    _currentPersona = _currentPersona.copyWith(hideRealName: val);
    notifyListeners();
  }

  void toggleAllowSquadInvite(bool val) {
    _currentPersona = _currentPersona.copyWith(allowSquadInvite: val);
    notifyListeners();
  }

  void toggleGhostBrowsing(bool val) {
    _currentPersona = _currentPersona.copyWith(ghostBrowsing: val);
    notifyListeners();
  }

  void toggleInstantDropAlerts(bool val) {
    _currentPersona = _currentPersona.copyWith(instantDropAlerts: val);
    notifyListeners();
  }

  void toggleTableHoldReminders(bool val) {
    _currentPersona = _currentPersona.copyWith(tableHoldReminders: val);
    notifyListeners();
  }

  void toggleDealRadarAlerts(bool val) {
    _currentPersona = _currentPersona.copyWith(dealRadarAlerts: val);
    notifyListeners();
  }
}
