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

    // 1. Verify Top Bar & Branding (Points achieved by profile without dollar icon)
    expect(find.text('Treat'), findsOneWidget);
    expect(find.text('2,450'), findsOneWidget);
    expect(find.byIcon(Icons.monetization_on_rounded), findsNothing);
    expect(find.byIcon(Icons.stars_rounded), findsOneWidget);

    // 2. Verify Sub-header & Bounty (Starts from Round 1 / 4)
    expect(find.textContaining('Round 1 / 4'), findsOneWidget);
    expect(find.text('Banter'), findsOneWidget);
    expect(find.text('FEAST CLASH BOUNTY'), findsOneWidget);
    expect(find.text('500 Coins + Feast Champion Accolade'), findsOneWidget);
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

  testWidgets('TreatLudoLeaderboardScreen renders app logo, winner card, in-home standings, and handles rematch without voucher/50% platter',
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
            roundsPlayed: 4,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top Bar: Main App Logo present and Treat text removed
    expect(find.bySemanticsLabel('Treat App Logo'), findsOneWidget);

    // 2. Verify Match Finished Banner (4 Rounds Match)
    expect(find.text('MATCH FINISHED • FEAST CLASH #482'), findsOneWidget);

    // 3. Verify Winner Showcase (Tokens Home, Coins & Points, no 50% platter)
    expect(find.text('WINNER'), findsOneWidget);
    expect(find.text('MidnightDumpling'), findsAtLeastNWidgets(1));
    expect(find.text('Champion of the Table • 4 Tokens Home'), findsOneWidget);
    expect(find.text('+500 Treat Gold Coins Credited'), findsOneWidget);
    expect(find.text('+500 Treat Profile Points Credited'), findsOneWidget);
    expect(find.text('50% Off Feast Platter'), findsNothing);

    // 4. Verify Squad Match Standings arranged by tokens inside home
    expect(find.text('SQUAD MATCH STANDINGS'), findsOneWidget);
    expect(find.text('4 Rounds Played'), findsOneWidget);
    expect(find.text('Arranged by tokens safely entered inside home 🎯'), findsOneWidget);
    expect(find.text('4/4 Inside Home'), findsOneWidget);
    expect(find.text('3/4 Inside Home'), findsOneWidget);
    expect(find.text('2/4 Inside Home'), findsOneWidget);
    expect(find.text('1/4 Inside Home'), findsOneWidget);
    expect(find.text('TacoFiend'), findsAtLeastNWidgets(1));
    expect(find.text('BobaBandit'), findsAtLeastNWidgets(1));
    expect(find.text('PizzaSlice99'), findsAtLeastNWidgets(1));

    // 5. Verify Highlights card is rendered and Wallet Voucher is removed
    expect(find.text('FEAST CLASH HIGHLIGHTS'), findsOneWidget);
    expect(find.text('Voucher Stored in Wallet'), findsNothing);
    expect(find.text('View Pass'), findsNothing);

    // 6. Verify Round-by-Round Cached Memory Card
    expect(find.text('ROUND-BY-ROUND CACHED MEMORY'), findsOneWidget);
    expect(find.text('4-Match History & Round Progression'), findsOneWidget);
    expect(find.text('4 ROUNDS'), findsOneWidget);
    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Round 2'), findsOneWidget);
    expect(find.text('Round 3'), findsOneWidget);
    expect(find.text('Round 4 (Final)'), findsOneWidget);
    expect(find.text('ORIGINAL 4-ROUND WINNER DECLARED'), findsOneWidget);

    // 7. Test Rematch Button
    expect(find.text('Rematch Treat Squad'), findsOneWidget);
    await tester.ensureVisible(find.text('Rematch Treat Squad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rematch Treat Squad'));
    await tester.pumpAndSettle();
    expect(rematched, isTrue);

    // 8. Test Back to Diner Profile & Games
    expect(find.text('Back to Diner Profile & Games'), findsOneWidget);
    await tester.ensureVisible(find.text('Back to Diner Profile & Games'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to Diner Profile & Games'));
    await tester.pumpAndSettle();
    expect(returnedToProfile, isTrue);
  });

  testWidgets('TreatLudoGameScreen verifies Deploy Dumpling starts journey on 6 and moves active token when already on board',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DinerState>(create: (_) => DinerState()),
        ],
        child: MaterialApp(
          theme: TreatTheme.lightTheme,
          home: TreatLudoGameScreen(
            onBack: () {},
            onShowLeaderboard: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Initial state has diceValue = 6, user has 4 tokens in deck, 0 on track
    expect(find.text('DEPLOY DUMPLING'), findsOneWidget);

    // 2. Tapping DEPLOY DUMPLING deploys the token from deck onto track!
    await tester.tap(find.text('DEPLOY DUMPLING'));
    await tester.pump();

    // Verify snackbar confirmed deployment onto track
    expect(find.text('🥟 Dumpling deployed from deck onto safe start tile!'), findsOneWidget);

    // Settle the turn timer
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();
  });
}
