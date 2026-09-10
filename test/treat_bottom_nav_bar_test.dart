import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/widgets/treat_bottom_nav_bar.dart';

void main() {
  testWidgets('TreatBottomNavBar renders 4 options and handles tab selection',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    TreatNavTab selectedTab = TreatNavTab.explore;

    await tester.pumpWidget(
      MaterialApp(
        theme: TreatTheme.lightTheme,
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Center(child: Text('Active: ${selectedTab.name}')),
              bottomNavigationBar: TreatBottomNavBar(
                currentTab: selectedTab,
                onTabSelected: (tab) {
                  setState(() => selectedTab = tab);
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    // 1. Verify all 4 labels are rendered
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Food Bar'), findsOneWidget);
    expect(find.text('Social'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 2. Verify all 4 icons are present
    expect(find.byIcon(Icons.explore), findsOneWidget);
    expect(find.byIcon(Icons.lunch_dining_outlined), findsOneWidget);
    expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);

    // 3. Initial active tab is Explore
    expect(selectedTab, equals(TreatNavTab.explore));

    // 4. Tap 'Food Bar' tab
    await tester.tap(find.text('Food Bar'));
    await tester.pumpAndSettle();
    expect(selectedTab, equals(TreatNavTab.foodBar));
    expect(find.text('Active: foodBar'), findsOneWidget);

    // 5. Tap 'Social' tab
    await tester.tap(find.text('Social'));
    await tester.pumpAndSettle();
    expect(selectedTab, equals(TreatNavTab.social));
    expect(find.text('Active: social'), findsOneWidget);

    // 6. Tap 'Profile' tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(selectedTab, equals(TreatNavTab.profile));
    expect(find.text('Active: profile'), findsOneWidget);

    // 7. Tap 'Explore' tab
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(selectedTab, equals(TreatNavTab.explore));
    expect(find.text('Active: explore'), findsOneWidget);
  });
}
