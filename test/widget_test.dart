import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/app_shell.dart';
import 'package:treat/state/booking_state.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/state/kitchen_partner_state.dart';

void main() {
  testWidgets('AppShell renders Welcome Anonymous screen and allows navigation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
          ChangeNotifierProvider<BookingState>(create: (_) => BookingState()),
          ChangeNotifierProvider<KitchenPartnerState>(create: (_) => KitchenPartnerState()),
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
    expect(find.text('Hottest Promotions'), findsOneWidget);
    expect(find.text('Trending Treats'), findsOneWidget);
  });
}
