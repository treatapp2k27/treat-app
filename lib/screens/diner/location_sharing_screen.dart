import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../widgets/radar_pulse_widget.dart';

class LocationSharingScreen extends StatefulWidget {
  final VoidCallback onEnableLocation;
  final VoidCallback onSkip;
  final ValueChanged<String>? onLocationSelected;

  const LocationSharingScreen({
    super.key,
    required this.onEnableLocation,
    required this.onSkip,
    this.onLocationSelected,
  });

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  void _showCityZipDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFF2E8FC),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('📍', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Set Your Location',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: const Color(0xFF201A24),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your city name or postal zip code to find foodie platters nearby:',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: const Color(0xFF706776),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF201A24),
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Brooklyn, NY or 11201',
                hintStyle: GoogleFonts.dmSans(color: const Color(0xFFA098A5), fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFFBF6FD),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF7C52AA), width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF706776),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C52AA),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              final input = controller.text.trim();
              if (widget.onLocationSelected != null && input.isNotEmpty) {
                widget.onLocationSelected!(input);
              } else {
                widget.onSkip();
              }
            },
            child: Text(
              'Save & Continue',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: Stack(
        children: [
          // Ambient Gradient Background Accents
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFCE4EC).withValues(alpha: 0.6),
                    const Color(0xFFF3E5F5).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEDE7F6).withValues(alpha: 0.5),
                    const Color(0xFFFCE4EC).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top Bar: Logo Centered & Skip Button on Right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 48),
                              Image.asset(
                                AssetConstants.logo,
                                height: 38,
                                errorBuilder: (_, __, ___) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Color(0xFFEF4444), Color(0xFFE040A0), Color(0xFFFB923C)],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text('🎉', style: TextStyle(fontSize: 13)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'treat',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22,
                                        color: const Color(0xFF201A24),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(left: 2, top: 12),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFD08364),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 48,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(44, 32),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: widget.onSkip,
                                    child: Text(
                                      'Skip',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF706776),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Hero Radar Visual with concentric pulses and floating pins
                          const Center(
                            child: RadarPulseWidget(size: 210),
                          ),
                          const SizedBox(height: 12),

                          // Hero Headings
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF201A24),
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                              children: [
                                const TextSpan(text: 'Find Tasty Deals\n'),
                                TextSpan(
                                  text: 'Around You 📍',
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFF7C52AA),
                                          Color(0xFFE040A0),
                                          Color(0xFFF43F5E),
                                        ],
                                      ).createShader(const Rect.fromLTWH(0, 0, 240, 36)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Share your location to unlock secret foodie platters and instant drops nearby.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 13.5,
                                color: const Color(0xFF706776),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Value Proposition Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFF3E8FC),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.06),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF2E8FC),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '⚡',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Instant food deals & table drops within walking distance',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF201A24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE7F6FC),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '🔒',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '100% anonymous — never tracked in background',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF201A24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          const SizedBox(height: 14),

                          // Action Buttons Footer
                          // Primary Button: Allow Location Access ⚡
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.onEnableLocation,
                              borderRadius: BorderRadius.circular(999),
                              child: Ink(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7C52AA),
                                      Color(0xFF985EC9),
                                      Color(0xFFE040A0),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(124, 82, 170, 0.35),
                                      blurRadius: 18,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Allow Location Access',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('⚡', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Secondary Button: Enter City or Zip Code
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _showCityZipDialog,
                              borderRadius: BorderRadius.circular(999),
                              child: Ink(
                                height: 46,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xFFE2D6EE),
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Enter City or Zip Code',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF201A24),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Tertiary Text Button: Not now
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              minimumSize: const Size(80, 32),
                            ),
                            onPressed: widget.onSkip,
                            child: Text(
                              'Not now',
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF706776),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Security Guarantee Note
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  size: 13,
                                  color: Color(0xFF0096CC),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'You can change location permissions anytime in Settings.',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    color: const Color(0xFF706776),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
