import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/screens/diner/choose_treat_budget_screen.dart';
import 'package:treat/screens/diner/gateway_explore_screen.dart';
import 'package:treat/screens/diner/home_promotions_screen.dart';
import 'package:treat/screens/diner/platter_packages_screen.dart';
import 'package:treat/screens/diner/login_page.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/diner_drawer.dart';

void main() {
  testWidgets('Explore Without Sign In flow: back to gateway, events redirect to login, no top search, Food Bar Treat button', (WidgetTester tester) async {
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

    // 1. Skip opening screen
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // 2. Enter Explore Without Sign In from Gateway
    final exploreGuestBtn = find.text('Explore Without Sign In');
    expect(exploreGuestBtn, findsOneWidget);
    await tester.tap(exploreGuestBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify on guest HomePage (HomePromotionsScreen)
    expect(find.byType(HomePromotionsScreen), findsOneWidget);
    expect(dinerState.isFoodieLoggedIn, isFalse);

    // 3. Verify sidebar/drawer is NOT available
    expect(find.byType(DinerDrawer), findsNothing);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.drawer, isNull);

    // 4. Verify hamburger menu is replaced by a back button
    expect(find.byIcon(Icons.menu), findsNothing);
    final backToLoginBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(backToLoginBtn, findsOneWidget);

    // 5. Verify Top Search icon is NOT shown on homepage
    expect(find.byTooltip('Search'), findsNothing);

    // 6. Test Back button redirects to the same explore without sign in login page (GatewayExploreScreen)
    await tester.tap(backToLoginBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(GatewayExploreScreen), findsOneWidget);
    expect(find.text('Explore Without Sign In'), findsOneWidget);

    // Re-enter Explore Without Sign In
    await tester.tap(find.text('Explore Without Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 7. Verify 'Exploring Current Events' section & packages redirect to Login Page on action
    final joinGatheringBtn = find.text('Join Gathering');
    await tester.scrollUntilVisible(
      joinGatheringBtn,
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Exploring Current Events'), findsOneWidget);
    expect(joinGatheringBtn, findsOneWidget);
    await tester.tap(joinGatheringBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Should now be on the Login Page (WelcomeAnonymousScreen)
    expect(find.byType(WelcomeAnonymousScreen), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);

    // Go back to gateway & re-enter Explore Without Sign In
    final backFromLoginBtn = find.byIcon(Icons.arrow_back);
    if (backFromLoginBtn.evaluate().isNotEmpty) {
      await tester.tap(backFromLoginBtn.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }
    await tester.tap(find.text('Explore Without Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 8. Verify Food Bar tab in bottom navigation
    final foodBarTab = find.text('Food Bar');
    expect(foodBarTab, findsOneWidget);
    await tester.tap(foodBarTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 9. Food Bar should show ChooseTreatBudgetScreen at first
    expect(find.byType(ChooseTreatBudgetScreen), findsOneWidget);
    expect(find.text('SMART MATCHER'), findsOneWidget);

    // 10. Tap 'FIND IT WITHIN BUDGET' to see platters
    final findBudgetBtn = find.text('FIND IT WITHIN BUDGET');
    expect(findBudgetBtn, findsOneWidget);
    await tester.ensureVisible(findBudgetBtn);
    await tester.pumpAndSettle();
    await tester.tap(findBudgetBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(PlatterPackagesScreen), findsOneWidget);
    expect(find.text('food platters & packs'), findsOneWidget);
    expect(find.text('The Sunset Sliders & Fries Feast'), findsOneWidget);

    // 11. Loved It must NOT be available on this screen in guest mode
    expect(find.text('Loved It'), findsNothing);

    // 12. Share with Squad IS available
    expect(find.text('Share with Squad'), findsWidgets);

    // 13. Verify back button on PlatterPackagesScreen redirects to Food Bar panel
    final platterBackBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(platterBackBtn, findsOneWidget);
    await tester.tap(platterBackBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(ChooseTreatBudgetScreen), findsOneWidget);

    // 14. Verify back button on ChooseTreatBudgetScreen redirects to Gateway
    final budgetBackBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(budgetBackBtn, findsOneWidget);
    await tester.tap(budgetBackBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(GatewayExploreScreen), findsOneWidget);
  });
}
