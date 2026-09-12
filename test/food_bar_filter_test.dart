import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/screens/diner/platter_packages_screen.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('Food Bar Treat button navigates to Food Bar filter page (Smart Matcher) with exact wireframe elements', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
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

    // Tap on Food Bar tab in bottom navigation
    final foodBarTab = find.text('Food Bar');
    expect(foodBarTab, findsOneWidget);
    await tester.tap(foodBarTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify on Food Bar screen: Hotlist Rush Hour, Feast Platters tab
    expect(find.text('Food Bar Rush Hour'), findsOneWidget);
    expect(find.text('Feast Platters'), findsOneWidget);

    // Find the Treat button in the Food Bar TopBar
    final treatButton = find.text('TREAT');
    expect(treatButton, findsOneWidget);

    // Tap the Treat button at Food Bar
    await tester.tap(treatButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify that the Food Bar filter page (Smart Matcher) is displayed!
    expect(find.text('SMART MATCHER'), findsOneWidget);
    expect(find.text('Calculate & Find Treats in Your Budget'), findsOneWidget);
    expect(find.text('Set your sweet spot & feast like royalty without the wallet shock!'), findsOneWidget);
    expect(find.text('Party Crew'), findsOneWidget);
    expect(find.text("Who's joining the table?"), findsOneWidget);
    expect(find.text('Total Squad Budget'), findsOneWidget);
    expect(find.text('FOOD CATEGORY CRAVING'), findsOneWidget);
    expect(find.text('Casual Dining'), findsOneWidget);
    expect(find.text('Fast Treat'), findsOneWidget);
    expect(find.text('Fine Dining'), findsOneWidget);
    expect(find.text('All-You-Can-Eat'), findsOneWidget);
    expect(find.text('Street Bites'), findsOneWidget);
    expect(find.text('Tax & Service'), findsOneWidget);
    expect(find.text('Include extra 18%'), findsOneWidget);
    expect(find.text('Walkable Only'), findsOneWidget);
    expect(find.text('< 15 mins away'), findsOneWidget);
    expect(find.text('FIND IT WITHIN BUDGET'), findsOneWidget);

    // Scroll down to reveal matched results
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify Results section matching wireframe
    expect(find.text('Tasty Matches for Your Crew'), findsOneWidget);
    expect(find.text('3 Spots'), findsOneWidget);
    expect(find.text('Sugar Bloom Cafe & Brunch'), findsWidgets);
    expect(find.text('\$105.00'), findsWidgets);
    expect(find.text('Sweet & savory sharing board with drinks'), findsWidgets);
    expect(find.text('Save \$28 • Pass'), findsWidgets);
    expect(find.text('Loved It'), findsWidgets);

    // Verify clicking FIND IT WITHIN BUDGET navigates to platters
    final findBudgetBtn = find.text('FIND IT WITHIN BUDGET');
    await tester.ensureVisible(findBudgetBtn);
    await tester.pumpAndSettle();
    await tester.tap(findBudgetBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Should now be on Platters screen (redesigned mockup)
    expect(find.byType(PlatterPackagesScreen), findsOneWidget);
    expect(find.text('The Sunset Sliders & Fries Feast'), findsOneWidget);
  });
}
