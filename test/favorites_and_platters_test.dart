import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
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
      await tester.tap(find.text('Google'));
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

    // Food Bar now directly displays ChooseTreatBudgetScreen
    expect(find.byType(ChooseTreatBudgetScreen), findsOneWidget);
    expect(find.text('Calculate & Find Treats in Your Budget'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);

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

    // VERIFICATION 2: Check Search and Filter button
    expect(find.text('food platters & packz'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // VERIFICATION 3: Budget Summary Card
    expect(find.text('Budget: \$120'), findsOneWidget);
    expect(find.text('Casual Dining'), findsOneWidget);
    expect(find.text('Tax Included & Service Matched'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    // VERIFICATION 4: Discovered Platter Packages Header
    expect(find.text('Discovered Platter Packages'), findsOneWidget);
    expect(find.textContaining('Select your group feast package'), findsOneWidget);

    // VERIFICATION 5: Squad Allocation Card
    expect(find.text('Squad Allocation: \$120.00'), findsOneWidget);
    expect(find.textContaining('All platters leave ample budget'), findsOneWidget);
    expect(find.text('3+'), findsOneWidget);

    // VERIFICATION 6: Exact Platter Deals from the mockup
    expect(find.text('The Fiesta Treat Platter'), findsOneWidget);
    expect(find.text('\$45.00'), findsOneWidget);
    expect(find.text('\$65.00'), findsOneWidget);
    expect(find.text('(\$15.00 / person)'), findsOneWidget);
    expect(find.text('PACKAGE INCLUSIONS'), findsWidgets);
    expect(find.text('Select This Platter'), findsWidgets);

    // VERIFICATION 7: Favorites adding and deleting logic on Platter Card
    final initialFavoritesCount = dinerState.favorites.length;
    final fiestaFavBtn = find.byKey(const ValueKey('fav_btn_platter-1'));
    expect(fiestaFavBtn, findsOneWidget);

    // Tap heart to add to favorites
    await tester.tap(fiestaFavBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(dinerState.isFavorite('platter-1'), isTrue);
    expect(dinerState.favorites.length, equals(initialFavoritesCount + 1));

    // Tap heart again to remove from favorites
    await tester.tap(fiestaFavBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(dinerState.isFavorite('platter-1'), isFalse);
    expect(dinerState.favorites.length, equals(initialFavoritesCount));

    // VERIFICATION 8: Filter & Sort Modal
    final filterBtn = find.text('Filter');
    await tester.tap(filterBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Filters & Sort'), findsOneWidget);
    expect(find.text('Recommended for You'), findsOneWidget);
    expect(find.text('Lowest Price First'), findsOneWidget);

    // Tap Lowest Price First
    await tester.tap(find.text('Lowest Price First'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Close modal
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Scroll down to reveal subsequent cards and booking guarantee
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Mega Feast Platter Tier B'), findsOneWidget);
    expect(find.text('\$38.00'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Supreme Seafood Snack Bucket'), findsOneWidget);
    expect(find.text('\$64.00'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Treat Booking Guarantee'), findsOneWidget);
    expect(find.textContaining('Kitchen holds the table'), findsOneWidget);

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

    // Verify Favorites screen renders items and interacts matching Image 1
    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.text('My Loved Packages'), findsOneWidget);
    expect(find.text('5 Saved'), findsOneWidget);
    expect(find.text('The Sunset Sliders & Fries Feast'), findsOneWidget);

    // Toggle heart button on package card
    final heartBtn = find.byKey(const ValueKey('fav_btn_sunset-sliders'));
    expect(heartBtn, findsOneWidget);

    await tester.tap(heartBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('4 Saved'), findsOneWidget);
  });
}
