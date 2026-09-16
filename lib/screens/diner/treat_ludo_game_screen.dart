import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:treat/core/constants/asset_constants.dart';
import '../../models/ludo_match_result.dart';
import '../../state/diner_state.dart';

/// Treat Ludo Game Board Panel
/// Recreates the vibrant 4-player Feast Clash Ludo board from Image 1.
class TreatLudoGameScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onShowLeaderboard;
  final Function(List<LudoPlayerStanding> standings)? onMatchFinished;
  final Function(LudoMatchResult result)? onMatchResultFinished;
  final VoidCallback? onOpenProfile;
  final int initialRound;

  const TreatLudoGameScreen({
    super.key,
    required this.onBack,
    required this.onShowLeaderboard,
    this.onMatchFinished,
    this.onMatchResultFinished,
    this.onOpenProfile,
    this.initialRound = 1,
  });

  @override
  State<TreatLudoGameScreen> createState() => _TreatLudoGameScreenState();
}

class LudoPlayer {
  final int id;
  final String name;
  final String handle;
  final String emoji;
  final bool isUser;
  final Color color;
  final Color darkColor;
  final LinearGradient gradient;
  final Color socketBg;
  final Color socketBorder;
  final int startTileIndex;
  int tokensInDeck;
  List<int> tokenPositions;
  List<int> tokenSteps;
  int tokensHome;

  LudoPlayer({
    required this.id,
    required this.name,
    required this.handle,
    required this.emoji,
    required this.isUser,
    required this.color,
    required this.darkColor,
    required this.gradient,
    required this.socketBg,
    required this.socketBorder,
    required this.startTileIndex,
    required this.tokensInDeck,
    required this.tokenPositions,
    List<int>? tokenSteps,
    this.tokensHome = 0,
  }) : tokenSteps = tokenSteps ?? [];
}

/// Precise coordinate mapping for all 52 perimeter tiles in the 15x15 Ludo board (600x600 space).
Offset getTileCenter(int pos) {
  const List<Offset> tileCenters = [
    // West bottom arm going East (0..5)
    Offset(20, 340), Offset(60, 340), Offset(100, 340), Offset(140, 340), Offset(180, 340), Offset(220, 340),
    // South left col going South (6..10)
    Offset(260, 380), Offset(260, 420), Offset(260, 460), Offset(260, 500), Offset(260, 540),
    // South bottom row (11..13)
    Offset(260, 580), Offset(300, 580), Offset(340, 580),
    // South right col going North (14..18)
    Offset(340, 540), Offset(340, 500), Offset(340, 460), Offset(340, 420), Offset(340, 380),
    // East bottom row going East (19..23)
    Offset(380, 340), Offset(420, 340), Offset(460, 340), Offset(500, 340), Offset(540, 340),
    // East right col (24..26)
    Offset(580, 340), Offset(580, 300), Offset(580, 260),
    // East top row going West (27..31)
    Offset(540, 260), Offset(500, 260), Offset(460, 260), Offset(420, 260), Offset(380, 260),
    // North right col going North (32..36)
    Offset(340, 220), Offset(340, 180), Offset(340, 140), Offset(340, 100), Offset(340, 60),
    // North top row (37..39)
    Offset(340, 20), Offset(300, 20), Offset(260, 20),
    // North left col going South (40..44)
    Offset(260, 60), Offset(260, 100), Offset(260, 140), Offset(260, 180), Offset(260, 220),
    // West top row going West (45..49)
    Offset(220, 260), Offset(180, 260), Offset(140, 260), Offset(100, 260), Offset(60, 260),
    // West left col (50..51)
    Offset(20, 260), Offset(20, 300),
  ];
  return tileCenters[(pos % 52 + 52) % 52];
}

