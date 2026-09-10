import 'package:flutter_test/flutter_test.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/state/budget_planner_state.dart';

void main() {
  group('BudgetPlannerState Tests', () {
    late BudgetPlannerState state;

    setUp(() {
      state = BudgetPlannerState();
    });

    test('Initial state defaults match specification', () {
      expect(state.partySize, 3);
      expect(state.budget, 120.0);
      expect(state.perPersonBudget, 40.0);
      expect(state.includeTax, isTrue);
      expect(state.effectiveBudget, closeTo(120.0 * 1.18, 0.01));
    });

    test('Party size increments and decrements within bounds', () {
      state.incrementPartySize();
      expect(state.partySize, 4);
      expect(state.perPersonBudget, 30.0);

      state.decrementPartySize();
      state.decrementPartySize();
      expect(state.partySize, 2);
      expect(state.perPersonBudget, 60.0);

      // Decrement down to minimum 1
      state.decrementPartySize();
      expect(state.partySize, 1);
      state.decrementPartySize();
      expect(state.partySize, 1); // should not drop below 1
    });

    test('Budget adjustments update matched platters properly', () {
      state.setBudget(50.0);
      expect(state.budget, 50.0);

      final matched = state.matchedPlatters;
      for (final deal in matched) {
        expect(deal.price, lessThanOrEqualTo(50.0));
      }
    });

    test('Toggling tax adjusts effective budget', () {
      state.setBudget(100.0);
      expect(state.effectiveBudget, closeTo(118.0, 0.01));

      state.toggleIncludeTax(false);
      expect(state.effectiveBudget, closeTo(100.0, 0.01));
    });

    test('Category and platter selection update state and notify listeners', () {
      bool notified = false;
      state.addListener(() {
        notified = true;
      });

      state.setCategory('Street Bites');
      expect(state.selectedCategory, 'Street Bites');
      expect(notified, isTrue);

      final testDeal = PlatterDeal.megaFeastPlatter;
      state.selectPlatter(testDeal);
      expect(state.selectedPlatter.id, testDeal.id);
    });
  });
}
