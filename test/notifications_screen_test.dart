import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/home_promotions_screen.dart';
import 'package:treat/screens/diner/notifications_screen.dart';
import 'package:treat/screens/diner/platter_packages_screen.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('NotificationsScreen renders wireframe layout, cards, and handles actions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool drawerOpened = false;
    bool navigatedSlip = false;
    bool navigatedLudo = false;
    bool navigatedPlatters = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(
            create: (_) {
              final state = DinerState();
              state.setFoodieLoggedIn(true);
              return state;
            },
          ),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: NotificationsScreen(
            onOpenDrawer: () => drawerOpened = true,
            onNavigateSlip: () => navigatedSlip = true,
            onNavigateLudo: () => navigatedLudo = true,
            onNavigatePlatters: () => navigatedPlatters = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Header Elements
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('3 New'), findsOneWidget);
    expect(find.text('Mark all\nread'), findsOneWidget);

    // 2. Verify Filter Category Pills
    expect(find.text('All (5)'), findsOneWidget);
    expect(find.text('Platters & Feasts'), findsOneWidget);
    expect(find.text('Squad & Ludo'), findsOneWidget);
    expect(find.text('Flash Drops'), findsOneWidget);
    expect(find.text('Receipts'), findsOneWidget);

    // 3. Verify Notification Cards
    // Card 1: Feast Alert
    expect(find.text('Sugar Bloom Cafe accepted your feast request!'), findsOneWidget);
    expect(find.text('View Digital Slip'), findsOneWidget);

    // Card 2: Squad Ludo
    expect(find.text('BobaBandit challenged you to Treat Squad Ludo!'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
    expect(find.text('Play Now 🎲'), findsOneWidget);

    // Card 3: Flash Drop
    expect(find.text('Neon Glaze Fiesta Platter dropped 50% OFF nearby'), findsOneWidget);
    expect(find.text('Claim Deal'), findsOneWidget);
    expect(find.text('Loved It'), findsOneWidget);

    // Card 4: Receipt
    expect(find.text('Voucher #TR-8820 redeemed successfully'), findsOneWidget);
    expect(find.text('View Receipt'), findsOneWidget);

    // Card 5: Community
    expect(find.text('TacoFiend and 4 others reacted to your Food Bar post'), findsOneWidget);
    expect(find.text('Reply'), findsOneWidget);

    // 4. Verify Notification Preferences Card
    expect(find.text('Notification Preferences'), findsOneWidget);
    expect(find.text('Turn on Platter Radar to never miss 50%...'), findsOneWidget);

    // 5. Test Button Interactions
    await tester.tap(find.text('View Digital Slip'));
    expect(navigatedSlip, isTrue);

    await tester.tap(find.text('Play Now 🎲'));
    expect(navigatedLudo, isTrue);

    await tester.tap(find.text('Claim Deal'));
    expect(navigatedPlatters, isTrue);

    // 6. Test Mark All Read
    await tester.tap(find.text('Mark all\nread'));
    await tester.pumpAndSettle();
    expect(find.text('3 New'), findsNothing);

    // 7. Test Filter category switching
    await tester.tap(find.text('Platters & Feasts'));
    await tester.pumpAndSettle();
    expect(find.text('Sugar Bloom Cafe accepted your feast request!'), findsOneWidget);
    expect(find.text('BobaBandit challenged you to Treat Squad Ludo!'), findsNothing);
    expect(find.text('Voucher #TR-8820 redeemed successfully'), findsNothing);
  });

  testWidgets('Notifications icon is REMOVED from Explore without sign in homepage and platter packages',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final guestDinerState = DinerState();
    guestDinerState.setFoodieLoggedIn(false);

    // 1. Check HomePromotionsScreen in Explore Without Sign In mode
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: guestDinerState),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: HomePromotionsScreen(
            onOpenDrawer: () {},
            onSelectDeal: (_) {},
            onNavigateBudgetPlanner: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    // Notification bell icon MUST NOT be present on guest homepage
    expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
    expect(find.byIcon(Icons.notifications_rounded), findsNothing);
    expect(find.byIcon(Icons.notifications), findsNothing);

    // 2. Check PlatterPackagesScreen in Explore Without Sign In mode
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: guestDinerState),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: PlatterPackagesScreen(
            onOpenDrawer: () {},
            onSelectPlatter: (_) {},
            onEditBudget: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    // Notification icon MUST NOT be present in PlatterPackagesScreen when not signed in
    expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);

    // 3. Now check HomePromotionsScreen with Foodie Login (logged in)
    final foodieDinerState = DinerState();
    foodieDinerState.setFoodieLoggedIn(true);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: foodieDinerState),
          ChangeNotifierProvider<BudgetPlannerState>(create: (_) => BudgetPlannerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: HomePromotionsScreen(
            onOpenDrawer: () {},
            onSelectDeal: (_) {},
            onNavigateBudgetPlanner: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    // Notification bell icon MUST be present for logged-in Foodie
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}
