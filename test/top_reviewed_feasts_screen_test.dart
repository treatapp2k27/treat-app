import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/models/platter_deal.dart';
import 'package:treat/screens/diner/top_reviewed_feasts_screen.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('TopReviewedFeastsScreen renders complete UI matching mockup without errors',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    dinerState.setFoodieLoggedIn(true);

    bool drawerOpened = false;
    PlatterDeal? selectedDeal;
    bool profileOpened = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<DinerState>.value(
        value: dinerState,
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: Scaffold(
            body: TopReviewedFeastsScreen(
              onOpenDrawer: () => drawerOpened = true,
              onSelectDeal: (deal) => selectedDeal = deal,
              onNavigateProfile: () => profileOpened = true,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top Main Navbar
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // Tap menu button
    await tester.tap(find.byIcon(Icons.menu_rounded));
    expect(drawerOpened, isTrue);

    // 2. Verify Header and Badges
    expect(find.text('Top Reviewed Feasts'), findsOneWidget);
    expect(find.text('500+ Verified'), findsOneWidget);
    expect(find.text('Ranked by Diners'), findsOneWidget);

    // 3. Verify Filter Tabs
    expect(find.text('All Top Rated ★ 4.9+'), findsOneWidget);
    expect(find.text('Best Value Feasts'), findsOneWidget);

    // Tap 'Best Value Feasts' filter
    await tester.tap(find.text('Best Value Feasts'));
    await tester.pumpAndSettle();

    // Tap back to 'All Top Rated ★ 4.9+'
    await tester.tap(find.text('All Top Rated ★ 4.9+'));
    await tester.pumpAndSettle();

    // 4. Verify Sorting Row
    expect(find.text('Sorted by: Most & Highest Reviewed (500+)'), findsOneWidget);
    expect(find.text('Live Updates'), findsOneWidget);

    // 5. Verify Hero Card (#1 Community Choice)
    expect(find.text('#1 Community Choice'), findsOneWidget);
    expect(find.textContaining('4.98'), findsOneWidget);
    expect(find.text('Mega Fiesta Sizzle Platter'), findsOneWidget);
    expect(find.text('Soho Quarter • 0.3 mi'), findsOneWidget);
    expect(find.text('Feast for 3–4'), findsOneWidget);
    expect(find.text('\$45.00'), findsOneWidget);
    expect(find.text('\$15.00/person'), findsOneWidget);
    expect(find.textContaining('Squad Satisfaction'), findsOneWidget);
    expect(find.textContaining('The pulled brisket and churro combo blew our squad away'), findsOneWidget);
    expect(find.textContaining('@TacoFiend'), findsOneWidget);

    // Tap Loved It button on hero card
    expect(find.text('Loved It'), findsWidgets);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Loved It').first);
    await tester.pumpAndSettle();

    // Tap Select This Platter button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Select This Platter').first);
    await tester.pumpAndSettle();
    expect(selectedDeal, isNotNull);

    // 6. Verify Hall of Fame Section & Platters
    // Scroll down to see Hall of Fame cards below the hero
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Hall of Fame Platters'), findsOneWidget);
    expect(find.text('Molten Biscoff Churro Volcano'), findsOneWidget);
    expect(find.text('Sugar Bloom Cafe'), findsOneWidget);
    expect(find.text('Trending #1 Dessert'), findsOneWidget);
    expect(find.textContaining('4.95'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Supreme Seafood Snack Bucket'), findsOneWidget);
    expect(find.text('Ocean Catch Lounge'), findsOneWidget);
    expect(find.text('Best Group Sharing'), findsOneWidget);
    expect(find.textContaining('4.92'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('1-Meter Giant Cheesy Breadstick'), findsOneWidget);
    expect(find.text('Bella Crust Kitchen'), findsOneWidget);
    expect(find.text('Viral Cheese Pull'), findsOneWidget);
    expect(find.textContaining('4.90'), findsOneWidget);

    // 7. Verify Verified Diner Reviews Guarantee Box
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('★ 100% Verified Diner Reviews'), findsOneWidget);
    expect(
      find.text('All reviews and star ratings are authentic and submitted only after completed Treat table visits.'),
      findsOneWidget,
    );
  });
}
