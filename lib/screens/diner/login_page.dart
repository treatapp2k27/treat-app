import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/treat_animated_logo.dart';

/// Redesigned Foodie & Diner Login Screen
/// - 'Choose Your Persona' removed
/// - 'Sign in with Treat Account' featured on top with visible 'Member Credentials' (Email & Password)
/// - 'Treat Sign In' button replacing 'Authorize & Continue'
/// - Rearranged Google & Facebook social login buttons below
class LoginPage extends StatefulWidget {
  final VoidCallback onEnterGuest;
  final VoidCallback? onBack;

  const LoginPage({
    super.key,
    required this.onEnterGuest,
    this.onBack,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Backwards compatibility alias
typedef WelcomeAnonymousScreen = LoginPage;

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                          height: 68,
                        ),
                        const SizedBox(height: 12),

                        // 2. Headline & Subtitle
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
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
                        const SizedBox(height: 6),

                        Text(
                          'Welcome back! Sign in to access your saved spots, treats & squad bill splits.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B403A),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 3. Primary Card: "Sign in with Treat Account" & Member Credentials
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFFFD6EE),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(224, 64, 160, 0.10),
                                blurRadius: 26,
                                offset: Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(124, 82, 170, 0.05),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header: "Sign in with Treat Account"
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFD6EE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock_rounded,
                                      size: 19,
                                      color: Color(0xFFE040A0),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Sign in with Treat Account',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1F1B1A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Email Address Field
                              Text(
                                'Email Address',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3F2B39),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 46,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBF2FB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFDCC8E0),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.mail_outline_rounded,
                                      size: 18,
                                      color: Color(0xFF7C52AA),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1F1B1A),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter your email',
                                          hintStyle: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF9E8E9B),
                                            fontSize: 13,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Password Field
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF3F2B39),
                                    ),
                                  ),
                                  Text(
                                    'Forgot?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFE040A0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 46,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBF2FB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFDCC8E0),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.key_rounded,
                                      size: 18,
                                      color: Color(0xFF7C52AA),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1F1B1A),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          hintStyle: GoogleFonts.plusJakartaSans(
                                            color: const Color(0xFF9E8E9B),
                                            fontSize: 13,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        size: 18,
                                        color: const Color(0xFF7C52AA),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Treat Sign In Button (Replaces 'Authorize & Continue')
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: widget.onEnterGuest,
                                  borderRadius: BorderRadius.circular(999),
                                  child: Ink(
                                    height: 48,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFF054B0), Color(0xFFE040A0)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(224, 64, 160, 0.35),
                                          blurRadius: 16,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.login_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Treat Sign In',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 4. Divider Ribbon: "OR CONNECT WITH"
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
                                  'OR CONNECT WITH',
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

                        // 5. Rearranged Google & Facebook Login Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialPill(
                                label: 'Google',
                                iconWidget: _buildGoogleGIcon(),
                                onTap: widget.onEnterGuest,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildSocialPill(
                                label: 'Facebook',
                                iconWidget: const Icon(Icons.facebook, size: 21, color: Color(0xFF1877F2)),
                                onTap: widget.onEnterGuest,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 6. Footer Guarantee
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 15,
                              color: Color(0xFF0096CC),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Safe, cashless and verified local spots.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF5B403A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: const Color(0xFFDCC8E0),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 82, 170, 0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1B1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleGIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'G',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4285F4),
            ),
          ),
        ],
      ),
    );
  }
}