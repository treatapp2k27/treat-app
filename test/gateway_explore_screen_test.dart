import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treat/screens/diner/gateway_explore_screen.dart';

void main() {
  testWidgets('GatewayExploreScreen renders two diner options and verifies kitchen login is removed',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool guestTapped = false;
    bool foodieSignInTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: GatewayExploreScreen(
          onExploreGuest: () {
            guestTapped = true;
          },
          onFoodieSignInTap: () {
            foodieSignInTapped = true;
          },
        ),
      ),
    );

    await tester.pump();

    // 1. Verify Top Branding & Social Proof
    expect(find.text('Bite-sized feasts & local dining'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('3,400+ foodies exploring'),
      ),
      findsOneWidget,
    );

    // 2. Verify OPTION 1: Explore without sign in
    expect(find.text('Explore Treats'), findsOneWidget);
    expect(find.text('Guest Pass'), findsOneWidget);
    expect(find.text('Live Deals'), findsOneWidget);
    expect(find.text('Explore Without Sign In'), findsOneWidget);

    // 3. Verify OPTION 2: Sign in as Foodie
    expect(find.text('Foodie & Diner Login'), findsOneWidget);
    expect(find.text('Sign In as Foodie'), findsOneWidget);

    // 4. Verify Partner Kitchen Login is completely removed
    expect(find.text('Partner Kitchen Login'), findsNothing);
    expect(find.text('Kitchen Partner Portal'), findsNothing);

    // 5. Test Tap on 'Explore Without Sign In'
    await tester.tap(find.text('Explore Without Sign In'));
    await tester.pump();
    expect(guestTapped, isTrue);

    // 6. Test Tap on 'Sign In as Foodie'
    await tester.tap(find.text('Sign In as Foodie'));
    await tester.pump();
    expect(foodieSignInTapped, isTrue);
  });
}
