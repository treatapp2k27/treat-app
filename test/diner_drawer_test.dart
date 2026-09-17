import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/diner_drawer.dart';

void main() {
  testWidgets('DinerDrawer renders redesigned header, badges, minigame, and handles logout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    dinerState.setFoodieLoggedIn(true);

    String? navigatedRoute;
    bool loggedOut = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<DinerState>.value(
        value: dinerState,
        child: MaterialApp(
          home: Scaffold(
            drawer: Builder(
              builder: (ctx) => DinerDrawer(
                onNavigate: (route) {
                  navigatedRoute = route;
                  Navigator.of(ctx).pop();
                },
                onLogOut: () {
                  loggedOut = true;
                },
              ),
            ),
            body: Builder(
              builder: (ctx) => TextButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                child: const Text('Open Drawer'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // 1. Verify Top Profile Section
    expect(find.text(dinerState.currentPersona.handle), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsWidgets);
    expect(find.text('View Profile'), findsOneWidget);

    // Verify Badges below profile name
    expect(find.text('Foodie Adventurer'), findsOneWidget);
    expect(find.text('Level ${dinerState.currentPersona.vipLevel} Explorer'), findsOneWidget);
    expect(find.text('${dinerState.currentPersona.treatsClaimed} Treats Claimed'), findsOneWidget);

    // 2. Verify Page Navigation Items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Trending'), findsOneWidget);
    expect(find.text('Treat'), findsOneWidget);
    expect(find.text('Social'), findsOneWidget);
    expect(find.text('Groups'), findsOneWidget);
    expect(find.text('Reviews'), findsOneWidget);

    // Test Reviews navigation
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();
    expect(navigatedRoute, equals('reviews'));

    // Re-open drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // 3. Test View Profile Tap
    await tester.tap(find.text('View Profile'));
    await tester.pumpAndSettle();
    expect(navigatedRoute, equals('profile'));

    // Re-open drawer for minigame and logout tests
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // 4. Verify Squad Minigame is in sidebar below page options
    expect(find.text("Mia's Sweet Treat Perks"), findsOneWidget);
    expect(find.text('Play Squad Ludo 🎲'), findsOneWidget);

    // Scroll to see the minigame button if needed
    await tester.ensureVisible(find.text('Play Squad Ludo 🎲'));
    await tester.pumpAndSettle();

    // Tap Play Squad Ludo to open minigame modal
    await tester.tap(find.text('Play Squad Ludo 🎲'));
    await tester.pumpAndSettle();

    expect(find.text('🎲 Treat Squad Ludo'), findsOneWidget);
    expect(find.text('Roll Dice! 🎲'), findsOneWidget);

    // Roll the dice in the modal
    await tester.tap(find.text('Roll Dice! 🎲'));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Close the modal
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('🎲 Treat Squad Ludo'), findsNothing);

    // 5. Test Log Out Button
    await tester.ensureVisible(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Log Out'), findsOneWidget);

    await tester.tap(find.text('Log Out'));
    await tester.pump();
    expect(loggedOut, isTrue);
  });
}
