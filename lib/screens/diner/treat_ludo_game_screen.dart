import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treat/core/constants/asset_constants.dart';

/// Treat Ludo Game Board Panel
/// Recreates the vibrant 4-player Feast Clash Ludo board from Image 1.
class TreatLudoGameScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onShowLeaderboard;
  final VoidCallback? onOpenProfile;

  const TreatLudoGameScreen({
    super.key,
    required this.onBack,
    required this.onShowLeaderboard,
    this.onOpenProfile,
  });

  @override
  State<TreatLudoGameScreen> createState() => _TreatLudoGameScreenState();
}

class _TreatLudoGameScreenState extends State<TreatLudoGameScreen>
    with SingleTickerProviderStateMixin {
  int _currentRound = 4;
  final int _maxRounds = 15;
  int _diceValue = 6;
  bool _isRolling = false;
  bool _soundEnabled = true;
  bool _autoMode = false;
  String? _activeShout;
  Timer? _shoutTimer;
  Timer? _tickerTimer;
  int _tickerIndex = 0;

  // Ludo Game State
  int _dumplingTokensHome = 0;
  int _dumplingActivePos = 4; // Position along track (0..51)

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

  @override
  void dispose() {
    _diceAnimController.dispose();
    _shoutTimer?.cancel();
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
    });
    _diceAnimController.forward(from: 0.0);

    Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final randomVal = math.Random().nextInt(6) + 1;
      setState(() {
        _diceValue = randomVal;
        _isRolling = false;
        if (_currentRound < _maxRounds) {
          _currentRound++;
        }
      });
    });
  }

  void _deployDumpling() {
    setState(() {
      _dumplingActivePos = (_dumplingActivePos + _diceValue) % 52;
      if (_dumplingActivePos > 46 && _dumplingTokensHome < 4) {
        _dumplingTokensHome++;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🥟 Dumpling dashed forward $_diceValue tiles!'),
        backgroundColor: const Color(0xFFE040A0),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // If rounds reached max or user finished, prompt leaderboard
    if (_currentRound >= _maxRounds) {
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          widget.onShowLeaderboard();
        }
      });
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
                            child: CustomPaint(
                              painter: AuthenticLudoBoardPainter(
                                dumplingActivePos: _dumplingActivePos,
                                diceValue: _diceValue,
                              ),
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

              // Coins Pill ($ 2,450)
              Container(
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
                  children: [
                    const Icon(Icons.monetization_on_rounded, size: 18, color: Color(0xFFB2107B)),
                    const SizedBox(width: 4),
                    Text(
                      '2,450',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2A1C3D),
                      ),
                    ),
                  ],
                ),
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
                          '500 Coins + 50% Off Platter',
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
  // LIVE TURN ACTION DECK
  // ==========================================
  Widget _buildActionDeck() {
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFD8E8), Color(0xFFFE59B8)],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(224, 64, 160, 0.35),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('🥟', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF633990), Color(0xFFB2107B)],
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: const Text(
                              '#1',
                              style: TextStyle(
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
                                  'MidnightDumpling',
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
                                  color: const Color(0xFFFCEAF5),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: const Color(0xFFFE59B8).withOpacity(0.4)),
                                ),
                                child: Text(
                                  'YOU',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: const Color(0xFFB2107B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isRolling
                                ? 'Rolling the Treat Dice...'
                                : 'Rolled a $_diceValue! Deploy or take bonus roll',
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
                onTap: () {
                  setState(() {
                    _autoMode = !_autoMode;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_autoMode ? '🤖 Auto mode turned ON' : '🎮 Manual mode active'),
                      duration: const Duration(milliseconds: 700),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEAF5).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFE59B8).withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hourglass_top_rounded, size: 14, color: Color(0xFFB2107B)),
                      const SizedBox(width: 4),
                      Text(
                        'Auto!',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB2107B),
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE040A0),
                                  Color(0xFFD02888),
                                  Color(0xFFB2107B),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(224, 64, 160, 0.45),
                                  blurRadius: 18,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'DEPLOY DUMPLING',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Roll Bonus Turn Button
                      InkWell(
                        onTap: _rollDice,
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

  AuthenticLudoBoardPainter({
    required this.dumplingActivePos,
    required this.diceValue,
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
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaBaseRect, const Radius.circular(16)),
      Paint()..shader = bobaBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bobaBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFF0284C7).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
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
    drawText('🧋 BobaBandit', 34, 18, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0369A1));
    canvas.drawCircle(const Offset(216, 28), 4, Paint()..color = const Color(0xFF0284C7));
    const cyanTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]);
    drawSocket(75, 95, hasToken: true, emoji: '🧋', tokenGrad: cyanTokenGrad);
    drawSocket(165, 95, hasToken: true, emoji: '🧋', tokenGrad: cyanTokenGrad);
    drawSocket(75, 165, hasToken: false, socketBg: const Color(0xFFE0F2FE), socketBorder: const Color(0xFF7DD3FC));
    drawSocket(165, 165, hasToken: false, socketBg: const Color(0xFFE0F2FE), socketBorder: const Color(0xFF7DD3FC));

    // --- TOP-RIGHT: TacoFiend Base (Amber / Warm Yellow) ---
    final tacoBaseRect = Rect.fromLTWH(366, 6, 228, 228);
    final tacoBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
    ).createShader(tacoBaseRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoBaseRect, const Radius.circular(16)),
      Paint()..shader = tacoBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tacoBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFD97706).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
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
    drawText('🌮 TacoFiend', 394, 18, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFFB45309));
    canvas.drawCircle(const Offset(576, 28), 4, Paint()..color = const Color(0xFFF59E0B));
    const amberTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFBBF24), Color(0xFFD97706)]);
    drawSocket(435, 95, hasToken: true, emoji: '🌮', tokenGrad: amberTokenGrad, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFF59E0B));
    drawSocket(525, 95, hasToken: false, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));
    drawSocket(435, 165, hasToken: false, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));
    drawSocket(525, 165, hasToken: false, socketBg: const Color(0xFFFEF3C7), socketBorder: const Color(0xFFFCD34D));

    // --- BOTTOM-LEFT: MidnightDumpling Base (YOU - Pink with active turn halo) ---
    final dumplingBaseRect = Rect.fromLTWH(6, 366, 228, 228);
    final dumplingBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
    ).createShader(dumplingBaseRect);
    // Active glow halo
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingBaseRect.inflate(3), const Radius.circular(18)),
      Paint()..color = const Color(0xFFFE59B8).withOpacity(0.4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingBaseRect, const Radius.circular(16)),
      Paint()..shader = dumplingBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(dumplingBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFDB2777)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
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
    final tagRect = RRect.fromRectAndRadius(const Rect.fromLTWH(18, 360, 86, 20), const Radius.circular(10));
    canvas.drawRRect(tagRect, Paint()..color = const Color(0xFFB2107B));
    canvas.drawRRect(tagRect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    drawText('YOUR TURN', 61, 370, fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white, centered: true, letterSpacing: 0.5);
    drawText('🥟 You', 116, 378, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF9D174D));
    const pinkTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF472B6), Color(0xFFDB2777)]);
    drawSocket(75, 455, hasToken: true, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFDF2F8), socketBorder: const Color(0xFFF472B6), glowSparkle: true);
    drawSocket(165, 455, hasToken: true, emoji: '🥟', tokenGrad: pinkTokenGrad, socketBg: const Color(0xFFFDF2F8), socketBorder: const Color(0xFFF472B6), glowSparkle: true);
    drawSocket(75, 525, hasToken: false, socketBg: const Color(0xFFFCE7F3), socketBorder: const Color(0xFFF472B6));
    drawSocket(165, 525, hasToken: false, socketBg: const Color(0xFFFCE7F3), socketBorder: const Color(0xFFF472B6));

    // --- BOTTOM-RIGHT: SliceMaster Base (Coral Orange) ---
    final sliceBaseRect = Rect.fromLTWH(366, 366, 228, 228);
    final sliceBaseGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFBE9E7), Color(0xFFFFCCBC)],
    ).createShader(sliceBaseRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceBaseRect, const Radius.circular(16)),
      Paint()..shader = sliceBaseGrad,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(sliceBaseRect, const Radius.circular(16)),
      Paint()
        ..color = const Color(0xFFEA580C).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
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
    drawText('🍕 SliceMaster', 394, 378, fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFFC2410C));
    canvas.drawCircle(const Offset(576, 388), 4, Paint()..color = const Color(0xFFF97316));
    const coralTokenGrad = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFB923C), Color(0xFFEA580C)]);
    drawSocket(435, 455, hasToken: true, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(525, 455, hasToken: true, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(435, 525, hasToken: true, emoji: '🍕', tokenGrad: coralTokenGrad, socketBg: const Color(0xFFFFF7ED), socketBorder: const Color(0xFFFB923C));
    drawSocket(525, 525, hasToken: false, socketBg: const Color(0xFFFFEDD5), socketBorder: const Color(0xFFFDBA74));

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

    // Pawn A: TacoFiend token on North Arm safe star (x: 340, y: 100)
    drawActivePawn(340, 100, '🌮', amberTokenGrad);
    // Pawn B: Boba token racing on West Arm (x: 180, y: 260)
    drawActivePawn(180, 260, '🧋', cyanTokenGrad);
    // Pawn C: Pizza pawn on East Arm (x: 420, y: 340)
    drawActivePawn(420, 340, '🍕', coralTokenGrad);
    // Pawn D: MidnightDumpling (YOU) advancing on South Track!
    // Base coordinate is (340, 420), shifts along track if position advances
    final dumplingOffsetY = (dumplingActivePos % 4) * 40.0;
    drawActivePawn(340, 420 + (dumplingOffsetY > 120 ? 0 : dumplingOffsetY), '🥟', pinkTokenGrad, glow: true);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AuthenticLudoBoardPainter oldDelegate) {
    return oldDelegate.dumplingActivePos != dumplingActivePos || oldDelegate.diceValue != diceValue;
  }
}
