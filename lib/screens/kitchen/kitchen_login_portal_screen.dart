import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/kitchen_partner_state.dart';

/// Kitchen & Host Portal Login Screen
/// Faithfully reproduces the kitchen_partner_login_portal design wireframe
class KitchenLoginPortalScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onReturnDiner;

  const KitchenLoginPortalScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onReturnDiner,
  });

  @override
  State<KitchenLoginPortalScreen> createState() => _KitchenLoginPortalScreenState();
}

class _KitchenLoginPortalScreenState extends State<KitchenLoginPortalScreen> {
  int _selectedTab = 0; // 0: Terminal PIN, 1: Manager Email
  String _selectedRole = 'Manager'; // 'Manager' or 'Staff'
  bool _lockHardwareId = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<KitchenPartnerState>();

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
              top: -40,
              right: -40,
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 214, 238, 0.40),
                ),
              ),
            ),
            Positioned(
              top: 260,
              left: -50,
              child: Container(
                width: 230,
                height: 230,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(238, 220, 255, 0.45),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // 1. Top Avatar Badge (Purple-Pink gradient with cyan kitchen badge)
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF7C52AA), Color(0xFFE040A0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(224, 64, 160, 0.28),
                                      blurRadius: 18,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0096CC),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.soup_kitchen,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 2. Access Badge Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEDCFF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_user,
                                size: 14,
                                color: Color(0xFF7C52AA),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Kitchen & Host Access Only',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF4A3068),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 3. Title & Subtitle
                        Text(
                          'Kitchen & Host Portal',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: const Color(0xFF1F1B1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to manage live prep orders, redeem diner voucher slips, and toggle stock in real time.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            height: 1.45,
                            color: const Color(0xFF5B403A),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 4. Mode Switcher Tabs (Terminal PIN vs Manager Email)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2E8F2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTabBtn(
                                  index: 0,
                                  icon: Icons.dialpad,
                                  title: 'Terminal PIN',
                                ),
                              ),
                              Expanded(
                                child: _buildTabBtn(
                                  index: 1,
                                  icon: Icons.badge_outlined,
                                  title: 'Manager Email',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // If Terminal PIN mode is selected
                        if (_selectedTab == 0) ...[
                          // 5. Merchant & Kitchen Code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.storefront,
                                    size: 16,
                                    color: Color(0xFF7C52AA),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Merchant & Kitchen Code',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F1B1A),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Lookup ID',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0096CC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          Container(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFDCC8E0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.04),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.partner.merchantCode,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: const Color(0xFF1F1B1A),
                                  ),
                                ),
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Color(0xFF0096CC),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFF5B403A),
                                  ),
                                  children: const [
                                    TextSpan(text: 'Assigned: '),
                                    TextSpan(
                                      text: 'Spice & Sizzle Grillhouse',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F1B1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 6. Select Terminal Role
                          Row(
                            children: [
                              const Icon(
                                Icons.table_restaurant,
                                size: 16,
                                color: Color(0xFF7C52AA),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Select Terminal Role',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1F1B1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: _buildRoleCard(
                                  title: 'Manager',
                                  subtitle: 'Full Terminal & Audit',
                                  icon: Icons.shield_outlined,
                                  isSelected: _selectedRole == 'Manager',
                                  onTap: () => setState(() => _selectedRole = 'Manager'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildRoleCard(
                                  title: 'Staff',
                                  subtitle: 'Orders & Service',
                                  icon: Icons.badge_outlined,
                                  isSelected: _selectedRole == 'Staff',
                                  onTap: () => setState(() => _selectedRole = 'Staff'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // 7. 4-Digit Staff PIN Pad Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0x337C52AA),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.08),
                                  blurRadius: 20,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.lock_outline,
                                      size: 15,
                                      color: Color(0xFF5B403A),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Enter 4-Digit Staff PIN',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF5B403A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // 4 PIN Indicator Dots
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (index) {
                                    final isFilled = index < state.enteredPin.length;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      width: 13,
                                      height: 13,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isFilled
                                            ? const Color(0xFF7C52AA)
                                            : const Color(0xFFECE2EC),
                                        border: isFilled
                                            ? Border.all(
                                                color: const Color(0xFFEEDCFF),
                                                width: 3,
                                              )
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 18),

                                // Keypad Grid (3x4)
                                SizedBox(
                                  width: 270,
                                  child: Column(
                                    children: [
                                      _buildKeypadRow(['1', '2', '3'], state),
                                      const SizedBox(height: 10),
                                      _buildKeypadRow(['4', '5', '6'], state),
                                      const SizedBox(height: 10),
                                      _buildKeypadRow(['7', '8', '9'], state),
                                      const SizedBox(height: 10),
                                      _buildKeypadRow(['C', '0', '⌫'], state),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ] else ...[
                          // Manager Email Mode
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFDCC8E0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(124, 82, 170, 0.06),
                                  blurRadius: 18,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Authorized Partner Email',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1F1B1A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 46,
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
                                            hintText: 'e.g. chef@spiceandsizzle.com',
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Security Password',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1F1B1A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF2FB),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.key, size: 18, color: Color(0xFF7C52AA)),
                                      const SizedBox(width: 8),
                                      const Expanded(
                                        child: TextField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: '••••••••••••',
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          size: 18,
                                          color: const Color(0xFF7C52AA),
                                        ),
                                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // 8. Lock Hardware Checkbox
                        InkWell(
                          onTap: () => setState(() => _lockHardwareId = !_lockHardwareId),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _lockHardwareId
                                        ? const Color(0xFFE040A0)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _lockHardwareId
                                          ? const Color(0xFFE040A0)
                                          : const Color(0xFFDCC8E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _lockHardwareId
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Lock to this terminal hardware ID (KDS Station #1)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF5B403A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 9. Main Action CTA: OPEN LIVE KITCHEN SCREEN ➔
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onLoginSuccess,
                            borderRadius: BorderRadius.circular(999),
                            child: Ink(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7C52AA), Color(0xFFE040A0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(124, 82, 170, 0.40),
                                    blurRadius: 20,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'OPEN LIVE KITCHEN SCREEN',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 10. Strictly Authorized Personnel Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF2FB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEAE1DE)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC8EAFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shield,
                                  size: 18,
                                  color: Color(0xFF0096CC),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Strictly Authorized Personnel',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F1B1A),
                                      ),
                                    ),
                                    Text(
                                      'PCI-DSS Compliant • TLS 1.3 Order Isolation Active',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        color: const Color(0xFF5B403A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 11. Return to Diner Gateway & Explore Link
                        InkWell(
                          onTap: widget.onReturnDiner,
                          borderRadius: BorderRadius.circular(999),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Color(0xFF7C52AA),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Return to Diner Gateway & Explore',
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

  Widget _buildTabBtn({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C52AA) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(124, 82, 170, 0.25),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF604868),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF604868),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCEAF5) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFE040A0) : const Color(0xFFDCC8E0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(224, 64, 160, 0.14),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFD6EE) : const Color(0xFFF8EEF8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: isSelected ? const Color(0xFFE040A0) : const Color(0xFF7C52AA),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F1B1A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: const Color(0xFF5B403A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys, KitchenPartnerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) {
        return InkWell(
          onTap: () {
            if (key == 'C') {
              state.clearPin();
            } else if (key == '⌫') {
              state.backspacePin();
            } else {
              state.appendPinDigit(key);
            }
          },
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 78,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EEF8),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: key == '⌫'
                ? const Icon(
                    Icons.backspace_outlined,
                    size: 18,
                    color: Color(0xFF5B403A),
                  )
                : Text(
                    key,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F1B1A),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