class _TreatLudoGameScreenState extends State<TreatLudoGameScreen>
    with SingleTickerProviderStateMixin {
  late int _currentRound;
  final int _maxRounds = 4;
  int _diceValue = 6;
  bool _isRolling = false;
  bool _soundEnabled = true;
  bool _autoMode = false;
  String? _activeShout;
  Timer? _shoutTimer;
  Timer? _tickerTimer;
  Timer? _turnTimer;
  int _tickerIndex = 0;

  // Turn management (0: Dumpling, 1: Boba, 2: Taco, 3: Slice)
  int _currentPlayerIndex = 0;
  bool _hasRolledThisTurn = true;

  late List<LudoPlayer> _players;
  final List<LudoRoundMemory> _cachedRoundHistory = [];

  int get _dumplingActivePos =>
      _players[0].tokenPositions.isNotEmpty ? _players[0].tokenPositions.first : 15;
  int get _dumplingTokensHome => _players[0].tokensHome;

  late final AnimationController _diceAnimController;

  final List<String> _liveTickerMessages = [
    '🌮 TacoFiend took a safe tile near Boba\'s ... 10s ago',
    '🧋 BobaBandit sent PizzaSlice99 back to base! ... 22s ago',
    '🥟 MidnightDumpling rolled a 6 and entered the inner feast track! ... 35s ago',
    '🍕 PizzaSlice99 claimed a Flash Perk tile (+50 Treat Coins)! ... 1m ago',
    '🥟 MidnightDumpling is 2 tiles away from home triangle! ... 1m ago',
  ];

  final List<String> _shouts = [
    '😋 YUM!',
    '🔥 HURRY!',
    '😱 SAFE ZONE!',
    '🎲 LUCKY!',
    '💥 BLOCKED!',
    '👑 NO MERCY!',
  ];

  @override
  void initState() {
    super.initState();
    _currentRound = widget.initialRound;
    _initPlayers();
    _diceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _tickerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _tickerIndex = (_tickerIndex + 1) % _liveTickerMessages.length;
        });
      }
    });
  }

  void _initPlayers() {
    _players = [
      LudoPlayer(
        id: 0,
        name: 'MidnightDumpling',
        handle: '@MidnightDumpling',
        emoji: '🥟',
        isUser: true,
        color: const Color(0xFFE040A0),
        darkColor: const Color(0xFFB2107B),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF472B6), Color(0xFFDB2777)],
        ),
        socketBg: const Color(0xFFFDF2F8),
        socketBorder: const Color(0xFFF472B6),
        startTileIndex: 15,
        tokensInDeck: 4,
        tokenPositions: [],
        tokenSteps: [],
        tokensHome: 0,
      ),
      LudoPlayer(
        id: 1,
        name: 'BobaBandit',
        handle: '@BobaBandit',
        emoji: '🧋',
        isUser: false,
        color: const Color(0xFF0284C7),
        darkColor: const Color(0xFF0369A1),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
        ),
        socketBg: const Color(0xFFE0F2FE),
        socketBorder: const Color(0xFF38BDF8),
        startTileIndex: 41,
        tokensInDeck: 4,
        tokenPositions: [],
        tokenSteps: [],
        tokensHome: 0,
      ),
      LudoPlayer(
        id: 2,
        name: 'TacoFiend',
        handle: '@TacoFiend',
        emoji: '🌮',
        isUser: false,
        color: const Color(0xFFD97706),
        darkColor: const Color(0xFFB45309),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
        ),
        socketBg: const Color(0xFFFEF3C7),
        socketBorder: const Color(0xFFF59E0B),
        startTileIndex: 28,
        tokensInDeck: 4,
        tokenPositions: [],
        tokenSteps: [],
        tokensHome: 0,
      ),
      LudoPlayer(
        id: 3,
        name: 'SliceMaster',
        handle: '@SliceMaster',
        emoji: '🍕',
        isUser: false,
        color: const Color(0xFFEA580C),
        darkColor: const Color(0xFFC2410C),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFB923C), Color(0xFFEA580C)],
        ),
        socketBg: const Color(0xFFFFF7ED),
        socketBorder: const Color(0xFFFB923C),
        startTileIndex: 23,
        tokensInDeck: 4,
        tokenPositions: [],
        tokenSteps: [],
        tokensHome: 0,
      ),
    ];
  }

  @override
  void dispose() {
    _diceAnimController.dispose();
    _shoutTimer?.cancel();
    _tickerTimer?.cancel();
    _turnTimer?.cancel();
    super.dispose();
  }

  void _rollDice({bool isAuto = false, bool isBonus = false}) {
    if (_isRolling) return;
    if (_hasRolledThisTurn && !isBonus) return;
    _turnTimer?.cancel();

    setState(() {
      _isRolling = true;
      _hasRolledThisTurn = true;
    });
    _diceAnimController.forward(from: 0.0);

    Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final randomVal = math.Random().nextInt(6) + 1;
      setState(() {
        _diceValue = randomVal;
        _isRolling = false;
      });

      final current = _players[_currentPlayerIndex];
      final canDeploy = (_diceValue == 6 && current.tokensInDeck > 0);
      final canAdvance = current.tokenPositions.isNotEmpty;

      // Bot Turn AI
      if (!current.isUser) {
        if (!canDeploy && !canAdvance) {
          setState(() {
            _liveTickerMessages.insert(
              0,
              '${current.emoji} ${current.name} rolled a $_diceValue • No moves possible',
            );
          });
          _turnTimer = Timer(const Duration(milliseconds: 1200), _nextTurn);
        } else {
          _turnTimer = Timer(const Duration(milliseconds: 850), () {
            if (!mounted) return;
            if (canDeploy) {
              _deployTokenFromDeck(current);
            } else {
              _advanceToken(current, 0, _diceValue);
            }
            _turnTimer = Timer(const Duration(milliseconds: 950), _nextTurn);
          });
        }
      } else {
        // User Turn
        if (_autoMode) {
          if (!canDeploy && !canAdvance) {
            setState(() {
              _liveTickerMessages.insert(
                0,
                '🥟 ${current.name} rolled a $_diceValue • Locked in deck (needs 6)',
              );
            });
            _turnTimer = Timer(const Duration(milliseconds: 1200), _nextTurn);
          } else {
            _turnTimer = Timer(const Duration(milliseconds: 850), () {
              if (!mounted) return;
              if (canDeploy) {
                _deployTokenFromDeck(current);
              } else {
                _advanceToken(current, 0, _diceValue);
              }
              _turnTimer = Timer(const Duration(milliseconds: 950), _nextTurn);
            });
          }
        } else {
          // Manual user turn
          if (!canDeploy && !canAdvance) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '🔒 Rolled a $_diceValue! Tokens locked in base deck — need a 6 to deploy.',
                ),
                duration: const Duration(milliseconds: 1200),
                behavior: SnackBarBehavior.floating,
              ),
            );
            _turnTimer = Timer(const Duration(milliseconds: 1600), _nextTurn);
          }
        }
      }
    });
  }

  void _deployTokenFromDeck(LudoPlayer player) {
    if (player.tokensInDeck <= 0) return;
    setState(() {
      player.tokensInDeck--;
      player.tokenPositions.add(player.startTileIndex);
      player.tokenSteps.add(0);

      // Check capture on start tile if not a safe star
      const safeTiles = [2, 15, 23, 28, 41];
      if (!safeTiles.contains(player.startTileIndex)) {
        for (final other in _players) {
          if (other.id != player.id) {
            final capIdx = other.tokenPositions.indexOf(player.startTileIndex);
            if (capIdx != -1) {
              other.tokenPositions.removeAt(capIdx);
              if (capIdx < other.tokenSteps.length) {
                other.tokenSteps.removeAt(capIdx);
              }
              other.tokensInDeck++;
              _liveTickerMessages.insert(
                0,
                '💥 ${player.emoji} ${player.name} sent ${other.emoji} ${other.name} back to base!',
              );
            }
          }
        }
      }

      _liveTickerMessages.insert(
        0,
        '${player.emoji} ${player.name} deployed a token from base deck onto track!',
      );
    });

    if (player.isUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🥟 Dumpling deployed from deck onto safe start tile!'),
          backgroundColor: const Color(0xFFE040A0),
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _advanceToken(LudoPlayer player, int tokenIndex, int steps) {
    if (player.tokenPositions.isEmpty) return;
    final idx = tokenIndex.clamp(0, player.tokenPositions.length - 1);
    final curPos = player.tokenPositions[idx];
    if (idx < player.tokenSteps.length) {
      player.tokenSteps[idx] += steps;
    } else {
      player.tokenSteps.add(steps);
    }

    // Check if token entered HOME
    // On the 52-tile track, 13 steps represents one full quadrant to home stretch.
    if (player.tokenSteps[idx] >= 13) {
      setState(() {
        player.tokenPositions.removeAt(idx);
        if (idx < player.tokenSteps.length) {
          player.tokenSteps.removeAt(idx);
        }
        player.tokensHome++;

        _liveTickerMessages.insert(
          0,
          '🎯 ${player.emoji} ${player.name} moved a token into HOME! (${player.tokensHome}/4 inside)',
        );
      });

      if (player.isUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🥟 Dumpling safely entered HOME! (${player.tokensHome}/4 inside)'),
            backgroundColor: const Color(0xFFE040A0),
            duration: const Duration(milliseconds: 1200),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }

      // Winner confirmed when first person to enter all four dumplings or tokens into home!
      if (player.tokensHome >= 4) {
        _confirmWinner(player);
        return;
      }
      return;
    }

    final newPos = (curPos + steps) % 52;

    setState(() {
      player.tokenPositions[idx] = newPos;

      // Check capture on newPos
      const safeTiles = [2, 15, 23, 28, 41];
      if (!safeTiles.contains(newPos)) {
        for (final other in _players) {
          if (other.id != player.id) {
            final capIdx = other.tokenPositions.indexOf(newPos);
            if (capIdx != -1) {
              other.tokenPositions.removeAt(capIdx);
              if (capIdx < other.tokenSteps.length) {
                other.tokenSteps.removeAt(capIdx);
              }
              other.tokensInDeck++;
              _liveTickerMessages.insert(
                0,
                '💥 ${player.emoji} ${player.name} sent ${other.emoji} ${other.name} back to base!',
              );
            }
          }
        }
      }

      _liveTickerMessages.insert(
        0,
        '${player.emoji} ${player.name} dashed forward $steps tiles!',
      );
    });

    if (player.isUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🥟 Dumpling dashed forward $steps tiles!'),
          backgroundColor: const Color(0xFFE040A0),
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  List<LudoPlayerStanding> _generateStandingsWithHistory() {
    final sortedPlayers = List<LudoPlayer>.from(_players);
    // Squad match standings arranged depending on the points of token got inside (tokensHome)
    sortedPlayers.sort((a, b) {
      final cmp = b.tokensHome.compareTo(a.tokensHome);
      if (cmp != 0) return cmp;
      final bSteps = b.tokenSteps.fold(0, (sum, s) => sum + s);
      final aSteps = a.tokenSteps.fold(0, (sum, s) => sum + s);
      final stepCmp = bSteps.compareTo(aSteps);
      if (stepCmp != 0) return stepCmp;
      return b.tokenPositions.length.compareTo(a.tokenPositions.length);
    });

    const awards = [500, 250, 100, 50];
    const accolades = [
      'Original 4-Round Champion 👑',
      'Feast Runner-Up 🥈',
      'Flavor Scout 🎯',
      'Brave Dasher ⚡',
    ];

    return List.generate(sortedPlayers.length, (i) {
      final p = sortedPlayers[i];
      final activeSteps = p.tokenSteps.fold(0, (sum, s) => sum + s);
      final totalSteps = activeSteps + (p.tokensHome * 13);
      final pName = p.isUser ? 'MidnightDumpling' : p.name;

      // Extract this player's scores across all cached rounds
      final playerRoundScores = _cachedRoundHistory.map((r) {
        final match = r.playerScores.where((s) => s.playerName == pName);
        return match.isNotEmpty ? match.first.roundPoints : (p.tokensHome * 100);
      }).toList();

      return LudoPlayerStanding(
        rank: i + 1,
        name: pName,
        handle: p.handle,
        emoji: p.emoji,
        isUser: p.isUser,
        tokensHome: p.tokensHome,
        tokensInDeck: p.tokensInDeck,
        totalSteps: totalSteps,
        pointsAwarded: awards[i],
        themeColor: p.color,
        accolade: accolades[i],
        roundScores: playerRoundScores,
      );
    });
  }

  List<LudoPlayerStanding> _generateStandings() => _generateStandingsWithHistory();

  void _cacheRoundMemory(int roundNum) {
    final roundScores = _players.map((p) {
      final activeSteps = p.tokenSteps.fold(0, (sum, s) => sum + s);
      final totalSteps = activeSteps + (p.tokensHome * 13);
      final points = (p.tokensHome * 120) + (totalSteps * 3) + (p.isUser ? 40 : 20);
      return LudoRoundScore(
        roundNumber: roundNum,
        playerName: p.isUser ? 'MidnightDumpling' : p.name,
        emoji: p.emoji,
        diceRoll: _diceValue,
        stepsMoved: totalSteps,
        tokensHome: p.tokensHome,
        roundPoints: points,
      );
    }).toList();

    // Top performer of this round
    final sortedScores = List<LudoRoundScore>.from(roundScores)
      ..sort((a, b) => b.tokensHome != a.tokensHome
          ? b.tokensHome.compareTo(a.tokensHome)
          : b.roundPoints.compareTo(a.roundPoints));
    final leader = sortedScores.first;

    final highlight = roundNum == 4
        ? 'Final Round 4: ${leader.emoji} ${leader.playerName} locked in the original championship with ${leader.tokensHome} tokens in home base!'
        : 'Round $roundNum: ${leader.emoji} ${leader.playerName} led the round with ${leader.tokensHome} tokens in home base (${leader.roundPoints} pts)!';

    final memory = LudoRoundMemory(
      roundNumber: roundNum,
      playerScores: roundScores,
      highlight: highlight,
    );

    final existingIdx = _cachedRoundHistory.indexWhere((m) => m.roundNumber == roundNum);
    if (existingIdx != -1) {
      _cachedRoundHistory[existingIdx] = memory;
    } else {
      _cachedRoundHistory.add(memory);
    }

    // Cache in DinerState as game progresses
    final interimStandings = _generateStandingsWithHistory();
    final interimResult = LudoMatchResult(
      standings: interimStandings,
      roundsPlayed: roundNum,
      wonByTokensHome: interimStandings.first.tokensHome >= 4,
      roundHistory: List.unmodifiable(_cachedRoundHistory),
    );
    if (mounted) {
      context.read<DinerState>().cacheLudoMatchResult(interimResult);
    }
  }

  void _confirmWinner(LudoPlayer winner) {
    _declareOriginalWinner(winner);
  }

  void _declareOriginalWinner([LudoPlayer? earlyWinner]) {
    _turnTimer?.cancel();

    // Ensure all 4 rounds are scored and cached in memory
    if (_cachedRoundHistory.length < _currentRound) {
      _cacheRoundMemory(_currentRound);
    }
    while (_cachedRoundHistory.length < 4) {
      _cacheRoundMemory(_cachedRoundHistory.length + 1);
    }

    final standings = _generateStandingsWithHistory();
    final finalResult = LudoMatchResult(
      standings: standings,
      roundsPlayed: 4,
      wonByTokensHome: standings.first.tokensHome >= 4,
      matchCode: '#482',
      roundHistory: List.unmodifiable(_cachedRoundHistory),
    );

    if (mounted) {
      context.read<DinerState>().cacheLudoMatchResult(finalResult);
    }

    final winnerStanding = standings.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: winnerStanding.themeColor.withOpacity(0.15),
                  border: Border.all(color: winnerStanding.themeColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: winnerStanding.themeColor.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(winnerStanding.emoji, style: const TextStyle(fontSize: 42)),
              ),
              const SizedBox(height: 14),
              Text(
                '👑 ORIGINAL WINNER DECLARED!',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF633990),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All 4 match rounds scored & cached in memory!\n${winnerStanding.name} crowned Original Champion (${winnerStanding.tokensHome} tokens inside home)!',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2A1C3D),
                ),
              ),
              const SizedBox(height: 14),
              // 4-Round Cached Summary Preview
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5FD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEADBEE)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '4-ROUND MEMORY SCORES',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF7C52AA),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'TOTAL PTS',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF7C52AA),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...standings.take(3).map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text(s.emoji, style: const TextStyle(fontSize: 13)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  s.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2A1C3D),
                                  ),
                                ),
                              ),
                              Text(
                                '${s.tokensHome}🏠 • ${s.pointsAwarded} pts',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: s.themeColor,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE040A0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (widget.onMatchResultFinished != null) {
                    widget.onMatchResultFinished!(finalResult);
                  } else if (widget.onMatchFinished != null) {
                    widget.onMatchFinished!(standings);
                  } else {
                    widget.onShowLeaderboard();
                  }
                },
                child: const Text('View 4-Round Scorecard & Standings 🏆', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishMatch() {
    _declareOriginalWinner();
  }

  void _deployDumpling() {
    final user = _players[0];
    final canDeploy = (_diceValue == 6 && user.tokensInDeck > 0);
    final canAdvance = user.tokenPositions.isNotEmpty;

    // Deploy dumpling can only be accessible if player rolled a 6 or already has token on board
    if (!canDeploy && !canAdvance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Locked! Rolled a $_diceValue. You must roll a 6 to start your dumpling\'s journey onto the track!',
          ),
          backgroundColor: const Color(0xFF633990),
          duration: const Duration(milliseconds: 1400),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (canDeploy && (user.tokenPositions.isEmpty || _diceValue == 6 && user.tokensInDeck > 0)) {
      _deployTokenFromDeck(user);
    } else if (canAdvance) {
      _advanceToken(user, 0, _diceValue);
    }

    _turnTimer = Timer(const Duration(milliseconds: 900), _nextTurn);
  }

  void _nextTurn() {
    if (!mounted) return;
    _turnTimer?.cancel();

    // If SliceMaster (player index 3) finishes turn, the current round is complete!
    if (_currentPlayerIndex == 3) {
      _cacheRoundMemory(_currentRound);

      if (_currentRound < _maxRounds) {
        // Continue round-by-round to next round!
        setState(() {
          _currentRound++;
          _currentPlayerIndex = 0;
          _hasRolledThisTurn = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🏁 Round ${_currentRound - 1} scored & cached! Continuing to Round $_currentRound of 4...',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFF633990),
            duration: const Duration(milliseconds: 1400),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        if (_autoMode) {
          _turnTimer = Timer(const Duration(milliseconds: 850), () {
            if (mounted) _rollDice(isAuto: true);
          });
        }
        return;
      } else {
        // All four matches/rounds scored at the last round -> Declare original winner!
        _declareOriginalWinner();
        return;
      }
    }

    // Advance to next player within current round
    setState(() {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % 4;
      _hasRolledThisTurn = false;
    });

    final nextPlayer = _players[_currentPlayerIndex];
    if (!nextPlayer.isUser) {
      // Bot turn: schedule auto-roll
      _turnTimer = Timer(const Duration(milliseconds: 950), () {
        if (mounted) _rollDice(isAuto: true);
      });
    } else if (_autoMode) {
      // User auto turn: schedule auto-roll
      _turnTimer = Timer(const Duration(milliseconds: 850), () {
        if (mounted) _rollDice(isAuto: true);
      });
    }
  }

  void _toggleAutoMode() {
    setState(() {
      _autoMode = !_autoMode;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _autoMode
              ? '🤖 Auto mode turned ON — AI rotating all players'
              : '🎮 Manual mode active — your turn to play',
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
    if (_autoMode && _currentPlayerIndex == 0 && !_isRolling) {
      if (!_hasRolledThisTurn) {
        _turnTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) _rollDice(isAuto: true);
        });
      } else {
        _deployDumpling();
      }
    }
  }

  void _handleBoardTap(TapUpDetails details, double boxSize) {
    if (_currentPlayerIndex != 0 || _isRolling) return;
    final scale = 600.0 / boxSize;
    final bx = details.localPosition.dx * scale;
    final by = details.localPosition.dy * scale;

    final user = _players[0];

    // 1. Tapped Bottom-Left Base (Dumpling Deck: 0..240, 360..600)
    if (bx >= 0 && bx <= 240 && by >= 360 && by <= 600) {
      if (!_hasRolledThisTurn) {
        _rollDice();
      } else if (_diceValue == 6 && user.tokensInDeck > 0) {
        _deployTokenFromDeck(user);
        _turnTimer = Timer(const Duration(milliseconds: 900), _nextTurn);
      } else if (user.tokensInDeck == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All Dumpling tokens are already in play on track!'),
            duration: Duration(milliseconds: 900),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Need a 6 to deploy from deck (Rolled $_diceValue)!'),
            duration: const Duration(milliseconds: 900),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // 2. Tapped on active token on track
    if (user.tokenPositions.isNotEmpty) {
      for (int i = 0; i < user.tokenPositions.length; i++) {
        final tokenCenter = getTileCenter(user.tokenPositions[i]);
        final dist = (Offset(bx, by) - tokenCenter).distance;
        if (dist <= 30.0) {
          if (!_hasRolledThisTurn) {
            _rollDice();
          } else {
            _advanceToken(user, i, _diceValue);
            _turnTimer = Timer(const Duration(milliseconds: 900), _nextTurn);
          }
          return;
        }
      }
    }

    // 3. Tapped Central Victory / Dice Zone
    if (bx >= 240 && bx <= 360 && by >= 240 && by <= 360) {
      if (!_hasRolledThisTurn) {
        _rollDice();
      }
      return;
    }
  }

  void _triggerShout(String shout) {
    _shoutTimer?.cancel();
    setState(() {
      _activeShout = shout;
    });
    _shoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _activeShout = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Bar (Header)
            _buildTopBar(),

            // Scrollable Match Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Speech Bubble when shouting
                      if (_activeShout != null) _buildShoutBubble(),

                      // Match Status & Prize Banner
                      _buildSubHeader(),
                      const SizedBox(height: 8),
                      _buildBountyBanner(),
                      const SizedBox(height: 10),

                      // The Feast Ludo Arena Container (max-w-[350px] aspect-square)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFEFE8F8).withOpacity(0.9),
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(124, 82, 170, 0.22),
                              blurRadius: 40,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return GestureDetector(
                                  onTapUp: (details) => _handleBoardTap(details, constraints.maxWidth),
                                  child: CustomPaint(
                                    painter: AuthenticLudoBoardPainter(
                                      dumplingActivePos: _dumplingActivePos,
                                      diceValue: _diceValue,
                                      players: _players,
                                      currentPlayerIndex: _currentPlayerIndex,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Quick Standings Shortcut Pill
                      InkWell(
                        onTap: widget.onShowLeaderboard,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFE8F8),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFDCC8E0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.leaderboard_rounded, size: 14, color: Color(0xFF633990)),
                              const SizedBox(width: 6),
                              Text(
                                'View Live Squad Standings',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF633990),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF633990)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 4-Player Turn Rotation Strip
                      _buildPlayerTurnStrip(),
                      const SizedBox(height: 8),

                      // Live Turn Action Deck
                      _buildActionDeck(),
                      const SizedBox(height: 8),

                      // Real-Time Foodie Match Activity Bar
                      _buildActivityBar(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP APP BAR (HEADER)
  // ==========================================
  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF).withOpacity(0.85),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Back Button (arrow_back_ios_new)
              InkWell(
                onTap: widget.onBack,
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 28,
                    color: Color(0xFF2A1C3D),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Brand Logo with semantic text
              Semantics(
                label: 'Treat',
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Opacity(
                      opacity: 0.0,
                      child: Text('Treat', style: TextStyle(fontSize: 1)),
                    ),
                    Image.asset(
                      AssetConstants.logo,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Text(
                        'Treat',
                        style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF633990),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              // Squad Voice Toggle
              InkWell(
                onTap: () {
                  setState(() {
                    _soundEnabled = !_soundEnabled;
                  });
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFE8F8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    size: 20,
                    color: const Color(0xFF633990),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Profile Achieved Points Pill (replaces dollar coin)
              Consumer<DinerState?>(
                builder: (context, dinerState, _) {
                  final profilePoints = dinerState?.currentPersona.points ?? 2450;
                  final formattedPoints = profilePoints.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      );

                  return Tooltip(
                    message: '$formattedPoints Profile Points Achieved',
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(124, 82, 170, 0.08),
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            size: 18,
                            color: Color(0xFFE040A0),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedPoints,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2A1C3D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),

              // Profile Avatar
              InkWell(
                onTap: widget.onOpenProfile ?? widget.onBack,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF633990),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SUB-HEADER: MATCH STATUS (ROUND / BANTER / TICKER)
  // ==========================================
  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Round Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEFE8F8),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_rounded, size: 15, color: Color(0xFF633990)),
              const SizedBox(width: 4),
              Text(
                'Round $_currentRound / $_maxRounds',
                style: GoogleFonts.dmSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF633990),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),

        // Quick squad banter / Audio status
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _triggerShout('🔥 HURRY!'),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEAF5),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.forum_rounded, size: 15, color: Color(0xFFB2107B)),
                      const SizedBox(width: 4),
                      Text(
                        'Banter',
                        style: GoogleFonts.dmSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB2107B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.campaign_rounded, size: 15, color: Color(0xFFB2107B)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Boba: No safe spot!',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF63527A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PRIZE POOL BANNER (FEAST CLASH BOUNTY)
  // ==========================================
  Widget _buildBountyBanner() {
    return InkWell(
      onTap: widget.onShowLeaderboard,
      borderRadius: BorderRadius.circular(13.3),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.3), // 10pt
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C52AA),
              Color(0xFFA46AD6),
              Color(0xFFE040A0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 82, 170, 0.18),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 19,
                      color: Color(0xFFC5E7FF),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FEAST CLASH BOUNTY',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: const Color(0xFFEFDBFF),
                          ),
                        ),
                        Text(
                          '500 Coins + Feast Champion Accolade',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '4 PLAYERS',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SHOUT BUBBLE OVERLAY
  // ==========================================
  Widget _buildShoutBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1B1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🥟', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              _activeShout!,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 4-PLAYER TURN ROTATION STRIP
  // ==========================================
  Widget _buildPlayerTurnStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.3),
        border: Border.all(color: const Color(0xFFEFE8F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(_players.length, (idx) {
            final p = _players[idx];
            final isCurrent = idx == _currentPlayerIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCurrent ? p.color.withOpacity(0.14) : const Color(0xFFFAF7FC),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isCurrent ? p.color : const Color(0xFFEFE8F8),
                    width: isCurrent ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.emoji, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      p.isUser ? 'Dumpling (You)' : p.name,
                      style: GoogleFonts.dmSans(
                        fontSize: 10.5,
                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                        color: isCurrent ? p.darkColor : const Color(0xFF63527A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isCurrent ? p.color : const Color(0xFFEFE8F8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${p.tokensHome}🏠 ${p.tokensInDeck}D',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : const Color(0xFF63527A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ==========================================
  // LIVE TURN ACTION DECK
  // ==========================================
  Widget _buildActionDeck() {
    final current = _players[_currentPlayerIndex];
    final user = _players[0];
    final canDeploy = (_diceValue == 6 && user.tokensInDeck > 0);
    final canAdvance = user.tokenPositions.isNotEmpty;
    final isActionEnabled = canDeploy || canAdvance;

    final String deployBtnText;
    final IconData deployBtnIcon;
    if (canDeploy) {
      deployBtnText = 'DEPLOY DUMPLING';
      deployBtnIcon = Icons.rocket_launch_rounded;
    } else if (canAdvance) {
      deployBtnText = 'MOVE DUMPLING (+$_diceValue)';
      deployBtnIcon = Icons.arrow_forward_rounded;
    } else {
      deployBtnText = 'LOCKED (ROLL 6 TO DEPLOY)';
      deployBtnIcon = Icons.lock_rounded;
    }

    String statusMsg;
    if (_isRolling) {
      statusMsg = '${current.name} is rolling the Treat Dice...';
    } else if (!_hasRolledThisTurn) {
      statusMsg = current.isUser
          ? 'Your turn! Tap dice or roll button to roll'
          : '${current.name} is preparing to roll...';
    } else {
      if (canDeploy && canAdvance) {
        statusMsg = 'Rolled a 6! Deploy from deck or advance active token';
      } else if (canDeploy) {
        statusMsg = 'Rolled a 6! Deploy token from deck onto start tile';
      } else if (canAdvance) {
        statusMsg = 'Rolled a $_diceValue! Advance active token on track';
      } else {
        statusMsg = 'Rolled a $_diceValue! Tokens locked in deck (needs 6)';
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.3), // 10pt
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.12),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Turn Header & Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: current.gradient,
                            boxShadow: [
                              BoxShadow(
                                color: current.color.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(current.emoji, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [current.color, current.darkColor],
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              '#${current.id + 1}',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  current.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF2A1C3D),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: current.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: current.color.withOpacity(0.4)),
                                ),
                                child: Text(
                                  current.isUser ? 'YOU' : 'BOT',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: current.darkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statusMsg,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF63527A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Auto-play Timer Pill
              InkWell(
                onTap: _toggleAutoMode,
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _autoMode
                        ? const Color(0xFF10B981).withOpacity(0.15)
                        : const Color(0xFFFCEAF5).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _autoMode
                          ? const Color(0xFF10B981)
                          : const Color(0xFFFE59B8).withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _autoMode ? Icons.smart_toy_rounded : Icons.hourglass_top_rounded,
                        size: 14,
                        color: _autoMode ? const Color(0xFF047857) : const Color(0xFFB2107B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Auto!',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _autoMode ? const Color(0xFF047857) : const Color(0xFFB2107B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Interactive Dice Arena & Actions
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F1F9).withOpacity(0.6),
              borderRadius: BorderRadius.circular(13.3), // 10pt
              border: Border.all(color: const Color(0xFFEFE8F8).withOpacity(0.8)),
            ),
            child: Row(
              children: [
                // 3D Dice Showcase
                InkWell(
                  onTap: _rollDice,
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFE59B8),
                              Color(0xFFB2107B),
                              Color(0xFF633990),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(224, 64, 160, 0.38),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: _buildDiceDots(_diceValue),
                            ),
                            const Positioned(
                              top: 2,
                              right: 4,
                              child: Text('✨', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      // Roll Count Badge
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD166), Color(0xFFFFB703)],
                            ),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.white, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(255, 183, 3, 0.5),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.casino_rounded, size: 10, color: Color(0xFF630042)),
                              const SizedBox(width: 2),
                              Text(
                                '$_diceValue',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF630042),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Action Buttons Stack
                Expanded(
                  child: Column(
                    children: [
                      // Deploy Dumpling Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _deployDumpling,
                          borderRadius: BorderRadius.circular(999),
                          child: Ink(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: isActionEnabled
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFE040A0),
                                        Color(0xFFD02888),
                                        Color(0xFFB2107B),
                                      ],
                                    )
                                  : null,
                              color: isActionEnabled ? null : const Color(0xFFF1EAFA),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isActionEnabled
                                    ? Colors.white.withOpacity(0.5)
                                    : const Color(0xFFDCCFE8),
                              ),
                              boxShadow: isActionEnabled
                                  ? const [
                                      BoxShadow(
                                        color: Color.fromRGBO(224, 64, 160, 0.45),
                                        blurRadius: 18,
                                        offset: Offset(0, 6),
                                      ),
                                    ]
                                  : const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  deployBtnText,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: isActionEnabled ? Colors.white : const Color(0xFF9E8EAD),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  deployBtnIcon,
                                  color: isActionEnabled ? Colors.white : const Color(0xFF9E8EAD),
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Roll Bonus Turn Button
                      InkWell(
                        onTap: () => _rollDice(isBonus: true),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFF633990).withOpacity(0.25)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh_rounded, size: 15, color: Color(0xFF633990)),
                              const SizedBox(width: 4),
                              Text(
                                'Roll Bonus Turn',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF633990),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // 3. Quick Squad Chat Reactions
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_bubble_rounded, size: 13, color: Color(0xFFB2107B)),
                  const SizedBox(width: 3),
                  Text(
                    'Shout:',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF63527A),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildShoutChip('🤤 YUM!'),
                      _buildShoutChip('🔥 HURRY!'),
                      _buildShoutChip('😱 SAFE ZONE!'),
                      _buildShoutChip('🎉 GG SQUAD'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShoutChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => _triggerShout(label),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F1F9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE7E0E8)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 3),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A1C3D),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // REAL-TIME FOODIE MATCH ACTIVITY BAR
  // ==========================================
  Widget _buildActivityBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F9),
        borderRadius: BorderRadius.circular(13.3), // 10pt
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Text('🌮', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF63527A)),
                      children: const [
                        TextSpan(
                          text: 'TacoFiend',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A1C3D)),
                        ),
                        TextSpan(text: " took a safe tile near Boba's yard!"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '10s ago',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF63527A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceDots(int val) {
    switch (val) {
      case 1:
        return _buildDot();
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildDot(), _buildDot()],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildDot(), _buildDot(), _buildDot()],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
          ],
        );
      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
            _buildDot(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
          ],
        );
      case 6:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildDot(), _buildDot()]),
          ],
        );
    }
  }

  Widget _buildDot() {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}

