import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/screens/diner/home_promotions_screen.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/bangladesh_location_picker_dialog.dart';

void main() {
  testWidgets('HomePromotionsScreen renders wireframe mockup layout and verifies workable carousel functionalities',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool drawerOpened = false;
    bool backToLoginCalled = false;
    PlatterDeal? selectedDeal;
    bool budgetPlannerNavigated = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: HomePromotionsScreen(
            onOpenDrawer: () => drawerOpened = true,
            onBackToLogin: () => backToLoginCalled = true,
            onSelectDeal: (deal) => selectedDeal = deal,
            onNavigateBudgetPlanner: () => budgetPlannerNavigated = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Header Elements (guest mode shows back button, no menu)
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);
    expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
    expect(find.byType(Image), findsAtLeastNWidgets(1));
    // Profile icon is NOT visible in guest mode
    expect(find.byIcon(Icons.person), findsNothing);

    // 2. Verify Live Ticker
    expect(find.text('Live nearby platters updating in real-time'), findsOneWidget);
    expect(find.text('14 Active Feasts'), findsOneWidget);

    // 3. Verify Search Bar
    expect(find.text('Search sweets, spots & group pla...'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    // 4. Verify Filter Chips
    expect(find.text('Trending Platters'), findsOneWidget);
    expect(find.text('Squad Feasts'), findsOneWidget);
    expect(find.text('Flash Drops'), findsOneWidget);

    // Test filter selection tap
    await tester.tap(find.text('Squad Feasts'));
    await tester.pump(const Duration(milliseconds: 200));

    // 5. Verify Section: HOT NEARBY & Hottest Platters Near You
    expect(find.text('HOT NEARBY'), findsOneWidget);
    expect(find.text('Hottest Platters Near You'), findsOneWidget);
    expect(find.text('Within 1.2 mi'), findsOneWidget);

    // Verify Initial Carousel Card (Neon Glaze Fiesta Platter)
    expect(find.text('Neon Glaze Fiesta Platter'), findsOneWidget);
    expect(find.text('2-FOR-1 DEAL'), findsOneWidget);
    expect(find.text('0.4 mi away'), findsOneWidget);
    expect(find.text('Ends in 2h 14m'), findsOneWidget);
    expect(find.text('50% SAVED'), findsOneWidget);
    expect(find.text('Includes 6 sweet dips'), findsOneWidget);
    expect(find.text('View Details'), findsAtLeastNWidgets(1));

    // 6. Test Carousel "Loved It" Button Toggle
    final lovedButtons = find.text('Loved It');
    expect(lovedButtons, findsAtLeastNWidgets(1));
    await tester.tap(lovedButtons.first);
    await tester.pump(const Duration(milliseconds: 200));

    // 7. Test Carousel Navigation to Platter Details
    final viewDetails = find.text('View Details');
    expect(viewDetails, findsAtLeastNWidgets(1));
    await tester.tap(viewDetails.first);
    await tester.pump(const Duration(milliseconds: 200));
    expect(selectedDeal, isNotNull);

    // 8. Verify Carousel Navigation Chevron Icons removed and Auto-Sliding works
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 600));

    // 9. Verify Section: Exploring Current Events (WHAT'S ON NOW)
    expect(find.text("WHAT'S ON NOW"), findsOneWidget);
    expect(find.text('Exploring Current Events'), findsOneWidget);
    expect(find.text('Sprinkle & Sizzle Social'), findsAtLeastNWidgets(1));
    expect(find.text('Sugar Bloom Cafe & Brunch'), findsAtLeastNWidgets(1));
    expect(find.text('Join Gathering'), findsOneWidget);
    expect(find.text('RSVP Table'), findsOneWidget);

    // 10. Verify Section: Squad Minigame is removed from Explore page (relocated to sidebar drawer)
    expect(find.text("Mia's Sweet Treat Perks"), findsNothing);
    expect(find.text('Play Squad Ludo 🎲'), findsNothing);

    // 11. Test Header Back to Login Button in Guest Mode
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(backToLoginCalled, isTrue);
  });

  testWidgets('HomePromotionsScreen renders location bar when Foodie is logged in and handles change and radius modals',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    dinerState.setFoodieLoggedIn(true);

    bool profileNavigated = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: dinerState),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: HomePromotionsScreen(
            onOpenDrawer: () {},
            onSelectDeal: (_) {},
            onNavigateBudgetPlanner: () {},
            onNavigateProfile: () => profileNavigated = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify location bar elements
    expect(find.text('Soho Quarter'), findsOneWidget);
    expect(find.text('CHANGE'), findsOneWidget);
    expect(find.text('Within 2 mi'), findsOneWidget);

    // Verify profile icon is visible and redirects to profile
    expect(find.byIcon(Icons.person), findsOneWidget);
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(profileNavigated, isTrue);

    // Test tapping CHANGE
    await tester.tap(find.text('CHANGE'));
    await tester.pumpAndSettle();

    expect(find.text('Change Location'), findsOneWidget);
    expect(find.text('SSK Road'), findsWidgets);

    // Select preferable road SSK Road from Quick Neighborhood selection
    await tester.tap(find.descendant(
      of: find.byType(BangladeshLocationPickerDialog),
      matching: find.text('SSK Road'),
    ));
    await tester.pumpAndSettle();

    expect(dinerState.userLocation, equals('SSK Road, Feni Sadar'));
    expect(find.text('SSK Road, Feni Sadar'), findsWidgets);

    // Test tapping Radius
    await tester.tap(find.text('Within 2 mi'));
    await tester.pumpAndSettle();

    expect(find.text('Select Search Radius'), findsOneWidget);
    expect(find.text('Within 5 mi'), findsOneWidget);

    // Select Within 5 mi
    await tester.tap(find.text('Within 5 mi'));
    await tester.pumpAndSettle();

    expect(dinerState.locationRadius, equals('Within 5 mi'));
    expect(find.text('Within 5 mi'), findsOneWidget);
  });
}
