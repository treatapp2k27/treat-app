import 'package:flutter/material.dart';

/// Represents a single player's score and activity in an individual round
class LudoRoundScore {
  final int roundNumber;
  final String playerName;
  final String emoji;
  final int diceRoll;
  final int stepsMoved;
  final int tokensHome;
  final int roundPoints;

  const LudoRoundScore({
    required this.roundNumber,
    required this.playerName,
    required this.emoji,
    required this.diceRoll,
    required this.stepsMoved,
    required this.tokensHome,
    required this.roundPoints,
  });
}

/// Represents the cached memory of an entire round across all 4 players
class LudoRoundMemory {
  final int roundNumber;
  final List<LudoRoundScore> playerScores;
  final String highlight;

  const LudoRoundMemory({
    required this.roundNumber,
    required this.playerScores,
    required this.highlight,
  });

  static List<LudoRoundMemory> get defaultFourRoundHistory => [
        const LudoRoundMemory(
          roundNumber: 1,
          playerScores: [
            LudoRoundScore(roundNumber: 1, playerName: 'MidnightDumpling', emoji: '🥟', diceRoll: 6, stepsMoved: 13, tokensHome: 1, roundPoints: 150),
            LudoRoundScore(roundNumber: 1, playerName: 'TacoFiend', emoji: '🌮', diceRoll: 6, stepsMoved: 10, tokensHome: 1, roundPoints: 130),
            LudoRoundScore(roundNumber: 1, playerName: 'BobaBandit', emoji: '🧋', diceRoll: 4, stepsMoved: 4, tokensHome: 0, roundPoints: 40),
            LudoRoundScore(roundNumber: 1, playerName: 'PizzaSlice99', emoji: '🍕', diceRoll: 3, stepsMoved: 0, tokensHome: 0, roundPoints: 20),
          ],
          highlight: 'Round 1: 🥟 Dumpling and 🌮 Taco rolled 6s and deployed onto the track!',
        ),
        const LudoRoundMemory(
          roundNumber: 2,
          playerScores: [
            LudoRoundScore(roundNumber: 2, playerName: 'MidnightDumpling', emoji: '🥟', diceRoll: 5, stepsMoved: 15, tokensHome: 2, roundPoints: 260),
            LudoRoundScore(roundNumber: 2, playerName: 'TacoFiend', emoji: '🌮', diceRoll: 4, stepsMoved: 14, tokensHome: 1, roundPoints: 170),
            LudoRoundScore(roundNumber: 2, playerName: 'BobaBandit', emoji: '🧋', diceRoll: 6, stepsMoved: 13, tokensHome: 1, roundPoints: 150),
            LudoRoundScore(roundNumber: 2, playerName: 'PizzaSlice99', emoji: '🍕', diceRoll: 6, stepsMoved: 6, tokensHome: 0, roundPoints: 70),
          ],
          highlight: 'Round 2: 🥟 Dumpling safely guided 2nd token into Home base!',
        ),
        const LudoRoundMemory(
          roundNumber: 3,
          playerScores: [
            LudoRoundScore(roundNumber: 3, playerName: 'MidnightDumpling', emoji: '🥟', diceRoll: 6, stepsMoved: 14, tokensHome: 3, roundPoints: 380),
            LudoRoundScore(roundNumber: 3, playerName: 'TacoFiend', emoji: '🌮', diceRoll: 5, stepsMoved: 13, tokensHome: 2, roundPoints: 290),
            LudoRoundScore(roundNumber: 3, playerName: 'BobaBandit', emoji: '🧋', diceRoll: 5, stepsMoved: 13, tokensHome: 2, roundPoints: 250),
            LudoRoundScore(roundNumber: 3, playerName: 'PizzaSlice99', emoji: '🍕', diceRoll: 4, stepsMoved: 13, tokensHome: 1, roundPoints: 160),
          ],
          highlight: 'Round 3: Heated clash! 🌮 Taco and 🧋 Boba neck and neck behind Dumpling.',
        ),
        const LudoRoundMemory(
          roundNumber: 4,
          playerScores: [
            LudoRoundScore(roundNumber: 4, playerName: 'MidnightDumpling', emoji: '🥟', diceRoll: 6, stepsMoved: 13, tokensHome: 4, roundPoints: 500),
            LudoRoundScore(roundNumber: 4, playerName: 'TacoFiend', emoji: '🌮', diceRoll: 4, stepsMoved: 10, tokensHome: 3, roundPoints: 360),
            LudoRoundScore(roundNumber: 4, playerName: 'BobaBandit', emoji: '🧋', diceRoll: 3, stepsMoved: 8, tokensHome: 2, roundPoints: 280),
            LudoRoundScore(roundNumber: 4, playerName: 'PizzaSlice99', emoji: '🍕', diceRoll: 2, stepsMoved: 5, tokensHome: 1, roundPoints: 190),
          ],
          highlight: 'Final Round 4: 🥟 Dumpling scores 4/4 inside home to lock in the championship!',
        ),
      ];
}

