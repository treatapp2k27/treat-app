import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/diner_state.dart';
import '../../widgets/treat_animated_logo.dart';

/// Foodie & Diner Sign In / Persona Customization Screen
/// Matches the exact 'welcome_anonymous_login' wireframe & design specifications
class WelcomeAnonymousScreen extends StatefulWidget {
  final VoidCallback onEnterGuest;
  final VoidCallback? onBack;

  const WelcomeAnonymousScreen({
    super.key,
    required this.onEnterGuest,
    this.onBack,
  });

  @override
  State<WelcomeAnonymousScreen> createState() => _WelcomeAnonymousScreenState();
}

class _WelcomeAnonymousScreenState extends State<WelcomeAnonymousScreen> {
  final TextEditingController _handleController = TextEditingController();
  bool _isEmailDrawerExpanded = false;
  final List<String> _emojis = ['🥟', '🧋', '🍕', '🌮', '🍩'];
  final List<String> _quickPicks = ['TacoFiend', 'BobaBandit', 'SweetTooth'];

  @override
  void initState() {
    super.initState();
    final currentHandle = context.read<DinerState>().currentPersona.handle;
    _handleController.text = currentHandle;
  }

  @override
  void dispose() {
    _handleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final persona = dinerState.currentPersona;

    if (_handleController.text != persona.handle && !_handleController.selection.isValid) {
      _handleController.text = persona.handle;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFEF7FF),
              Color(0xFFF8F1F9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Ambient Atmospheric Glows
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 214, 238, 0.45),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: -50,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(238, 220, 255, 0.50),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top Back Button Row
                        if (widget.onBack != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: widget.onBack,
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFDCC8E0)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(124, 82, 170, 0.08),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                  color: Color(0xFF1F1B1A),
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 6),

                        // 1. Treat Animated 3D Mascot Logo
                        const TreatAnimatedLogo(
                          height: 72,
                        ),
                        const SizedBox(height: 12),

