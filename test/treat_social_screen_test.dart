import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/treat_social_screen.dart';

void main() {
  testWidgets('TreatSocialScreen renders Food Bar Chat (Image 2) and Foodie Groups (Image 3)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool drawerOpened = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: TreatTheme.lightTheme,
        home: TreatSocialScreen(
          onOpenDrawer: () => drawerOpened = true,
          initialTab: 1, // Default to Food Bar Chat
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 1. Verify Top Switcher Tabs (Community Feed and Food Bar Chat)
    expect(find.text('Community Feed'), findsOneWidget);
    expect(find.text('Food Bar Chat'), findsOneWidget);

    // 2. Verify Image 2 Food Bar Chat Items
    expect(find.text('PINNED HOST'), findsOneWidget);
    expect(find.text('Bistro Bella Host'), findsOneWidget);
    expect(find.text('@BobaBandit'), findsOneWidget);
    expect(find.text('Tier 3 Treatie'), findsOneWidget);
    expect(find.text('@TacoFiend'), findsOneWidget);

    // Scroll down to view poll
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('🍜 Spicy Miso Ramen'), findsOneWidget);

    // 3. Test Sending a message in Chat Input Area
    await tester.enterText(
      find.byType(TextField).last,
      'Just grabbed a feast table! Come say hi!',
    );
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Just grabbed a feast table! Come say hi!'), findsOneWidget);

    // 4. Switch to Community Feed (New Mockup UI)
    await tester.tap(find.text('Community Feed'));
    await tester.pumpAndSettle();

    expect(find.text('CRAVING STORIES'), findsOneWidget);
    expect(find.text('Add Craving\nStory'), findsOneWidget);
    expect(find.text('Taco Bodega 🌮'), findsOneWidget);
    expect(find.text('Taco Bodega Grand Feast'), findsOneWidget);
    expect(find.text('CLAIM VOUCHER'), findsOneWidget);
    expect(find.text('Bistro Bella'), findsOneWidget);
    expect(find.text('PARTNER'), findsOneWidget);
    expect(find.text('Artisan Truffle Slice Voucher'), findsOneWidget);
    expect(find.text('NEW POST'), findsOneWidget);

    // 5. Test Drawer Toggle
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(drawerOpened, isTrue);
  });

  testWidgets('TreatSocialScreen renders Foodie Groups when initialTab is 2',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: TreatTheme.lightTheme,
        home: TreatSocialScreen(
          onOpenDrawer: () {},
          initialTab: 2,
          showSwitcher: false,
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('COMMUNITY & SQUADS'), findsOneWidget);
    expect(find.text('Foodie Groups'), findsOneWidget);
    expect(find.text('Late Night Dessert Hunt 🍨'), findsOneWidget);
    expect(find.text('Boba & Gossip Split 🧋'), findsOneWidget);
  });

  testWidgets('TreatSocialScreen renders exact Community Feed panel with all interactive elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool notificationsTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: TreatTheme.lightTheme,
        home: TreatSocialScreen(
          onOpenDrawer: () {},
          onNavigateNotifications: () => notificationsTapped = true,
          initialTab: 0, // Default to Community Feed
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 1. Verify Top Bar: search, chat bubble badge '3', and notification bell
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();
    expect(notificationsTapped, isTrue);

    // 2. Verify Promo Carousel
    expect(find.text('🔥 40% OFF GROUP FEASTS'), findsOneWidget);
    expect(find.text('LIMITED TIME'), findsOneWidget);
    expect(find.text('TREAT40'), findsOneWidget);
    expect(find.text('CLAIM PASS'), findsOneWidget);

    // 3. Verify Post Creator
    expect(find.text("What's on your plate, MidnightDumpling?"), findsOneWidget);
    expect(find.text('Photo'), findsOneWidget);
    expect(find.text('Craving'), findsOneWidget);
    expect(find.text('Spot'), findsOneWidget);
    expect(find.text('Split'), findsOneWidget);

    // 4. Verify Craving Stories
    expect(find.text('CRAVING STORIES'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);
    expect(find.text('Add Craving\nStory'), findsOneWidget);
    expect(find.text('Taco Bodega 🌮'), findsOneWidget);
    expect(find.text('Sugar Bloom 🍨'), findsOneWidget);
    await tester.drag(find.text('Sugar Bloom 🍨'), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(find.text('Bistro Bella 🍕'), findsOneWidget);

    // 5. Verify Post 1 (@TacoFiend)
    expect(find.text('Taco Bodega Grand Feast'), findsOneWidget);
    expect(find.text('CLAIM VOUCHER'), findsOneWidget);
    expect(find.text('🤤 Drooling (84)'), findsOneWidget);
    expect(find.text('🔥 Fire Deal (42)'), findsOneWidget);
    expect(find.text('⚡ Down to Split! (16)'), findsOneWidget);
    expect(find.text('❤️ 31'), findsOneWidget);
    expect(find.text('💬 28 Comments'), findsOneWidget);
    expect(find.text('🔗 9 Shares'), findsOneWidget);
    expect(find.text('Save'), findsWidgets);
    expect(find.text('@SweetTooth_99'), findsOneWidget);

    // Scroll down to bring Post 1 voucher into full view
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -350));
    await tester.pumpAndSettle();

    // Test claiming Post 1 voucher
    await tester.tap(find.text('CLAIM VOUCHER'));
    await tester.pumpAndSettle();
    expect(find.text('CLAIMED ✓'), findsOneWidget);

    // Scroll further down to bring Post 2 into full view
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    // 6. Verify Post 2 (Bistro Bella)
    expect(find.text('Bistro Bella'), findsOneWidget);
    expect(find.text('PARTNER'), findsOneWidget);
    expect(find.text('Artisan Truffle Slice Voucher'), findsOneWidget);
    expect(find.text('CLAIM NOW'), findsOneWidget);

    // Test claiming Post 2 voucher
    await tester.tap(find.text('CLAIM NOW'));
    await tester.pumpAndSettle();
    expect(find.text('CLAIMED ✓'), findsWidgets);

    // Allow snackbar to dismiss
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // 7. Verify FAB & Open Modal
    expect(find.text('NEW POST'), findsOneWidget);
    await tester.tap(find.text('NEW POST'));
    await tester.pumpAndSettle();
    expect(find.text('Create Community Post'), findsOneWidget);
    expect(find.text('Publish Post'), findsOneWidget);
  });
}
