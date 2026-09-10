import 'package:flutter/material.dart';
import '../models/platter_deal.dart';

class BudgetPlannerState extends ChangeNotifier {
  int _partySize = 3;
  double _budget = 120.0;
  String _selectedCategory = 'Casual Dining';
  bool _includeTax = true;
  bool _walkableOnly = false;
  PlatterDeal _selectedPlatter = PlatterDeal.fiestaPlatter;

  int get partySize => _partySize;
  double get budget => _budget;
  String get selectedCategory => _selectedCategory;
  bool get includeTax => _includeTax;
  bool get walkableOnly => _walkableOnly;
  PlatterDeal get selectedPlatter => _selectedPlatter;

  double get perPersonBudget => _partySize > 0 ? _budget / _partySize : _budget;
  double get effectiveBudget => _includeTax ? _budget * 1.18 : _budget;

  List<String> get categories => const [
    'Casual Dining',
    'Fast Treat',
    'Fine Dining',
    'All-You-Can-Eat',
    'Street Bites',
  ];

  List<PlatterDeal> get matchedPlatters {
    return PlatterDeal.sampleDeals.where((deal) {
      return deal.price <= _budget;
    }).toList();
  }

  void incrementPartySize() {
    if (_partySize < 12) {
      _partySize++;
      notifyListeners();
    }
  }

  void decrementPartySize() {
    if (_partySize > 1) {
      _partySize--;
      notifyListeners();
    }
  }

  void setBudget(double value) {
    _budget = value;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleIncludeTax(bool val) {
    _includeTax = val;
    notifyListeners();
  }

  void toggleWalkableOnly(bool val) {
    _walkableOnly = val;
    notifyListeners();
  }

  void selectPlatter(PlatterDeal platter) {
    _selectedPlatter = platter;
    notifyListeners();
  }
}
