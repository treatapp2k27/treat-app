import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/theme/treat_theme.dart';
import 'package:treat/screens/diner/treat_ludo_game_screen.dart';
import 'package:treat/screens/diner/treat_ludo_leaderboard_screen.dart';
import 'package:treat/state/diner_state.dart';

void main() {
  testWidgets('TreatLudoGameScreen renders 4-player board, header, bounty banner, and action console',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool backed = false;
    bool leaderboardShown = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: TreatLudoGameScreen(
            onBack: () => backed = true,
            onShowLeaderboard: () => leaderboardShown = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top Bar & Branding
    expect(find.text('Treat'), findsOneWidget);
    expect(find.text('2,450'), findsOneWidget);

    // 2. Verify Sub-header & Bounty
    expect(find.textContaining('Round 4 / 15'), findsOneWidget);
    expect(find.text('Banter'), findsOneWidget);
    expect(find.text('FEAST CLASH BOUNTY'), findsOneWidget);
    expect(find.text('500 Coins + 50% Off Platter'), findsOneWidget);
    expect(find.text('4 PLAYERS'), findsOneWidget);

    // 3. Verify Bottom Action Console
    expect(find.text('MidnightDumpling'), findsOneWidget);
    expect(find.text('YOU'), findsAtLeastNWidgets(1));
    expect(find.text('Auto!'), findsOneWidget);
    expect(find.text('DEPLOY DUMPLING'), findsOneWidget);
    expect(find.text('Roll Bonus Turn'), findsOneWidget);

    // 4. Test shouting
    expect(find.text('🔥 HURRY!'), findsOneWidget);
    await tester.tap(find.text('🔥 HURRY!'));
    await tester.pump();
    expect(find.text('🔥 HURRY!'), findsAtLeastNWidgets(1));

    // 5. Test Deploying Dumpling
    await tester.tap(find.text('DEPLOY DUMPLING'));
    await tester.pump();

    // 6. Test Show Live Squad Standings shortcut
    await tester.tap(find.text('View Live Squad Standings'));
    await tester.pumpAndSettle();
    expect(leaderboardShown, isTrue);

    // 7. Test Back Button
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(backed, isTrue);
  });

  testWidgets('TreatLudoLeaderboardScreen renders winner card, standings, wallet voucher, and handles rematch',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    bool rematched = false;
    bool returnedToProfile = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: TreatLudoLeaderboardScreen(
            onBack: () {},
            onRematch: () => rematched = true,
            onBackToProfile: () => returnedToProfile = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Match Finished Banner
    expect(find.text('MATCH FINISHED • FEAST CLASH #482'), findsOneWidget);

    // 2. Verify Winner Showcase
    expect(find.text('WINNER'), findsOneWidget);
    expect(find.text('MidnightDumpling'), findsAtLeastNWidgets(1));
    expect(find.text('Champion of the Table • 4 Tokens Home'), findsOneWidget);
    expect(find.text('50% Off Feast Platter'), findsOneWidget);
    expect(find.text('+500 Treat Gold Coins Credited'), findsOneWidget);

    // 3. Verify Squad Match Standings
    expect(find.text('SQUAD MATCH STANDINGS'), findsOneWidget);
    expect(find.text('15 Rounds Played'), findsOneWidget);
    expect(find.text('TacoFiend'), findsOneWidget);
    expect(find.text('BobaBandit'), findsOneWidget);
    expect(find.text('PizzaSlice99'), findsOneWidget);

    // 4. Verify Wallet Voucher Card
    expect(find.text('Voucher Stored in Wallet'), findsOneWidget);
    expect(find.text('View Pass'), findsOneWidget);

    // 5. Test Rematch Button
    expect(find.text('Rematch Treat Squad'), findsOneWidget);
    await tester.ensureVisible(find.text('Rematch Treat Squad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rematch Treat Squad'));
    await tester.pumpAndSettle();
    expect(rematched, isTrue);

    // 6. Test Back to Diner Profile & Games
    expect(find.text('Back to Diner Profile & Games'), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Diner Profile & Games'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to Diner Profile & Games'));
    await tester.pumpAndSettle();
    expect(returnedToProfile, isTrue);
  });
}
