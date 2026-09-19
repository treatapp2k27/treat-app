import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/screens/diner/choose_treat_budget_screen.dart';
import 'package:treat/screens/diner/login_page.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/guest_auth_overlay.dart';

void main() {
  testWidgets(
      'Guest Explore: Lower nav has 4 tabs, Feed & Profile & View Details & Select Platter show transparent overlay with "Sign in to Unlock all the Features", redirect to Login Page',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
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

    // 1. Skip opening screen if present
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // 2. Enter Explore Without Sign In
    final exploreGuestBtn = find.text('Explore Without Sign In');
    expect(exploreGuestBtn, findsOneWidget);
    await tester.tap(exploreGuestBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify user is in guest mode
    expect(dinerState.isFoodieLoggedIn, isFalse);

    // 3. Verify back button in Explore without sign in has white round radius (BoxShape.circle with white color)
    final backIcon = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(backIcon, findsOneWidget);
    final backContainer = tester.widget<Container>(
      find.ancestor(of: backIcon, matching: find.byType(Container)).first,
    );
    final boxDecoration = backContainer.decoration as BoxDecoration?;
    expect(boxDecoration?.shape, equals(BoxShape.circle));
    expect(boxDecoration?.color, equals(Colors.white));

    // 4. Lower navigation bar should have all 4 tabs: Explore, Food Bar, Feed, Profile
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Food Bar'), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 5. Test clicking 'View Details' on Homepage while exploring without sign in
    final viewDetailsBtn = find.text('View Details');
    expect(viewDetailsBtn, findsAtLeastNWidgets(1));
    await tester.tap(viewDetailsBtn.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify modal appears with "Sign in to Unlock all the Features" and PLATTER DETAILS tag
    expect(find.byType(GuestAuthOverlay), findsOneWidget);
    expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
    expect(find.text('PLATTER DETAILS'), findsOneWidget);

    // Dismiss modal via "Back to Explore Platters"
    final backFromDetailsBtn =
        find.byKey(const ValueKey('guest_overlay_back_button'));
    expect(backFromDetailsBtn, findsOneWidget);
    await tester.tap(backFromDetailsBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(GuestAuthOverlay), findsNothing);

    // 6. Test Food Bar tab: shows Calculate & Find Treats panels at first
    await tester.tap(find.text('Food Bar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(ChooseTreatBudgetScreen), findsOneWidget);
    expect(find.text('SMART MATCHER'), findsOneWidget);

    // Tap 'FIND IT WITHIN BUDGET' to view platters
    final findBudgetBtn = find.text('FIND IT WITHIN BUDGET');
    expect(findBudgetBtn, findsOneWidget);
    await tester.tap(findBudgetBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final selectPlatterBtn = find.text('Select This Platter');
    expect(selectPlatterBtn, findsAtLeastNWidgets(1));
    await tester.tap(selectPlatterBtn.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify modal appears with "Sign in to Unlock all the Features" and SELECT PLATTER tag
    expect(find.byType(GuestAuthOverlay), findsOneWidget);
    expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
    expect(find.text('SELECT PLATTER'), findsOneWidget);

    // Click "Sign In to Unlock" from this modal -> redirects to LoginPage
    final signInBtnFromPlatter =
        find.byKey(const ValueKey('guest_overlay_sign_in_button'));
    expect(signInBtnFromPlatter, findsOneWidget);
    await tester.tap(signInBtnFromPlatter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Treat Sign In'), findsOneWidget);

    // Go back to gateway & re-enter Explore Without Sign In
    final backFromLoginBtn = find.byIcon(Icons.arrow_back);
    expect(backFromLoginBtn, findsOneWidget);
    await tester.tap(backFromLoginBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.text('Explore Without Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 7. Tap 'Feed' tab
    await tester.tap(find.text('Feed'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify transparent GuestAuthOverlay is shown
    expect(find.byType(GuestAuthOverlay), findsOneWidget);
    expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
    expect(find.text('FOODIE FEED'), findsOneWidget);

    // Click the CTA button on the overlay -> redirects to Log In page
    final signInBtn = find.byKey(const ValueKey('guest_overlay_sign_in_button'));
    expect(signInBtn, findsOneWidget);
    await tester.tap(signInBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify redirected to Login Page
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Treat Sign In'), findsOneWidget);

    // Go back to Explore
    final backBtn = find.byIcon(Icons.arrow_back);
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Re-enter Explore Without Sign In
    await tester.tap(find.text('Explore Without Sign In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 8. Tap 'Profile' tab
    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify GuestAuthOverlay is shown on Profile
    expect(find.byType(GuestAuthOverlay), findsOneWidget);
    expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
    expect(find.text('MEMBER PROFILE'), findsOneWidget);

    // 9. Tap "Back to Explore Platters" button on overlay
    final backToExploreBtn =
        find.byKey(const ValueKey('guest_overlay_back_button'));
    expect(backToExploreBtn, findsOneWidget);
    await tester.tap(backToExploreBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify we are back on Explore (Home) and overlay is gone
    expect(find.byType(GuestAuthOverlay), findsNothing);
    expect(find.text('Hottest Platters Near You'), findsOneWidget);

    // 10. When user logs in, overlay is no longer shown on Feed or Profile
    dinerState.setFoodieLoggedIn(true);
    await tester.pump();

    // Tap Feed
    await tester.tap(find.text('Feed'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(GuestAuthOverlay), findsNothing);

    // Tap Profile
    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(GuestAuthOverlay), findsNothing);
  });

  testWidgets(
      'Food Bar Panel in Guest Mode: Topbar matches Homepage (58px, centered logo, circular backbutton), Search & Filters below topbar, Loved It redirects to Unlock Features modal',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
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

    // 1. Skip opening screen if present
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // 2. Enter Explore Without Sign In
    final exploreGuestBtn = find.text('Explore Without Sign In');
    expect(exploreGuestBtn, findsOneWidget);
    await tester.tap(exploreGuestBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 3. Verify Homepage AppBar toolbarHeight is 58 and Treat logo is present
    final homeAppBar = tester.widget<AppBar>(find.byType(AppBar).first);
    expect(homeAppBar.toolbarHeight, equals(58));

    // 4. Test Loved It button on Homepage triggers Unlock Features modal
    final homeLovedBtns = find.byIcon(Icons.favorite_border_rounded);
    if (homeLovedBtns.evaluate().isNotEmpty) {
      await tester.tap(homeLovedBtns.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(GuestAuthOverlay), findsOneWidget);
      expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
      expect(find.text('FAVORITE TREATS'), findsOneWidget);

      // Dismiss overlay
      final backOverlay = find.byKey(const ValueKey('guest_overlay_back_button'));
      await tester.tap(backOverlay);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(GuestAuthOverlay), findsNothing);
    }

    // 5. Navigate to Food Bar tab
    final foodBarTab = find.text('Food Bar');
    expect(foodBarTab, findsOneWidget);
    await tester.tap(foodBarTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 6. Verify Food Bar AppBar toolbarHeight is also 58 (matching Homepage)
    final foodBarAppBar = tester.widget<AppBar>(find.byType(AppBar).first);
    expect(foodBarAppBar.toolbarHeight, equals(58));

    // 7. Verify backbutton in Food Bar is circular white button matching Explore
    final foodBarBackIcon = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(foodBarBackIcon, findsOneWidget);
    final backContainer = tester.widget<Container>(
      find.ancestor(of: foodBarBackIcon, matching: find.byType(Container)).first,
    );
    final boxDecoration = backContainer.decoration as BoxDecoration?;
    expect(boxDecoration?.shape, equals(BoxShape.circle));
    expect(boxDecoration?.color, equals(Colors.white));

    // 8. Verify Search and Filters button are below topbar (inside body)
    expect(find.text('Search sweets, spots & treats...'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);

    // 9. Verify Loved It button on Food Bar platter card redirects to Unlock features modal
    final lovedItBtns = find.text('Loved It');
    expect(lovedItBtns, findsAtLeastNWidgets(1));
    await tester.ensureVisible(lovedItBtns.first);
    await tester.pumpAndSettle();
    await tester.tap(lovedItBtns.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(GuestAuthOverlay), findsOneWidget);
    expect(find.text('Sign in to Unlock all the Features'), findsOneWidget);
    expect(find.text('FAVORITE TREATS'), findsOneWidget);

    // 10. Clicking Sign In redirects to Login Page
    final signInBtn = find.byKey(const ValueKey('guest_overlay_sign_in_button'));
    expect(signInBtn, findsOneWidget);
    await tester.tap(signInBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Treat Sign In'), findsOneWidget);
  });
}
