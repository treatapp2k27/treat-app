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

    // 4. Switch to Community Feed / Foodie Groups Tab (Image 3)
    await tester.tap(find.text('Community Feed'));
    await tester.pumpAndSettle();

    expect(find.text('COMMUNITY & SQUADS'), findsOneWidget);
    expect(find.text('Foodie Groups'), findsOneWidget);
    expect(find.text('Late Night Dessert Hunt 🍨'), findsOneWidget);
    expect(find.text('Boba & Gossip Split 🧋'), findsOneWidget);
    expect(find.text('All Groups (12)'), findsOneWidget);

    // 5. Test Drawer Toggle
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(drawerOpened, isTrue);
  });
}