                        // 2. Headline & Subtitle
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              color: const Color(0xFF1F1B1A),
                              height: 1.22,
                            ),
                            children: const [
                              TextSpan(text: 'Treat your circle,\n'),
                              TextSpan(
                                text: 'stay in budget.',
                                style: TextStyle(
                                  color: Color(0xFFE040A0), // Vibrant candy berry pink
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Spontaneous indulgence and pocket-friendly dining deals made for foodies with friends.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B403A),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Interactive Card: "Choose Your Persona"
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFFFD6EE),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(224, 64, 160, 0.12),
                                blurRadius: 28,
                                offset: Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(124, 82, 170, 0.06),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFD6EE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.theater_comedy,
                                      size: 18,
                                      color: Color(0xFFE040A0),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Choose Your Persona',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1F1B1A),
                                          ),
                                        ),
                                        Text(
                                          'No signup or real identity required',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: const Color(0xFF5B403A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Pick Vibe Avatar Row
                              Row(
                                children: [
                                  const Icon(
                                    Icons.sentiment_satisfied_alt,
                                    size: 15,
                                    color: Color(0xFFE040A0),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Pick your vibe avatar:',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF5B403A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 5 Emojis with Selection Ring + Checkmark
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: _emojis.map((emoji) {
                                  final isSelected = emoji == persona.avatarEmoji;
                                  return InkWell(
                                    onTap: () => dinerState.setAvatarEmoji(emoji),
                                    borderRadius: BorderRadius.circular(999),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFFFD6EE)
                                                : const Color(0xFFF8EEF8),
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(
                                                    color: const Color(0xFFE040A0),
                                                    width: 2.5,
                                                  )
                                                : Border.all(
                                                    color: const Color(0xFFE8DCE8),
                                                    width: 1,
                                                  ),
                                            boxShadow: isSelected
                                                ? const [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(224, 64, 160, 0.35),
                                                      blurRadius: 12,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            emoji,
                                            style: const TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            bottom: -1,
                                            right: -1,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE040A0),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                size: 11,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 14),

                              // Foodie Handle Input + Shuffle Button
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFBF2FB),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: const Color(0xFFDCC8E0),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.edit_note,
                                            size: 20,
                                            color: Color(0xFFE040A0),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              controller: _handleController,
                                              onChanged: (val) => dinerState.setHandle(val),
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF2E1A28),
                                              ),
                                              decoration: const InputDecoration(
                                                hintText: 'Enter foodie handle',
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      dinerState.shufflePersona();
                                      _handleController.text = dinerState.currentPersona.handle;
                                    },
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEDCFF),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: const Color(0xFFDCC8E0),
                                          width: 1,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(124, 82, 170, 0.12),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.casino,
                                            size: 17,
                                            color: Color(0xFF7C52AA),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Shuffle',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF4A3068),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Quick Picks Row
                              Row(
                                children: [
                                  Text(
                                    'Quick picks:',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: const Color(0xFF8F7069),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: _quickPicks.map((pick) {
                                        return InkWell(
                                          onTap: () {
                                            dinerState.setHandle(pick);
                                            _handleController.text = pick;
                                          },
                                          borderRadius: BorderRadius.circular(999),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFCEAF5),
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(
                                                color: const Color(0xFFFFD8E8),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              pick,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFFB2107B),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4. Primary CTA Button: "Enter as Anonymous Guest ➔"
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onEnterGuest,
                            borderRadius: BorderRadius.circular(999),
                            child: Ink(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7C52AA), Color(0xFF633990)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(124, 82, 170, 0.45),
                                    blurRadius: 22,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enter as Anonymous Guest',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 19,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 5. Divider Ribbon: "OR SIGN IN WITH"
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Divider(color: Color(0xFFEAE1DE), thickness: 1),
                              Container(
                                color: const Color(0xFFFEF7FF),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                                child: Text(
                                  'OR SIGN IN WITH',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: const Color(0xFF8F7069),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 6. Social Authentication (Google, Apple, Facebook)
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialPill(
                                label: 'Google',
                                iconWidget: _buildGoogleGIcon(),
                                onTap: widget.onEnterGuest,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSocialPill(
                                label: 'Apple',
                                iconWidget: const Icon(Icons.apple, size: 20, color: Colors.black),
                                onTap: widget.onEnterGuest,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSocialPill(
                                label: 'Facebook',
                                iconWidget: const Icon(Icons.facebook, size: 20, color: Color(0xFF1877F2)),
                                onTap: widget.onEnterGuest,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 7. Member Login Pill Drawer Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isEmailDrawerExpanded = !_isEmailDrawerExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8EEF8),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFFDCC8E0),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isEmailDrawerExpanded ? Icons.lock_open : Icons.lock_outline,
                                  size: 18,
                                  color: const Color(0xFF7C52AA),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isEmailDrawerExpanded
                                      ? 'Hide Member Login'
                                      : 'Sign In with Treat Account',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7C52AA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Collapsible Member Drawer
                        if (_isEmailDrawerExpanded) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFDCC8E0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.08),
                                  blurRadius: 14,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Member Credentials',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1F1B1A),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF2FB),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.mail_outline, size: 18, color: Color(0xFF7C52AA)),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Email address',
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF2FB),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.key, size: 18, color: Color(0xFF7C52AA)),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: widget.onEnterGuest,
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    height: 44,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFF054B0), Color(0xFFE040A0)],
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(224, 64, 160, 0.35),
                                          blurRadius: 14,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Authorize & Continue',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // 8. Footer Guarantee
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Color(0xFF0096CC),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'No real names required. Split easily, eat happily.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5B403A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialPill({
    required String label,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFFDCC8E0),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 82, 170, 0.05),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1B1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleGIcon() {
    return SizedBox(
      width: 18,
      height: 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'G',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4285F4),
            ),
          ),
        ],
      ),
    );
  }
}