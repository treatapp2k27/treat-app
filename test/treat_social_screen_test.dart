import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/treat_social_screen.dart';

void main() {
  testWidgets('TreatSocialScreen renders feed, live chat, and savings leaderboard',
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
        ),
      ),
    );

    await tester.pump();

    // 1. Verify Header & Segment Tabs
    expect(find.text('Community Feed'), findsOneWidget);
    expect(find.text('Food Bar Chat'), findsOneWidget);
    expect(find.text('Savings Wall'), findsOneWidget);

    // 2. Verify Feed Posts
    expect(find.text('Live Foodie Savings Pulse'), findsOneWidget);
    expect(find.text('MidnightDumpling'), findsOneWidget);
    expect(find.text('TacoFiend'), findsOneWidget);

    // 3. Test Like Interaction
    final likeFinder = find.byIcon(Icons.favorite).first;
    expect(likeFinder, findsOneWidget);
    await tester.tap(likeFinder);
    await tester.pump();

    // 4. Switch to Live Food Bar Chat Tab
    await tester.tap(find.text('Food Bar Chat'));
    await tester.pumpAndSettle();

    expect(find.text('Live Town Foodie Chat • 128 foodies online'), findsOneWidget);
    expect(find.text('Anyone at Sugar Smash right now? Is the line long?'), findsOneWidget);

    // 5. Test Sending a Message in Live Chat
    await tester.enterText(
      find.byType(TextField).last,
      'Just grabbed a feast table! Come say hi!',
    );
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
    expect(find.text('Just grabbed a feast table! Come say hi!'), findsOneWidget);

    // 6. Switch to Savings Wall Tab
    await tester.tap(find.text('Savings Wall'));
    await tester.pumpAndSettle();

    expect(find.text('Foodie Savings Champions'), findsOneWidget);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);
    expect(find.text('#3'), findsOneWidget);

    // 7. Test Drawer Toggle
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(drawerOpened, isTrue);
  });
}
