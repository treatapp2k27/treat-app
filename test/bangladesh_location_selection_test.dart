import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/models/bangladesh_locations.dart';
import 'package:treat/screens/diner/home_promotions_screen.dart';
import 'package:treat/state/budget_planner_state.dart';
import 'package:treat/state/diner_state.dart';
import 'package:treat/widgets/bangladesh_location_picker_dialog.dart';

void main() {
  group('Bangladesh Locations Data Model', () {
    test('contains all 64 districts and default Feni Sadar', () {
      expect(BangladeshLocations.allDistricts.length, equals(64));
      expect(BangladeshLocations.allDistricts.contains('Feni'), isTrue);
      expect(BangladeshLocations.allDistricts.contains('Dhaka'), isTrue);
      expect(BangladeshLocations.allDistricts.contains('Chattogram'), isTrue);
      expect(BangladeshLocations.allDistricts.contains('Sylhet'), isTrue);

      expect(BangladeshLocations.defaultDistrict, equals('Feni'));
      expect(BangladeshLocations.defaultUpazila, equals('Feni Sadar'));
    });

    test('contains all required preferable roads under Feni Sadar', () {
      final roads = BangladeshLocations.feniSadarRoads;
      expect(roads.contains('Mizan Road'), isTrue);
      expect(roads.contains('SSK Road'), isTrue);
      expect(roads.contains('Hospital Road'), isTrue);
      expect(roads.contains('Doctorpara Road'), isTrue);
      expect(roads.contains('Mohipal Road'), isTrue);
      expect(roads.contains('Trunk Road'), isTrue);
      expect(roads.contains('Masterpara Road'), isTrue);
      expect(roads.contains('Najir Road'), isTrue);
      expect(roads.contains('Hazari Road'), isTrue);
    });
  });

  group('Homepage Topbar Map & Quick Road Selection', () {
    testWidgets('renders topbar map design and quick road selection buttons on Homepage',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(500, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final dinerState = DinerState();
      dinerState.setFoodieLoggedIn(true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DinerState>.value(value: dinerState),
            ChangeNotifierProvider<BudgetPlannerState>(
                create: (_) => BudgetPlannerState()),
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

      // 1. Verify Topbar Map Location Elements
      expect(find.text('CHANGE'), findsOneWidget);
      expect(find.text('Within 2 mi'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsAtLeastNWidgets(1));

      // 2. Verify Quick Road Strip under Topbar
      expect(find.text('Feni Sadar Roads:'), findsOneWidget);
      expect(find.text('SSK Road'), findsAtLeastNWidgets(1));
      expect(find.text('Mizan Road'), findsAtLeastNWidgets(1));

      // 3. Tap on 'Mizan Road' chip right on the Homepage (well within 500px width)
      await tester.tap(find.text('Mizan Road').first);
      await tester.pumpAndSettle();

      // Verify dinerState user location updated
      expect(dinerState.userLocation, equals('Mizan Road, Feni Sadar'));
      expect(find.text('Mizan Road, Feni Sadar'), findsOneWidget);

      // 4. Open Full Location Selection Modal by tapping CHANGE
      await tester.tap(find.text('CHANGE'));
      await tester.pumpAndSettle();

      expect(find.byType(BangladeshLocationPickerDialog), findsOneWidget);
      expect(find.text('Change Location'), findsOneWidget);
      expect(find.text('Preferable Roads in Feni Sadar'), findsOneWidget);

      // Verify all required road buttons are present in modal
      expect(find.text('Doctorpara Road'), findsOneWidget);
      expect(find.text('Mohipal Road'), findsOneWidget);
      expect(find.text('Trunk Road'), findsOneWidget);
      expect(find.text('Hospital Road'), findsOneWidget);
      expect(find.text('Masterpara Road'), findsOneWidget);
      expect(find.text('Najir Road'), findsOneWidget);
      expect(find.text('Hazari Road'), findsOneWidget);

      // 6. Tap 'Doctorpara Road' button in modal
      await tester.tap(find.text('Doctorpara Road'));
      await tester.pumpAndSettle();

      // Modal closes and location is updated
      expect(dinerState.userLocation, equals('Doctorpara Road, Feni Sadar'));
      expect(find.text('Doctorpara Road, Feni Sadar'), findsOneWidget);
    });
  });
}
