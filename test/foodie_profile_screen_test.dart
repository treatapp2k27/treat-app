import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/foodie_profile_settings_screen.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('FoodieProfileSettingsScreen renders all elevated sections and handles interactions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: dinerState),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: FoodieProfileSettingsScreen(
            onOpenDrawer: () {},
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 1. Verify Hero Profile Card elements
    expect(find.text('ANONYMOUS VIP'), findsOneWidget);
    expect(find.text('#FD-882'), findsOneWidget);
    expect(find.text('MidnightDumpling'), findsOneWidget);
    expect(find.text('@treat_nomad • Foodie Adventurer'), findsOneWidget);
    expect(find.text('Shuffle Persona'), findsOneWidget);
    expect(find.text('VIP PASS LEVEL 2'), findsOneWidget);

    // 2. Verify Treat Wallet & Quick Pay Card
    expect(find.text('Treat Wallet & Quick Pay'), findsOneWidget);
    expect(find.text('Available Balance'), findsOneWidget);
    expect(find.text('+\$10'), findsOneWidget);
    expect(find.text('+\$25'), findsOneWidget);
    expect(find.text('+\$50'), findsOneWidget);
    expect(find.text('Add Funds'), findsOneWidget);

    // Tap quick top-up chip '+$25'
    await tester.tap(find.text('+\$25'));
    await tester.pump();
    expect(dinerState.currentPersona.walletBalance, 70.00); // 45 + 25

    // 3. Verify Taste Radar & Diet Tags
    expect(find.text('Taste Radar & Diet Tags'), findsOneWidget);
    expect(find.text('Spicy Lover'), findsOneWidget);
    expect(find.text('Halal'), findsOneWidget);
    expect(find.text('Vegetarian'), findsOneWidget);

    // 4. Verify Budget & Split Dining
    expect(find.text('Budget & Split Dining'), findsOneWidget);
    expect(find.text('Preferred Squad Size'), findsOneWidget);
    expect(find.text('Auto-Split Bill via Treat Credits'), findsOneWidget);

    // 5. Verify Privacy & Ghosting
    expect(find.text('Privacy & Ghosting'), findsOneWidget);
    expect(find.text('Hide real name completely'), findsOneWidget);
    expect(find.text('Ghost browsing in Food Bar'), findsOneWidget);

    // 6. Verify Live Drop Alerts
    expect(find.text('Live Drop Alerts'), findsOneWidget);
    expect(find.text('Instant Platter Drop Alerts'), findsOneWidget);
    expect(find.text('15-min Table Hold Reminders'), findsOneWidget);

    // 7. Verify Account Actions
    await tester.drag(find.byType(ListView).first, const Offset(0, -800));
    await tester.pump();
    expect(find.text('Switch Active Persona'), findsOneWidget);
    expect(find.text('Export History'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });
}
