import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('AppShell renders Explore without Login flow with 2 nav tabs and no location bar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
          ChangeNotifierProvider<BookingState>(create: (_) => BookingState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: const AppShell(),
        ),
      ),
    );

    // Verify initial render on opening screen
    await tester.pump();
    final skipButton = find.text('Skip');
    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // On GatewayExploreScreen, tap 'Explore Without Sign In'
    final exploreGuest = find.text('Explore Without Sign In');
    if (exploreGuest.evaluate().isNotEmpty) {
      await tester.tap(exploreGuest);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // Verify home promotions screen is rendered
    expect(find.text('Hottest Platters Near You'), findsOneWidget);
    expect(find.text('Trending Platters'), findsOneWidget);

    // Verify location pill bar is NOT shown in guest mode
    expect(find.text('CHANGE'), findsNothing);

    // Verify guest bottom nav has the same navigation tabs as Sign page
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Food Bar'), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Full flow: Foodie Login -> Login Page -> Location Page -> Homepage with location bar and full nav tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
          ChangeNotifierProvider<BookingState>(create: (_) => BookingState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: const AppShell(),
        ),
      ),
    );

    // 1. Opening screen: tap Skip to enter Gateway
    await tester.pump();
    final skipOpening = find.text('Skip');
    if (skipOpening.evaluate().isNotEmpty) {
      await tester.tap(skipOpening);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    // 2. Gateway screen (Foodie Login): tap 'Sign In as Foodie'
    expect(find.text('Sign In as Foodie'), findsOneWidget);
    await tester.tap(find.text('Sign In as Foodie'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 3. Login Page (WelcomeAnonymousScreen): verify and tap Google sign-in
    expect(find.text('Google'), findsOneWidget);
    await tester.tap(find.text('Google'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 4. Location Page (LocationSharingScreen): verify exact wireframe elements
    expect(
      find.byWidgetPredicate((w) =>
          w is RichText &&
          w.text.toPlainText().contains('Find Tasty Deals') &&
          w.text.toPlainText().contains('Around You')),
      findsOneWidget,
    );
    expect(find.text('Allow Location Access'), findsOneWidget);
    expect(find.text('Enter City or Zip Code'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
    expect(find.text('Instant food deals & table drops within walking distance'), findsOneWidget);
    expect(find.text('100% anonymous — never tracked in background'), findsOneWidget);

    // 5. From Location Page, tap 'Allow Location Access' to enter Homepage
    await tester.tap(find.text('Allow Location Access'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // 6. Homepage: verify home promotions is rendered
    expect(find.text('Hottest Platters Near You'), findsOneWidget);
    expect(find.text('Trending Platters'), findsOneWidget);

    // 7. Verify Location Pill Bar IS rendered for Foodie login
    expect(find.text('Soho Quarter'), findsOneWidget);
    expect(find.text('CHANGE'), findsOneWidget);
    expect(find.text('Within 2 mi'), findsOneWidget);

    // 8. Verify bottom nav has 4 options (Favorites removed, Social renamed to Feed)
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Food Bar'), findsOneWidget);
    expect(find.text('Favorites'), findsNothing);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify Favorites icon IS present in top bar
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    // 9. Tap Profile Avatar icon in TopBar to redirect to Profile Settings page
    final profileButtons = find.byWidgetPredicate((w) =>
        w is InkWell &&
        w.child is Container &&
        (w.child as Container).decoration is BoxDecoration &&
        ((w.child as Container).decoration as BoxDecoration).color ==
            const Color(0xFFD6228A));
    expect(profileButtons, findsOneWidget);
    await tester.tap(profileButtons);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify Profile Settings screen is rendered
    expect(find.text('ACCOUNT & PERSONA'), findsOneWidget);
    expect(find.text('Display Persona'), findsOneWidget);
    expect(find.text('PREFERENCES & DINING'), findsOneWidget);
    expect(find.text('TREAT SQUAD & GAMES'), findsOneWidget);
  });
}
