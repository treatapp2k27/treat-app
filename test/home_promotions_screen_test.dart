import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/screens/diner/home_promotions_screen.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/treat_header.dart';

void main() {
  testWidgets('HomePromotionsScreen renders all sections from HTML wireframe and handles interactions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool drawerOpened = false;
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
            onSelectDeal: (deal) => selectedDeal = deal,
            onNavigateBudgetPlanner: () => budgetPlannerNavigated = true,
          ),
        ),
      ),
    );

    await tester.pump();

    // 1. Verify Header Elements
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('TREAT'), findsOneWidget);

    // 2. Verify Filter Chips
    expect(find.text('Trending Treats'), findsOneWidget);
    expect(find.text('Group Feasts'), findsOneWidget);
    expect(find.text('Mega Deals'), findsOneWidget);

    // 3. Verify Section 1: Hottest Promotions
    expect(find.text('Hottest Promotions'), findsOneWidget);
    expect(find.text('POPULAR'), findsOneWidget);
    expect(find.text('Neon Glaze Fiesta Platter'), findsOneWidget);
    expect(find.text('35% Off Squad Crunch Bar'), findsOneWidget);

    // 4. Verify Section 2: Exclusive Vouchers
    expect(find.text('Exclusive Vouchers'), findsOneWidget);
    expect(find.text('TAP TO COPY'), findsOneWidget);
    expect(find.text('50% Off First Treat'), findsOneWidget);
    expect(find.text('TREAT50'), findsOneWidget);
    expect(find.text('\$20 Weekend Chill'), findsOneWidget);
    expect(find.text('WEEKENDVIBE'), findsOneWidget);

    // 5. Test Copy Voucher Interaction
    await tester.tap(find.text('TREAT50'));
    await tester.pump();
    expect(find.text('COPIED!'), findsOneWidget);

    // Test Claim Deal Callback
    await tester.tap(find.text('Claim'));
    await tester.pump();
    expect(selectedDeal, isNotNull);

    // Test Action Button (Treat Header celebration button)
    await tester.tap(find.descendant(
      of: find.byType(TreatHeader),
      matching: find.byIcon(Icons.celebration),
    ));
    await tester.pump();
    expect(budgetPlannerNavigated, isTrue);

    // 6. Verify Section 3: Featured Group Feast Spots
    expect(find.text('Featured Group Feast Spots'), findsOneWidget);
    expect(find.text('Sprinkle & Sizzle Social'), findsOneWidget);
    expect(find.text('Sugar Smash & Patty Lounge'), findsOneWidget);

    // 7. Verify Section 4: Gamified Loyalty Perks Banner
    expect(find.text("Mia's Sweet Treat Perks"), findsOneWidget);
    expect(find.text('Spin Wheel 🎡'), findsOneWidget);

    // 8. Test Spin Wheel Modal
    await tester.tap(find.text('Spin Wheel 🎡'));
    await tester.pumpAndSettle();
    expect(find.text('🎡 Sweet Treat Wheel'), findsOneWidget);
    expect(find.text('Spin Now!'), findsOneWidget);

    // Close modal
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('🎡 Sweet Treat Wheel'), findsNothing);

    // 9. Test Header Drawer Tap
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(drawerOpened, isTrue);
  });
}
