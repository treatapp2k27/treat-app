import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/treat_colors.dart';

/// Squad Minigame Banner with Mia's Sweet Treat Perks
class SquadMinigameBanner extends StatelessWidget {
  final VoidCallback? onPlay;

  const SquadMinigameBanner({super.key, this.onPlay});

  void _openMinigame(BuildContext context) {
    if (onPlay != null) {
      onPlay!();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => SquadLudoModal(
        onRewardClaimed: (reward) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Awesome! You won $reward!'),
              backgroundColor: TreatColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5E35B1),
            Color(0xFF8E24AA),
            Color(0xFFE040A0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.28),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row: SQUAD MINIGAME & Season 4
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.videogame_asset_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'SQUAD MINIGAME',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Season 4',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),

          // Title
          Text(
            "Mia's Sweet Treat Perks",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Roll 🎲 to win 50% vouchers & unlock secret dishes!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: 8),

          // Interactive Button: Play Squad Ludo 🎲
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () => _openMinigame(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: TreatColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shadowColor: Colors.black26,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Play Squad Ludo 🎲',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: TreatColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(String letter, Color color, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            color: TreatColors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Interactive Squad Ludo Minigame Modal Dialog
class SquadLudoModal extends StatefulWidget {
  final ValueChanged<String> onRewardClaimed;

  const SquadLudoModal({super.key, required this.onRewardClaimed});

  @override
  State<SquadLudoModal> createState() => _SquadLudoModalState();
}

class _SquadLudoModalState extends State<SquadLudoModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _rollController;
  late Animation<double> _rollAnimation;
  bool _isRolling = false;
  int _diceNumber = 6;
  String? _wonReward;

  final List<String> _possibleRewards = [
    '50% Off Platter Voucher (Code: SQUADLUDO50)',
    'Golden Sparkler Sundae Unlocked!',
    '+200 Sweet Squad Points!',
    'Free Craft Slushie Pitcher!',
  ];

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _rollAnimation = CurvedAnimation(
      parent: _rollController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
    });

    _rollController.forward(from: 0.0).then((_) {
      final random = math.Random();
      final rolled = random.nextInt(6) + 1;
      final reward = _possibleRewards[random.nextInt(_possibleRewards.length)];

      setState(() {
        _isRolling = false;
        _diceNumber = rolled;
        _wonReward = reward;
      });

      widget.onRewardClaimed(reward);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: TreatColors.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.videogame_asset_rounded,
                    color: TreatColors.secondary,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '🎲 Treat Squad Ludo',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: TreatColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Roll the magic dice to advance your squad on the Soho food map and win secret platter vouchers!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: TreatColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Animated Dice
            AnimatedBuilder(
              animation: _rollAnimation,
              builder: (context, child) {
                final angle = _rollAnimation.value * 2 * math.pi * 2;
                final scale = 1.0 + (_rollAnimation.value * 0.2);

                return Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: angle,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE040A0),
                            Color(0xFF7C52AA),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TreatColors.secondary.withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getDiceEmoji(_diceNumber),
                          style: const TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),

            if (_wonReward != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: TreatColors.primaryFixed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'You Rolled a $_diceNumber! 🎯',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: TreatColors.onPrimaryFixed,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _wonReward!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: TreatColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isRolling ? null : _rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TreatColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  _isRolling
                      ? 'Rolling...'
                      : (_wonReward != null ? 'Roll Again! 🎲' : 'Roll Dice! 🎲'),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.plusJakartaSans(
                  color: TreatColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDiceEmoji(int num) {
    switch (num) {
      case 1:
        return '⚀';
      case 2:
        return '⚁';
      case 3:
        return '⚂';
      case 4:
        return '⚃';
      case 5:
        return '⚄';
      case 6:
      default:
        return '⚅';
    }
  }
}