/// ==========================================
/// AUTHENTIC 15x15 LUDO BOARD PAINTER
/// Recreates the complete SVG vector Ludo Board with 100% precision.
/// ==========================================
class AuthenticLudoBoardPainter extends CustomPainter {
  final int dumplingActivePos;
  final int diceValue;
  final List<LudoPlayer>? players;
  final int currentPlayerIndex;

  AuthenticLudoBoardPainter({
    required this.dumplingActivePos,
    required this.diceValue,
    this.players,
    this.currentPlayerIndex = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Scale coordinate space to 600 x 600
    final scale = size.width / 600.0;
    canvas.scale(scale, scale);

    // 1. Background Grid Base (40px per tile, 15x15 = 600x600)
    final bgRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 600, 600),
      const Radius.circular(16),
    );
    canvas.drawRRect(bgRRect, Paint()..color = const Color(0xFFFAF5FB));

    // Helper: Draw standard tile (40x40)
    void drawTile(
      double x,
      double y, {
      Color fillColor = Colors.white,
      Color strokeColor = const Color(0xFFE5D9EC),
      double strokeWidth = 1.0,
    }) {
      final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 40, 40), const Radius.circular(4));
      canvas.drawRRect(rrect, Paint()..color = fillColor);
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    // Helper: Draw Star
    void drawStar(double cx, double cy, {Color color = Colors.white}) {
      final tp = TextPainter(
        text: TextSpan(
          text: '★',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
    }

    // Helper: Draw Dot
    void drawDot(double cx, double cy, Color color) {
      canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = color.withOpacity(0.6));
    }

    // Helper: Draw Arrow Polygon
    void drawArrow(List<Offset> points, Color color) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = color);
    }

    // Helper: Draw Text / Emoji
    void drawText(
      String text,
      double x,
      double y, {
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w900,
      Color color = Colors.black,
      bool centered = false,
      String? fontFamily,
      double? letterSpacing,
    }) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily ?? 'DM Sans',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final offset = centered ? Offset(x - tp.width / 2, y - tp.height / 2) : Offset(x, y);
      tp.paint(canvas, offset);
    }

    // ==================== 1. NORTH TRACK TILES (x: 240..360, y: 0..240) ====================
    // Row 0
    drawTile(240, 0); drawTile(280, 0); drawTile(320, 0);
    // Row 1
    drawTile(240, 40);
    drawTile(280, 40, fillColor: const Color(0xFFFEF08A), strokeColor: const Color(0xFFF59E0B), strokeWidth: 1.5);
    drawArrow([const Offset(300, 56), const Offset(292, 46), const Offset(308, 46)], const Color(0xFFD97706));
    drawTile(320, 40);
    // Row 2: Col 0 is Cyan Safe Star Tile
    drawTile(240, 80, fillColor: const Color(0xFF38BDF8), strokeColor: const Color(0xFF0284C7), strokeWidth: 1.5);
    drawStar(260, 100);
    drawTile(280, 80, fillColor: const Color(0xFFFEF08A), strokeColor: const Color(0xFFF59E0B));
    drawDot(300, 100, const Color(0xFFD97706));
    drawTile(320, 80);
    // Row 3
    drawTile(240, 120);
    drawTile(280, 120, fillColor: const Color(0xFFFEF08A), strokeColor: const Color(0xFFF59E0B));
    drawDot(300, 140, const Color(0xFFD97706));
    drawTile(320, 120);
    // Row 4
    drawTile(240, 160);
    drawTile(280, 160, fillColor: const Color(0xFFFEF08A), strokeColor: const Color(0xFFF59E0B));
    drawDot(300, 180, const Color(0xFFD97706));
    drawTile(320, 160);
    // Row 5
    drawTile(240, 200);
    drawTile(280, 200, fillColor: const Color(0xFFFEF08A), strokeColor: const Color(0xFFF59E0B));
    drawDot(300, 220, const Color(0xFFD97706));
    drawTile(320, 200);

    // ==================== 2. SOUTH TRACK TILES (x: 240..360, y: 360..600) ====================
    // Row 9
    drawTile(240, 360);
    drawTile(280, 360, fillColor: const Color(0xFFFBCFE8), strokeColor: const Color(0xFFDB2777));
    drawDot(300, 380, const Color(0xFFBE185D));
    drawTile(320, 360);
    // Row 10
    drawTile(240, 400);
    drawTile(280, 400, fillColor: const Color(0xFFFBCFE8), strokeColor: const Color(0xFFDB2777));
    drawDot(300, 420, const Color(0xFFBE185D));
    drawTile(320, 400);
    // Row 11
    drawTile(240, 440);
    drawTile(280, 440, fillColor: const Color(0xFFFBCFE8), strokeColor: const Color(0xFFDB2777));
    drawDot(300, 460, const Color(0xFFBE185D));
    drawTile(320, 440);
    // Row 12: Col 2 is Pink Safe Star Tile
    drawTile(240, 480);
    drawTile(280, 480, fillColor: const Color(0xFFFBCFE8), strokeColor: const Color(0xFFDB2777));
    drawDot(300, 500, const Color(0xFFBE185D));
    drawTile(320, 480, fillColor: const Color(0xFFEC4899), strokeColor: const Color(0xFFBE185D), strokeWidth: 1.5);
    drawStar(340, 500);
    // Row 13 (Pink Entry upward arrow)
    drawTile(240, 520);
    drawTile(280, 520, fillColor: const Color(0xFFFBCFE8), strokeColor: const Color(0xFFDB2777), strokeWidth: 1.5);
    drawArrow([const Offset(300, 524), const Offset(292, 534), const Offset(308, 534)], const Color(0xFFBE185D));
    drawTile(320, 520);
    // Row 14
    drawTile(240, 560); drawTile(280, 560); drawTile(320, 560);

    // ==================== 3. WEST TRACK TILES (x: 0..240, y: 240..360) ====================
    // Row 6
    for (double x = 0; x <= 200; x += 40) {
      drawTile(x, 240);
    }
    // Row 7: Cyan Home Run track with arrow right
    drawTile(0, 280);
    drawTile(40, 280, fillColor: const Color(0xFFBAE6FD), strokeColor: const Color(0xFF0284C7), strokeWidth: 1.5);
    drawArrow([const Offset(56, 300), const Offset(46, 292), const Offset(46, 308)], const Color(0xFF0284C7));
    for (double x = 80; x <= 200; x += 40) {
      drawTile(x, 280, fillColor: const Color(0xFFBAE6FD), strokeColor: const Color(0xFF0284C7));
      drawDot(x + 20, 300, const Color(0xFF0284C7));
    }
    // Row 8: Col 2 is Dumpling Entry Safe Star
    drawTile(0, 320);
    drawTile(40, 320);
    drawTile(80, 320, fillColor: const Color(0xFFEC4899), strokeColor: const Color(0xFFBE185D), strokeWidth: 1.5);
    drawStar(100, 340);
    drawTile(120, 320);
    drawTile(160, 320);
    drawTile(200, 320);

    // ==================== 4. EAST TRACK TILES (x: 360..600, y: 240..360) ====================
    // Row 6: Col 12 is Taco Safe Star
    drawTile(360, 240); drawTile(400, 240); drawTile(440, 240);
    drawTile(480, 240, fillColor: const Color(0xFFF59E0B), strokeColor: const Color(0xFFD97706), strokeWidth: 1.5);
    drawStar(500, 260);
    drawTile(520, 240); drawTile(560, 240);
    // Row 7: Coral Home Run track leading West with arrow left
    for (double x = 360; x <= 480; x += 40) {
      drawTile(x, 280, fillColor: const Color(0xFFFED7AA), strokeColor: const Color(0xFFEA580C));
      drawDot(x + 20, 300, const Color(0xFFEA580C));
    }
    drawTile(520, 280, fillColor: const Color(0xFFFED7AA), strokeColor: const Color(0xFFEA580C), strokeWidth: 1.5);
    drawArrow([const Offset(524, 300), const Offset(534, 292), const Offset(534, 308)], const Color(0xFFEA580C));
    drawTile(560, 280);
    // Row 8: Col 13 is SliceMaster Safe Star
    drawTile(360, 320); drawTile(400, 320); drawTile(440, 320); drawTile(480, 320);
    drawTile(520, 320, fillColor: const Color(0xFFF97316), strokeColor: const Color(0xFFC2410C), strokeWidth: 1.5);
    drawStar(540, 340);
    drawTile(560, 320);

    // ==================== 5. FOUR CORNER BASES (6x6 = 240x240 each) ====================
    void drawSocket(
      double cx,
      double cy, {
      bool hasToken = false,
      String? emoji,
      Gradient? tokenGrad,
      Color socketBg = const Color(0xFFE0F2FE),
      Color socketBorder = const Color(0xFF38BDF8),
      bool glowSparkle = false,
    }) {
      if (hasToken) {
        // Socket base ring
        canvas.drawCircle(Offset(cx, cy), 28, Paint()..color = socketBg);
        canvas.drawCircle(
          Offset(cx, cy),
          28,
          Paint()
            ..color = socketBorder
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        // Shadow
        canvas.drawCircle(Offset(cx, cy + 2), 22, Paint()..color = Colors.black.withOpacity(0.25));
        // Gradient token body
        final tPaint = Paint()
          ..shader = (tokenGrad ?? const LinearGradient(colors: [Colors.pink, Colors.purple]))
              .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 22));
        canvas.drawCircle(Offset(cx, cy), 22, tPaint);
        canvas.drawCircle(
          Offset(cx, cy),
          22,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
        if (emoji != null) {
          drawText(emoji, cx, cy - 2, fontSize: 18, centered: true);
        }
        if (glowSparkle) {
          canvas.drawCircle(Offset(cx + 15, cy - 15), 3.5, Paint()..color = const Color(0xFFFDE047));
        }
      } else {
        // Empty socket with dashed appearance
        canvas.drawCircle(Offset(cx, cy), 24, Paint()..color = socketBg.withOpacity(0.7));
        canvas.drawCircle(
          Offset(cx, cy),
          24,
          Paint()
            ..color = socketBorder.withOpacity(0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = socketBorder.withOpacity(0.3));
      }
    }

    // --- TOP-LEFT: BobaBandit Base (Cyan) ---
    final bobaBaseRect = Rect.fromLTWH(6, 6, 228, 228);
    final bobaBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
    ).createShader(bobaBaseRect);
    if (currentPlayerIndex == 1) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(bobaBaseRect.inflate(3), const Radius.circular(18)),
        Paint()..color = const Color(0xFF38BDF8).withOpacity(0.55),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaBaseRect, const Radius.circular(16)),
      Paint()..shader = bobaBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFF0284C7).withOpacity(currentPlayerIndex == 1 ? 0.95 : 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentPlayerIndex == 1 ? 3.5 : 3,
    );
    final bobaCardRect = Rect.fromLTWH(26, 46, 188, 170);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaCardRect, const Radius.circular(14)),
      Paint()..color = Colors.white.withOpacity(0.95),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaCardRect, const Radius.circular(14)),
      Paint()
        ..color = const Color(0xFFBAE6FD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (currentPlayerIndex == 1) {
      final tagRect = RRect.fromRectAndRadius(const Rect.fromLTWH(18, 0, 86, 20), const Radius.circular(10));
      canvas.drawRRect(tagRect, Paint()..color = const Color(0xFF0284C7));
      canvas.drawRRect(tagRect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      drawText('BOBA TURN', 61, 10, fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white, centered: true, letterSpacing: 0.5);
    }
    drawText('🧋 BobaBandit', 34, 18, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0369A1));
    canvas.drawCircle(const Offset(216, 28), 4, Paint()..color = const Color(0xFF0284C7));
    const cyanTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]);
    final bobaDeck = (players != null && players!.length > 1) ? players![1].tokensInDeck : 4;
    drawSocket(75, 95, hasToken: bobaDeck >= 1, emoji: '🧋', tokenGrad: cyanTokenGrad);
    drawSocket(165, 95, hasToken: bobaDeck >= 2, emoji: '🧋', tokenGrad: cyanTokenGrad);
    drawSocket(75, 165, hasToken: bobaDeck >= 3, emoji: '🧋', tokenGrad: cyanTokenGrad, socketBg: const Color(0xFFE0F2FE), socketBorder: const Color(0xFF7DD3FC));
    drawSocket(165, 165, hasToken: bobaDeck >= 4, emoji: '🧋', tokenGrad: cyanTokenGrad, socketBg: const Color(0xFFE0F2FE), socketBorder: const Color(0xFF7DD3FC));

    // --- TOP-RIGHT: TacoFiend Base (Amber / Warm Yellow) ---
    final tacoBaseRect = Rect.fromLTWH(366, 6, 228, 228);
    final tacoBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
    ).createShader(tacoBaseRect);
    if (currentPlayerIndex == 2) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(tacoBaseRect.inflate(3), const Radius.circular(18)),
        Paint()..color = const Color(0xFFF59E0B).withOpacity(0.55),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoBaseRect, const Radius.circular(16)),
      Paint()..shader = tacoBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFD97706).withOpacity(currentPlayerIndex == 2 ? 0.95 : 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentPlayerIndex == 2 ? 3.5 : 3,
    );
    final tacoCardRect = Rect.fromLTWH(386, 46, 188, 170);
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoCardRect, const Radius.circular(14)),
      Paint()..color = Colors.white.withOpacity(0.95),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoCardRect, const Radius.circular(14)),
      Paint()
        ..color = const Color(0xFFFDE68A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (currentPlayerIndex == 2) {
      final tagRect = RRect.fromRectAndRadius(const Rect.fromLTWH(378, 0, 86, 20), const Radius.circular(10));
      canvas.drawRRect(tagRect, Paint()..color = const Color(0xFFD97706));
      canvas.drawRRect(tagRect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      drawText('TACO TURN', 421, 10, fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white, centered: true, letterSpacing: 0.5);
    }
    drawText('🌮 TacoFiend', 394, 18, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFFB45309));
    canvas.drawCircle(const Offset(576, 28), 4, Paint()..color = const Color(0xFFF59E0B));
    const amberTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFBBF24), Color(0xFFD97706)]);
    final tacoDeck = (players != null && players!.length > 2) ? players![2].tokensInDeck : 4;
    drawSocket(435, 95, hasToken: tacoDeck >= 1, emoji: '🌮', tokenGrad: amberTokenGrad, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFF59E0B));
    drawSocket(525, 95, hasToken: tacoDeck >= 2, emoji: '🌮', tokenGrad: amberTokenGrad, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));
    drawSocket(435, 165, hasToken: tacoDeck >= 3, emoji: '🌮', tokenGrad: amberTokenGrad, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));
    drawSocket(525, 165, hasToken: tacoDeck >= 4, emoji: '🌮', tokenGrad: amberTokenGrad, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));

    // --- BOTTOM-LEFT: MidnightDumpling Base (YOU - Pink with active turn halo) ---
    final dumplingBaseRect = Rect.fromLTWH(6, 366, 228, 228);
    final dumplingBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
    ).createShader(dumplingBaseRect);
    // Active glow halo
    if (currentPlayerIndex == 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(dumplingBaseRect.inflate(3), const Radius.circular(18)),
        Paint()..color = const Color(0xFFFE59B8).withOpacity(0.55),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingBaseRect, const Radius.circular(16)),
      Paint()..shader = dumplingBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFDB2777)
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentPlayerIndex == 0 ? 3.5 : 2.5,
    );
    final dumplingCardRect = Rect.fromLTWH(26, 406, 188, 170);
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingCardRect, const Radius.circular(14)),
      Paint()..color = Colors.white.withOpacity(0.95),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingCardRect, const Radius.circular(14)),
      Paint()
        ..color = const Color(0xFFFBCFE8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Active Turn Tag
    if (currentPlayerIndex == 0) {
      final tagRect = RRect.fromRectAndRadius(const Rect.fromLTWH(18, 360, 86, 20), const Radius.circular(10));
      canvas.drawRRect(tagRect, Paint()..color = const Color(0xFFB2107B));
      canvas.drawRRect(tagRect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      drawText('YOUR TURN', 61, 370, fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white, centered: true, letterSpacing: 0.5);
    }
    drawText('🥟 You', 116, 378, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF9D174D));
    const pinkTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF472B6), Color(0xFFDB2777)]);
    final dumplingDeck = (players != null && players!.isNotEmpty) ? players![0].tokensInDeck : 4;
    drawSocket(75, 455, hasToken: dumplingDeck >= 1, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFDF2F8), socketBorder: const Color(0xFFF472B6), glowSparkle: dumplingDeck >= 1);
    drawSocket(165, 455, hasToken: dumplingDeck >= 2, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFDF2F8), socketBorder: const Color(0xFFF472B6), glowSparkle: dumplingDeck >= 2);
    drawSocket(75, 525, hasToken: dumplingDeck >= 3, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFCE7F3), socketBorder: const Color(0xFFF472B6));
    drawSocket(165, 525, hasToken: dumplingDeck >= 4, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFCE7F3), socketBorder: const Color(0xFFF472B6));

    // --- BOTTOM-RIGHT: SliceMaster Base (Coral Orange) ---
    final sliceBaseRect = Rect.fromLTWH(366, 366, 228, 228);
    final sliceBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFBE9E7), Color(0xFFFFCCBC)],
    ).createShader(sliceBaseRect);
    if (currentPlayerIndex == 3) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(sliceBaseRect.inflate(3), const Radius.circular(18)),
        Paint()..color = const Color(0xFFFB923C).withOpacity(0.55),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceBaseRect, const Radius.circular(16)),
      Paint()..shader = sliceBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFEA580C).withOpacity(currentPlayerIndex == 3 ? 0.95 : 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentPlayerIndex == 3 ? 3.5 : 3,
    );
    final sliceCardRect = Rect.fromLTWH(386, 406, 188, 170);
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceCardRect, const Radius.circular(14)),
      Paint()..color = Colors.white.withOpacity(0.95),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceCardRect, const Radius.circular(14)),
      Paint()
        ..color = const Color(0xFFFFEDD5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (currentPlayerIndex == 3) {
      final tagRect = RRect.fromRectAndRadius(const Rect.fromLTWH(378, 360, 86, 20), const Radius.circular(10));
      canvas.drawRRect(tagRect, Paint()..color = const Color(0xFFEA580C));
      canvas.drawRRect(tagRect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      drawText('SLICE TURN', 421, 370, fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white, centered: true, letterSpacing: 0.5);
    }
    drawText('🍕 SliceMaster', 394, 378, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFFC2410C));
    canvas.drawCircle(const Offset(576, 388), 4, Paint()..color = const Color(0xFFF97316));
    const coralTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFB923C), Color(0xFFEA580C)]);
    final sliceDeck = (players != null && players!.length > 3) ? players![3].tokensInDeck : 4;
    drawSocket(435, 455, hasToken: sliceDeck >= 1, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(525, 455, hasToken: sliceDeck >= 2, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(435, 525, hasToken: sliceDeck >= 3, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(525, 525, hasToken: sliceDeck >= 4, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFEDD5), socketBorder: const Color(0xFFFDBA74));

    // ==================== 6. CENTRAL VICTORY HOME TRIANGLES (3x3 = 120x120) ====================
    // Top Triangle (Amber / TacoFiend)
    final topTri = Path()..moveTo(240, 240)..lineTo(360, 240)..lineTo(300, 300)..close();
    canvas.drawPath(topTri, Paint()..color = const Color(0xFFF59E0B));
    canvas.drawPath(topTri, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Right Triangle (Coral / SliceMaster)
    final rightTri = Path()..moveTo(360, 240)..lineTo(360, 360)..lineTo(300, 300)..close();
    canvas.drawPath(rightTri, Paint()..color = const Color(0xFFEA580C));
    canvas.drawPath(rightTri, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Bottom Triangle (Pink / Dumpling)
    final botTri = Path()..moveTo(240, 360)..lineTo(360, 360)..lineTo(300, 300)..close();
    canvas.drawPath(botTri, Paint()..color = const Color(0xFFEC4899));
    canvas.drawPath(botTri, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Left Triangle (Cyan / BobaBandit)
    final leftTri = Path()..moveTo(240, 240)..lineTo(240, 360)..lineTo(300, 300)..close();
    canvas.drawPath(leftTri, Paint()..color = const Color(0xFF0284C7));
    canvas.drawPath(leftTri, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Badges for tokens that safely entered Home
    void drawHomeTokensBadge(double cx, double cy, String emoji, int count, Color bgColor) {
      if (count <= 0) return;
      final badgeRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: 44, height: 20),
        const Radius.circular(10),
      );
      canvas.drawRRect(badgeRect, Paint()..color = Colors.white.withOpacity(0.92));
      canvas.drawRRect(badgeRect, Paint()..color = bgColor..style = PaintingStyle.stroke..strokeWidth = 1.2);
      drawText('$emoji x$count', cx, cy - 1, fontSize: 10, fontWeight: FontWeight.w900, color: bgColor, centered: true);
    }

    if (players != null) {
      if (players!.length > 2 && players![2].tokensHome > 0) {
        drawHomeTokensBadge(300, 262, '🌮', players![2].tokensHome, const Color(0xFFD97706));
      }
      if (players!.length > 3 && players![3].tokensHome > 0) {
        drawHomeTokensBadge(338, 300, '🍕', players![3].tokensHome, const Color(0xFFEA580C));
      }
      if (players!.isNotEmpty && players![0].tokensHome > 0) {
        drawHomeTokensBadge(300, 338, '🥟', players![0].tokensHome, const Color(0xFFDB2777));
      }
      if (players!.length > 1 && players![1].tokensHome > 0) {
        drawHomeTokensBadge(262, 300, '🧋', players![1].tokensHome, const Color(0xFF0284C7));
      }
    }

    // Center Victory Feast Trophy Medallion
    canvas.drawCircle(const Offset(300, 300), 30, Paint()..color = Colors.black.withOpacity(0.2));
    canvas.drawCircle(const Offset(300, 300), 30, Paint()..color = Colors.white);
    canvas.drawCircle(
      const Offset(300, 300),
      30,
      Paint()
        ..color = const Color(0xFF633990)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    drawText('👑', 300, 290, fontSize: 18, centered: true);
    drawText('FEAST', 300, 316, fontSize: 8, fontWeight: FontWeight.w900, color: const Color(0xFF633990), centered: true, letterSpacing: 0.5);

    // ==================== 7. LIVE ACTIVE PAWNS ADVANCING ON BOARD ====================
    void drawActivePawn(double cx, double cy, String emoji, Gradient grad, {bool glow = false}) {
      if (glow) {
        canvas.drawCircle(Offset(cx, cy), 21, Paint()..color = const Color(0xFFFE59B8).withOpacity(0.6));
      }
      canvas.drawCircle(Offset(cx, cy + 2), 16, Paint()..color = Colors.black.withOpacity(0.3));
      final pPaint = Paint()..shader = grad.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 17));
      canvas.drawCircle(Offset(cx, cy), 16.5, pPaint);
      canvas.drawCircle(Offset(cx, cy), 16.5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.2);
      drawText(emoji, cx, cy - 2, fontSize: 14, centered: true);
      if (glow) {
        canvas.drawCircle(Offset(cx + 10, cy - 11), 3, Paint()..color = const Color(0xFFFEF08A));
      }
    }

    if (players != null) {
      for (final p in players!) {
        for (final pos in p.tokenPositions) {
          final center = getTileCenter(pos);
          drawActivePawn(center.dx, center.dy, p.emoji, p.gradient, glow: p.isUser);
        }
      }
    } else {
      drawActivePawn(340, 100, '🌮', amberTokenGrad);
      drawActivePawn(180, 260, '🧋', cyanTokenGrad);
      drawActivePawn(420, 340, '🍕', coralTokenGrad);
      final dumplingOffsetY = (dumplingActivePos % 4) * 40.0;
      drawActivePawn(340, 420 + (dumplingOffsetY > 120 ? 0 : dumplingOffsetY), '🥟', pinkTokenGrad, glow: true);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AuthenticLudoBoardPainter oldDelegate) {
    return oldDelegate.dumplingActivePos != dumplingActivePos ||
        oldDelegate.diceValue != diceValue ||
        oldDelegate.currentPlayerIndex != currentPlayerIndex ||
        oldDelegate.players != players;
  }
}