/// Represents a single player's finish standing in a Treat Ludo Feast Clash match.
class LudoPlayerStanding {
  final int rank;
  final String name;
  final String handle;
  final String emoji;
  final bool isUser;
  final int tokensHome; // Number of tokens that entered inside home
  final int tokensInDeck;
  final int totalSteps;
  final int pointsAwarded;
  final Color themeColor;
  final String accolade;
  final List<int> roundScores;

  const LudoPlayerStanding({
    required this.rank,
    required this.name,
    required this.emoji,
    required this.isUser,
    required this.tokensHome,
    this.handle = '',
    this.tokensInDeck = 0,
    this.totalSteps = 0,
    required this.pointsAwarded,
    required this.themeColor,
    required this.accolade,
    this.roundScores = const [],
  });

  static const List<LudoPlayerStanding> defaultStandings = [
    LudoPlayerStanding(
      rank: 1,
      name: 'MidnightDumpling',
      handle: '@MidnightDumpling',
      emoji: '🥟',
      isUser: true,
      tokensHome: 4,
      tokensInDeck: 0,
      totalSteps: 52,
      pointsAwarded: 500,
      themeColor: Color(0xFFE040A0),
      accolade: 'Original 4-Round Champion 👑',
      roundScores: [150, 260, 380, 500],
    ),
    LudoPlayerStanding(
      rank: 2,
      name: 'TacoFiend',
      handle: '@TacoFiend',
      emoji: '🌮',
      isUser: false,
      tokensHome: 3,
      tokensInDeck: 0,
      totalSteps: 41,
      pointsAwarded: 250,
      themeColor: Color(0xFFD97706),
      accolade: 'Feast Runner-Up 🥈',
      roundScores: [130, 170, 290, 360],
    ),
    LudoPlayerStanding(
      rank: 3,
      name: 'BobaBandit',
      handle: '@BobaBandit',
      emoji: '🧋',
      isUser: false,
      tokensHome: 2,
      tokensInDeck: 1,
      totalSteps: 28,
      pointsAwarded: 100,
      themeColor: Color(0xFF0284C7),
      accolade: 'Flavor Scout 🎯',
      roundScores: [40, 150, 250, 280],
    ),
    LudoPlayerStanding(
      rank: 4,
      name: 'PizzaSlice99',
      handle: '@SliceMaster',
      emoji: '🍕',
      isUser: false,
      tokensHome: 1,
      tokensInDeck: 2,
      totalSteps: 16,
      pointsAwarded: 50,
      themeColor: Color(0xFFEA580C),
      accolade: 'Brave Dasher ⚡',
      roundScores: [20, 70, 160, 190],
    ),
  ];
}

/// Result of a completed Treat Ludo match
class LudoMatchResult {
  final List<LudoPlayerStanding> standings;
  final int roundsPlayed;
  final bool wonByTokensHome;
  final String matchCode;
  final List<LudoRoundMemory> roundHistory;

  const LudoMatchResult({
    required this.standings,
    this.roundsPlayed = 4,
    this.wonByTokensHome = true,
    this.matchCode = '#482',
    this.roundHistory = const [],
  });

  LudoPlayerStanding get winner => standings.first;

  List<LudoRoundMemory> get resolvedRoundHistory =>
      roundHistory.isNotEmpty ? roundHistory : LudoRoundMemory.defaultFourRoundHistory;
}
