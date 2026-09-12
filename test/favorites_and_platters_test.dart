import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/screens/diner/choose_treat_budget_screen.dart';
import 'package:treat/screens/diner/favorites_screen.dart';
import 'package:treat/screens/diner/platter_packages_screen.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('Find It Within Budget button redirects to PlatterPackagesScreen matching mockup and handles favorites adding and deleting', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    final budgetState = BudgetPlannerState();
    final bookingState = BookingState();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: dinerState),
          ChangeNotifierProvider<BudgetPlannerState>.value(value: budgetState),
          ChangeNotifierProvider<BookingState>.value(value: bookingState),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: const AppShell(),
        ),
      ),
    );

    await tester.pump();
    // Skip opening screen if present
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // Sign in as Foodie to access full Food Bar with Treat button & filter
    final foodieSignIn = find.text('Sign In as Foodie');
    if (foodieSignIn.evaluate().isNotEmpty) {
      await tester.tap(foodieSignIn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.tap(find.text('Enter as Anonymous Guest'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.tap(find.text('Allow Location Access'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // Navigate to Food Bar
    final foodBarTab = find.text('Food Bar');
    expect(foodBarTab, findsOneWidget);
    await tester.tap(foodBarTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Tap Treat button at Food Bar to enter Food Bar filter page
    final treatButton = find.text('TREAT');
    expect(treatButton, findsOneWidget);
    await tester.tap(treatButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify on ChooseTreatBudgetScreen
    expect(find.byType(ChooseTreatBudgetScreen), findsOneWidget);
    expect(find.text('Calculate & Find Treats in Your Budget'), findsOneWidget);

    // Find and tap 'FIND IT WITHIN BUDGET' button
    final findWithinBudgetBtn = find.text('FIND IT WITHIN BUDGET');
    expect(findWithinBudgetBtn, findsOneWidget);
    await tester.ensureVisible(findWithinBudgetBtn);
    await tester.pumpAndSettle();
    await tester.tap(findWithinBudgetBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // VERIFICATION 1: Successfully redirected to PlatterPackagesScreen
    expect(find.byType(PlatterPackagesScreen), findsOneWidget);

    // VERIFICATION 2: Check Search, Treat button, and Sorting elements
    expect(find.text('food platters & packs'), findsOneWidget);
    expect(find.text('TREAT'), findsAtLeastNWidgets(1));
    expect(find.text('Recommended for You'), findsOneWidget);
    expect(find.text('Lowest Price First'), findsOneWidget);

    // VERIFICATION 3: Smart Recommendations Callout Banner
    expect(find.textContaining('Smart Recommendations:'), findsOneWidget);
    expect(find.textContaining('Curated strictly by lowest cost per foodie'), findsOneWidget);

    // VERIFICATION 4: Exact Platter Deals from the wireframe
    expect(find.text('The Sunset Sliders & Fries Feast'), findsOneWidget);
    expect(find.text('\$32.00'), findsOneWidget);
    expect(find.text('\$58.00'), findsOneWidget);
    expect(find.text('Save 45% OFF'), findsOneWidget);
    expect(find.text('🍔 12 Crispy Sliders'), findsOneWidget);
    expect(find.text('🍟 Loaded Truffle Fries'), findsOneWidget);
    expect(find.text('🥤 4 Milkshakes'), findsOneWidget);

    // VERIFICATION 5: Favorites adding and deleting logic
    final initialFavoritesCount = dinerState.favorites.length;
    expect(dinerState.isFavorite('deal-sunset-sliders'), isTrue);

    // Tap Loved It on Sunset Sliders (currently in favorites) to remove it
    final lovedButtons = find.text('Loved It');
    expect(lovedButtons, findsWidgets);
    await tester.tap(lovedButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(dinerState.isFavorite('deal-sunset-sliders'), isFalse);
    expect(dinerState.favorites.length, equals(initialFavoritesCount - 1));

    // Tap Loved It on Sunset Sliders again to re-add it
    await tester.tap(lovedButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(dinerState.isFavorite('deal-sunset-sliders'), isTrue);
    expect(dinerState.favorites.length, equals(initialFavoritesCount));

    // VERIFICATION 6: Test Share with Squad Modal
    final shareButtons = find.text('Share with Squad');
    expect(shareButtons, findsWidgets);
    await tester.tap(shareButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Copy Squad Invite Link'), findsOneWidget);

    // Close modal
    await tester.tap(find.text('Copy Squad Invite Link'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // VERIFICATION 7: Sort by Lowest Price First
    final lowestPriceChip = find.text('Lowest Price First');
    await tester.ensureVisible(lowestPriceChip);
    await tester.tap(lowestPriceChip);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Scroll down to reveal all cards and footer
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Fiesta Loaded Nachos & BBQ Wings'), findsOneWidget);
    expect(find.text('\$28.00'), findsOneWidget);
    expect(find.text('Save 42% OFF'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('More Delicious Deals Loading...'), findsOneWidget);
    expect(find.textContaining('We scan menus 24/7'), findsOneWidget);

    // VERIFICATION 10: Check Favorites screen directly
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: dinerState),
          ChangeNotifierProvider<BudgetPlannerState>.value(value: budgetState),
          ChangeNotifierProvider<BookingState>.value(value: bookingState),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: FavoritesScreen(
            onOpenDrawer: () {},
            onSelectDeal: (_) {},
            onExploreMore: () {},
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify Favorites screen renders items and delete action
    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.text('Your Loved Treat Spots'), findsOneWidget);

    // Delete one item from favorites
    final deleteIcons = find.byIcon(Icons.delete_outline_rounded);
    expect(deleteIcons, findsWidgets);

    ScaffoldMessenger.of(tester.element(find.byType(FavoritesScreen)))
        .clearSnackBars();
    await tester.pump();

    final beforeCount = dinerState.favorites.length;
    await tester.tap(deleteIcons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(dinerState.favorites.length, equals(beforeCount - 1));

    // Verify Undo action
    final undoButton = find.text('Undo');
    expect(undoButton, findsOneWidget);
    await tester.tap(undoButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(dinerState.favorites.length, equals(beforeCount));
  });
}
