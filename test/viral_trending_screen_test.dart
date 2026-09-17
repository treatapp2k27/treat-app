import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/viral_trending_screen.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('ViralTrendingScreen renders complete panel matching mockup and handles interactions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    dinerState.setFoodieLoggedIn(true);

    bool drawerOpened = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<DinerState>.value(
        value: dinerState,
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: Scaffold(
            body: ViralTrendingScreen(
              onOpenDrawer: () => drawerOpened = true,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top Bar
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // Tap menu button
    await tester.tap(find.byIcon(Icons.menu_rounded));
    expect(drawerOpened, isTrue);

    // 2. Verify Location & Radius Bar
    expect(find.text('Location & Radius'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    // Tap Change to open Select Trending Area modal
    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();

    expect(find.text('Select Trending Area'), findsOneWidget);
    expect(find.text('Preferred Road / Location (Feni Sadar)'), findsOneWidget);
    expect(find.text('+ Explore All 64 BD Districts'), findsOneWidget);
    expect(find.text('SSK Road'), findsOneWidget);
    expect(find.text('Mohipal Road'), findsOneWidget);

    // Tap a road chip (e.g. Mohipal Road)
    await tester.tap(find.text('Mohipal Road'));
    await tester.pumpAndSettle();

    // Tap Apply Location
    await tester.tap(find.text('Apply Location'));
    await tester.pumpAndSettle();

    // Verify modal dismissed and location updated
    expect(find.text('Select Trending Area'), findsNothing);
    expect(dinerState.userLocation, equals('Mohipal Road, Feni Sadar'));

    // 3. Verify Announcement Banner
    expect(find.textContaining('24 Viral Dishes'), findsOneWidget);
    expect(find.textContaining('trending near you right now'), findsOneWidget);

    // 4. Verify Platform Filter Chips
    expect(find.text('All Viral (24)'), findsOneWidget);
    expect(find.text('TikTok (11)'), findsOneWidget);
    expect(find.text('Instagram (8)'), findsOneWidget);
    expect(find.text('Facebook (5)'), findsOneWidget);

    // Tap TikTok filter
    await tester.tap(find.text('TikTok (11)'));
    await tester.pumpAndSettle();

    // 5. Verify Craze Tag Chips
    expect(find.text('🧀 Cheese Pulls'), findsOneWidget);
    expect(find.text('🍧 Mega Desserts'), findsOneWidget);
    expect(find.text('🌮 Street Platters'), findsOneWidget);

    // 6. Verify Card 1: Volcano Sundae
    expect(find.text('Sugar Bloom Cafe • Soho'), findsOneWidget);
    expect(find.text('The Molten Biscoff & Churro Volcano Sundae'), findsOneWidget);
    expect(find.text('@churroqueen'), findsOneWidget);
    expect(find.text('Verified Foodie Creator'), findsOneWidget);
    expect(find.text('Order Platter Pass'), findsOneWidget);
    expect(find.text('£34 pass (33% OFF)'), findsOneWidget);

    // 7. Verify Fresh Social Drops Header
    expect(find.text('Fresh Social Drops'), findsOneWidget);
    expect(find.text('Updated 4m ago'), findsOneWidget);

    // 8. Verify Card 2: Birria Quesataco Platter
    expect(find.text('Cantina Fuego • Old Compton St'), findsOneWidget);
    expect(find.text('Mega 4–Tier Loaded Birria Quesataco Platter'), findsOneWidget);
    expect(find.text('Trending #1 in London this weekend'), findsOneWidget);
    expect(find.text('Claim Table Pass'), findsOneWidget);

    // 9. Verify Card 3: Giant Cheesy Garlic Breadstick Feast
    expect(find.text('Bella Crust Kitchen • Dean St'), findsOneWidget);
    expect(find.text('The 1–Meter Giant Cheesy Garlic Breadstick Feast'), findsOneWidget);
    expect(find.text('"The cheese stretch on this monster is un..."'), findsOneWidget);
    expect(find.text('View Feast 🍴'), findsOneWidget);

    // 10. Verify Card 4: Fluffy Japanese Souffle Pancake Cloud Stack
    expect(find.text('Cloud Nine Bakery • Greek St'), findsOneWidget);
    expect(find.text('Fluffy Japanese Souffle Pancake Cloud Stack'), findsOneWidget);
    expect(find.text('Secret Perk'), findsOneWidget);
    expect(find.text('Get Voucher 🎟'), findsOneWidget);

    // 11. Verify Card 5: Foodie Bounty Banner (scroll down to reveal)
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(find.text('FOODIE BOUNTY'), findsOneWidget);
    expect(find.text('Spot a Viral Craving?'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Instant community review'), findsOneWidget);
    expect(find.text('1,420 dishes added this week'), findsOneWidget);

    // Test entering link and submitting bounty
    await tester.enterText(
      find.widgetWithText(TextField, 'Paste TikTok or Instagram reel link...'),
      'https://tiktok.com/@foodie/video/12345',
    );
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.textContaining('Bounty submitted'), findsOneWidget);
  });
}
