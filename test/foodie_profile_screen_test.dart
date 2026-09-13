import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/foodie_profile_settings_screen.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('FoodieProfileSettingsScreen renders exact redesigned wireframe and handles interactions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final dinerState = DinerState();
    bool loggedOut = false;
    bool drawerOpened = false;
    bool profileRedirected = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>.value(value: dinerState),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: FoodieProfileSettingsScreen(
            onOpenDrawer: () => drawerOpened = true,
            onNavigateProfile: () => profileRedirected = true,
            onLogOut: () => loggedOut = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top App Bar (Left Sidebar hamburger menu, Title, Notifications, Profile Redirect)
    expect(find.text('TREATS & CO'), findsOneWidget);
    expect(find.text('Community Treats'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byTooltip('Profile Settings'), findsOneWidget);

    // Test tapping Left Sidebar hamburger menu
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(drawerOpened, isTrue);

    // Test tapping Profile Avatar to redirect
    await tester.tap(find.byTooltip('Profile Settings'));
    await tester.pumpAndSettle();
    expect(profileRedirected, isTrue);

    // 2. Verify Hero Profile Card elements
    expect(find.text('MidnightDumpling'), findsAtLeastNWidgets(1));
    expect(find.text('#FD-882'), findsOneWidget);
    expect(find.text('@treat_nomad'), findsAtLeastNWidgets(1));
    expect(find.text('VIP Level 2'), findsOneWidget);
    expect(find.text('34 Treats Claimed'), findsOneWidget);
    expect(find.text('Switch Persona'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    // 3. Verify ACCOUNT & PERSONA section
    expect(find.text('ACCOUNT & PERSONA'), findsOneWidget);
    expect(find.text('Display Persona'), findsOneWidget);
    expect(find.text('Anonymous Mode'), findsOneWidget);
    expect(find.text('Hide real name on public food tables'), findsOneWidget);
    expect(find.text('Dietary Preferences'), findsOneWidget);

    // 4. Verify PREFERENCES & DINING section
    expect(find.text('PREFERENCES & DINING'), findsOneWidget);
    expect(find.text('Target Spend per Diner'), findsOneWidget);
    expect(find.text('Default Squad Size'), findsOneWidget);

    // 5. Verify TREAT SQUAD & GAMES section
    expect(find.text('TREAT SQUAD & GAMES'), findsOneWidget);
    expect(find.text('4-Player Live'), findsOneWidget);
    expect(find.text('Treat Squad Ludo'), findsOneWidget);
    expect(find.text('Live Squad Rooms'), findsOneWidget);
    expect(find.text('Play Squad Ludo'), findsOneWidget);

    // 6. Verify PRIVACY & DISCOVERY section
    expect(find.text('PRIVACY & DISCOVERY'), findsOneWidget);
    expect(find.text('Ghost Browsing in Food Bar'), findsOneWidget);
    expect(find.text('Direct Squad Invites'), findsOneWidget);
    expect(find.text('Neighborhood Location Sharing'), findsOneWidget);

    // 7. Verify NOTIFICATIONS section
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('Platter Drops & Deal Radar'), findsOneWidget);

    // 8. Verify Bottom Action Buttons
    expect(find.text('Export Dining History'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // 9. Test Tap 'Edit' to open Edit Persona modal
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Display Persona'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 10. Test Tap 'Switch Persona' to open persona modal
    await tester.tap(find.text('Switch Persona'));
    await tester.pumpAndSettle();
    expect(find.text('Switch Active Persona'), findsOneWidget);
    await tester.tap(find.text('Shuffle'));
    await tester.pumpAndSettle();

    // 11. Test Tap 'Play Squad Ludo' to open Ludo modal
    await tester.tap(find.text('Play Squad Ludo'));
    await tester.pumpAndSettle();
    expect(find.text('Roll Dice! 🎲'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // 12. Test Tap 'Export Dining History'
    await tester.tap(find.text('Export Dining History'));
    await tester.pumpAndSettle();
    expect(find.text('treat_diner_pass_history_2026.csv\n• 34 Verified Treats Claimed\n• \$185 Total Community Savings\n• Zero PII Disclosed'), findsOneWidget);
    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();

    // 13. Test Tap 'Log Out'
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Log Out of Foodie?'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log Out'));
    await tester.pumpAndSettle();
    expect(loggedOut, isTrue);
  });
}
