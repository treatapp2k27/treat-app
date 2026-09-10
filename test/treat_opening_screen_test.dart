import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treat/screens/diner/treat_opening_screen.dart';
import 'package:treat/widgets/treat_map_loading_track.dart';

void main() {
  testWidgets('TreatOpeningScreen renders all branding, loading track, and triggers continue',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool continued = false;

    await tester.pumpWidget(
      MaterialApp(
        home: TreatOpeningScreen(
          autoContinue: false,
          onContinue: () {
            continued = true;
          },
        ),
      ),
    );

    // Initial pump
    await tester.pump();

    // Verify TreatMapLoadingTrack is present
    expect(find.byType(TreatMapLoadingTrack), findsOneWidget);

    // Verify Skip / Continue button is present
    expect(find.text('Finding sweet treats near you...'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap Skip
    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(continued, isTrue);
  });
}
