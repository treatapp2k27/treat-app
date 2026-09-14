import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/asset_constants.dart';

/// Social Screen supporting:
/// 1. Community Bar / Foodie Groups (Featured Group, Member Badges, Group Cards, New Group)
/// 2. Food Bar Chat (Pinned Host, BobaBandit Churro Sundae, TacoFiend Thread, Live Poll, Chat Input)
/// 3. Savings Wall Leaderboard
class TreatSocialScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback? onExploreTreats;
  final VoidCallback? onNavigateProfile;
  final int initialTab;
  final bool showSwitcher;

  const TreatSocialScreen({
    super.key,
    required this.onOpenDrawer,
    this.onExploreTreats,
    this.onNavigateProfile,
    this.initialTab = 1,
    this.showSwitcher = true,
  });

  @override
  State<TreatSocialScreen> createState() => _TreatSocialScreenState();
}

class _TreatSocialScreenState extends State<TreatSocialScreen> {
  late int _activeTab;
  int _groupFilter = 0; // 0: All Groups, 1: Public Groups, 2: Private Squads

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Featured Group Interaction States
  bool _isFeaturedStarred = false;
  bool _isFeaturedNotified = false;

  // Joined Groups Tracking
  final Set<String> _joinedGroups = {};

  // Host Announcement Reactions Count
  int _claimedCount = 42;
  bool _hasClaimed = false;
  int _onMyWayCount = 8;
  bool _hasOnMyWay = false;
  int _hostLoveCount = 27;
  bool _hasHostLoved = false;

  // BobaBandit Post Reactions
  int _droolingCount = 24;
  int _fireDealCount = 16;
  int _downToSplitCount = 9;
  int _postLoveCount = 31;

  // TacoFiend Thread Reactions
  int _yesItDoesCount = 12;
  int _worthItCount = 19;
  int _tacoThumbsCount = 15;

  // Live Poll State
  int _ramenVotes = 34;
  int _wafflesVotes = 21;
  int? _userVotedOption; // 0 for Ramen, 1 for Waffles

  // Live Food Bar Chat messages list
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'author': 'BobaQueen',
      'avatar': '🧋',
      'text': 'Anyone at Sugar Smash right now? Is the line long?',
      'time': '12:04 PM',
      'isMe': false,
    },
    {
      'author': 'MidnightDumpling',
      'avatar': '🥟',
      'text': 'Just got seated! Table ready immediately with Treat pass 🟢',
      'time': '12:05 PM',
      'isMe': true,
    },
    {
      'author': 'WaffleKing',
      'avatar': '🧇',
      'text': 'Use code WEEKENDVIBE for ৳20 off group platters today guys!',
      'time': '12:08 PM',
      'isMe': false,
    },
    {
      'author': 'SpicyNoodle',
      'avatar': '🍜',
      'text': 'Need 2 more sweeties to split the 6-person Mega Donut tower at 1pm!',
      'time': '12:11 PM',
      'isMe': false,
    },
  ];

  // Feed posts for community pulse
  final List<Map<String, dynamic>> _feedPosts = [
    {
      'id': 'post_1',
      'author': 'MidnightDumpling',
      'avatar': '🥟',
      'district': 'Midtown',
      'timeAgo': '12 mins ago',
      'savedAmount': 'Saved ৳32',
      'text':
          'Just crushed the 4-person slider & shake platter at Sprinkle & Sizzle! Split 4 ways with @TacoFiend and it was only ৳8 each!',
      'likes': 42,
      'isLiked': true,
      'replies': 8,
      'tag': 'Slider Platter',
    },
    {
      'id': 'post_2',
      'author': 'TacoFiend',
      'avatar': '🌮',
      'district': 'SoHo Arts',
      'timeAgo': '35 mins ago',
      'savedAmount': 'Saved ৳20',
      'text':
          'Voucher TREAT50 worked like magic on the Fiesta Taco Tray. Table sparklers on the boba tower were unreal ✨',
      'likes': 89,
      'isLiked': false,
      'replies': 14,
      'tag': 'TREAT50 Used',
    },
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage([String? customText]) {
    final text = (customText ?? _chatController.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({
        'author': 'MidnightDumpling',
        'avatar': '🥟',
        'text': text,
        'time': 'Just now',
        'isMe': true,
      });
      if (customText == null) {
        _chatController.clear();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleFeedLike(String postId) {
    setState(() {
      final post = _feedPosts.firstWhere((p) => p['id'] == postId);
      if (post['isLiked'] == true) {
        post['isLiked'] = false;
        post['likes'] = (post['likes'] as int) - 1;
      } else {
        post['isLiked'] = true;
        post['likes'] = (post['likes'] as int) + 1;
      }
    });
  }

  void _showNewGroupDialog({bool isSecret = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final groupNameCtrl = TextEditingController();
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 24,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSecret ? const Color(0xFFFCE7F3) : const Color(0xFFEDE8FC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSecret ? Icons.lock_rounded : Icons.groups_rounded,
                      color: isSecret ? const Color(0xFF9D174D) : const Color(0xFF7C52AA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isSecret ? 'Create Secret Squad' : 'Create New Foodie Group',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F1528),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: groupNameCtrl,
                decoration: InputDecoration(
                  hintText: isSecret ? 'e.g. Table 4 Secret Feast' : 'e.g. East Village Boba Crawl',
                  filled: true,
                  fillColor: const Color(0xFFF9F5FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE9D5FF)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B2375),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isSecret ? 'Secret Squad Created! 🔒' : 'Foodie Group Created! 🎉'),
                        backgroundColor: const Color(0xFF5B2375),
                      ),
                    );
                  },
                  child: const Text('Confirm & Launch', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FD),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(),

            // Top Segment Switcher Pill
            if (widget.showSwitcher) _buildSegmentSwitcher(),

            // Active Tab Content
            Expanded(
              child: _buildActiveTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. Top App Bar ---
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          // Hamburger Menu
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1F1528), size: 24),
            onPressed: widget.onOpenDrawer,
          ),
          const Spacer(),
          // Treat Logo
          Image.asset(
            AssetConstants.logo,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              'treat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF7C52AA),
              ),
            ),
          ),
          const Spacer(),
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1F1528), size: 22),
            onPressed: widget.onExploreTreats,
          ),
          // Circular Profile Avatar (#5B2375) - Redirects to Profile Settings
          InkWell(
            onTap: widget.onNavigateProfile,
            borderRadius: BorderRadius.circular(999),
            child: Tooltip(
              message: 'Profile Settings',
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B2375),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Top Segment Switcher ---
  Widget _buildSegmentSwitcher() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFEADBEE), width: 1),
      ),
      child: Row(
        children: [
          // Community Feed / Foodie Groups
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTab = 0),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: BoxDecoration(
                  color: _activeTab == 0 ? const Color(0xFF5B2375) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Community Feed',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: _activeTab == 0 ? FontWeight.w800 : FontWeight.w600,
                      color: _activeTab == 0 ? Colors.white : const Color(0xFF6B5E74),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Food Bar Chat (with • 3+ badge)
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTab = 1),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: _activeTab == 1 ? const Color(0xFF5B2375) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Food Bar Chat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: _activeTab == 1 ? FontWeight.w800 : FontWeight.w600,
                          color: _activeTab == 1 ? Colors.white : const Color(0xFF6B5E74),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBE185D),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '• 3+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Active Tab Body ---
  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildCommunityGroupsView();
      case 1:
        return _buildFoodBarChatView();
      case 2:
        return _buildSavingsWallView();
      default:
        return _buildCommunityGroupsView();
    }
  }

  // ==========================================
  // VIEW 1: COMMUNITY & SQUADS / FOODIE GROUPS
  // ==========================================
  Widget _buildCommunityGroupsView() {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Header & "+ New Group"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMMUNITY & SQUADS',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF9D174D),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Foodie Groups',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1F1528),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showNewGroupDialog(isSecret: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B2375),
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      'New Group',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Featured Group Card ("Late Night Dessert Hunt 🍦")
              _buildFeaturedGroupCard(),

              const SizedBox(height: 16),

              // Group Filter Pills
              _buildGroupFilterPills(),

              const SizedBox(height: 12),

              // Filtered Group Cards
              if (_groupFilter == 0 || _groupFilter == 1)
                _buildBobaGossipCard(),

              if (_groupFilter == 0 || _groupFilter == 2) ...[
                const SizedBox(height: 12),
                _buildKoreanBbqCard(),
              ],

              if (_groupFilter == 0 || _groupFilter == 1) ...[
                const SizedBox(height: 12),
                _buildBrunchMeetupCard(),
              ],
            ],
          ),
        ),

        // Sticky Bottom Buttons (New Public Group & Secret Squad Group)
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showNewGroupDialog(isSecret: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B2375),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  icon: const Icon(Icons.public, size: 18),
                  label: const Text(
                    'New Public Group',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showNewGroupDialog(isSecret: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCE7F3),
                    foregroundColor: const Color(0xFF9D174D),
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: const BorderSide(color: Color(0xFFFBCFE8)),
                    ),
                  ),
                  icon: const Icon(Icons.lock, size: 16),
                  label: const Text(
                    'Secret Squad Group',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedGroupCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0E5F8), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D174D), Color(0xFFBE185D)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'FEATURED GROUP • PUBLIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: Color(0xFF9D174D), size: 13),
                    SizedBox(width: 3),
                    Text(
                      'Very Active',
                      style: TextStyle(
                        color: Color(0xFF9D174D),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            'Late Night Dessert Hunt 🍨',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Admin: @MidnightDumpling • SoHo, NYC',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7C6D85),
            ),
          ),
          const SizedBox(height: 14),

          // Members Row with Badges
          Row(
            children: [
              _buildMemberAvatar('🥟', 'Dumpling', badge: 'Admin', badgeColor: const Color(0xFF9D174D)),
              const SizedBox(width: 14),
              _buildMemberAvatar('🥞', 'MochiBae', badge: 'Mod', badgeColor: const Color(0xFF7C52AA)),
              const SizedBox(width: 14),
              _buildMemberAvatar('🧋', 'BobaKing', badge: 'Top', badgeColor: const Color(0xFF0D9488)),
              const SizedBox(width: 14),
              _buildMemberAvatar('🌮', 'TacoBro'),
            ],
          ),
          const SizedBox(height: 14),

          // Tags Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildPillTag('Ice Cream Run', const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
              _buildPillTag('SoHo Squad', const Color(0xFFEDE8FC), const Color(0xFF7C52AA)),
              _buildPillTag('Split Bill', const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
            ],
          ),
          const SizedBox(height: 10),

          // Stats
          const Row(
            children: [
              Icon(Icons.groups_rounded, size: 15, color: Color(0xFF9D174D)),
              SizedBox(width: 5),
              Text(
                '2.4k members • 18 posts today',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B5E74),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Row
          Row(
            children: [
              // Notification button
              InkWell(
                onTap: () {
                  setState(() => _isFeaturedNotified = !_isFeaturedNotified);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isFeaturedNotified ? 'Notifications enabled!' : 'Notifications muted'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isFeaturedNotified ? const Color(0xFFEDE8FC) : const Color(0xFFF5EEFB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFeaturedNotified ? Icons.notifications_active : Icons.notifications_none_rounded,
                    size: 18,
                    color: const Color(0xFF7C52AA),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Favorite button
              InkWell(
                onTap: () => setState(() => _isFeaturedStarred = !_isFeaturedStarred),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isFeaturedStarred ? const Color(0xFFFCE7F3) : const Color(0xFFFDF2F8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFeaturedStarred ? Icons.star : Icons.star_border_rounded,
                    size: 18,
                    color: const Color(0xFF9D174D),
                  ),
                ),
              ),
              const Spacer(),
              // View Group & Feed button -> Switches to Food Bar Chat
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _activeTab = 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B2375),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                icon: const Icon(Icons.groups, size: 17),
                label: const Text(
                  'View Group & Feed ➔',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(String emoji, String name, {String? badge, Color? badgeColor}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF3EDF7),
                border: Border.all(color: const Color(0xFFEADBEE), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            if (badge != null)
              Positioned(
                top: -3,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFF9D174D),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4C3E55),
          ),
        ),
      ],
    );
  }

  Widget _buildPillTag(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildGroupFilterPills() {
    final filters = [
      'All Groups (12)',
      'Public Groups',
      'Private Squads 🔒',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (idx) {
          final isSelected = _groupFilter == idx;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _groupFilter = idx),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5B2375) : const Color(0xFFF3EDF7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF5B2375) : const Color(0xFFEADBEE),
                    width: 1,
                  ),
                ),
                child: Text(
                  filters[idx],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF4C3E55),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBobaGossipCard() {
    final isJoined = _joinedGroups.contains('boba');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3EDF7)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('● ', style: TextStyle(color: Color(0xFF9D174D), fontSize: 12)),
                  Icon(Icons.public, size: 14, color: Color(0xFF0284C7)),
                  SizedBox(width: 4),
                  Text(
                    'PUBLIC GROUP • 1.8K MEMBERS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9D174D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Public',
                  style: TextStyle(
                    color: Color(0xFF0369A1),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Boba & Gossip Split 🧋',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Comparing tiger sugar pearls vs cheese foam in East Village. Share daily boba reviews, secret menu hacks, and meetup split checks!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5E74),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Text('🧋 🍰 🍕', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '💬 42 posts this week',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C6D85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (isJoined) {
                      _joinedGroups.remove('boba');
                    } else {
                      _joinedGroups.add('boba');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isJoined ? const Color(0xFFEDE8FC) : const Color(0xFFFCE7F3),
                  foregroundColor: isJoined ? const Color(0xFF7C52AA) : const Color(0xFF9D174D),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                icon: Icon(isJoined ? Icons.check : Icons.group_add, size: 14),
                label: Text(
                  isJoined ? 'Joined' : 'Join Group',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKoreanBbqCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3EDF7)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: Color(0xFF5B2375)),
                  SizedBox(width: 4),
                  Text(
                    'PRIVATE SQUAD',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5B2375),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.key, size: 11, color: Color(0xFF7C52AA)),
                    SizedBox(width: 3),
                    Text(
                      'Passcode',
                      style: TextStyle(
                        color: Color(0xFF7C52AA),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Friday Korean BBQ Feast 🥩',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Host: @BobaBandit & 4 friends',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7C6D85),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8FD),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3EDF7)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Color(0xFF7C6D85)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Locked: Only Table 4 Reservation Members & Approved Guests',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B5E74)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Text('🥩 🍲 🥢', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '🔒 6 members',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C6D85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDF7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hourglass_empty, size: 12, color: Color(0xFF7C6D85)),
                    SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B5E74),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrunchMeetupCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3EDF7)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.event_available, size: 14, color: Color(0xFF0D9488)),
                  SizedBox(width: 4),
                  Text(
                    'UPCOMING MEETUP • 32 GOING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Workshop',
                  style: TextStyle(
                    color: Color(0xFF0F766E),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Brunch Splitting 101 🥞',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Best Sunday buffets in Lower Manhattan + how to handle tip splitting without awkward group math. Host: @TacoFiend.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5E74),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Text('🥞', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '86 Foodies Interested',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C6D85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meetup Reminder Set! 🔔')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFBF1),
                  foregroundColor: const Color(0xFF0F766E),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                icon: const Icon(Icons.notifications_active, size: 13),
                label: const Text(
                  'Set Reminder 🔔',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  // ==========================================
  // VIEW 2: FOOD BAR CHAT / COMMUNITY FEED
  // ==========================================
  Widget _buildFoodBarChatView() {
    return Column(
      children: [
        // Header Banner for Chat
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: const Color(0xFFEDE8FC),
          child: const Row(
            children: [
              Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Live Town Foodie Chat • 128 foodies online',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B2375),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Feed / Chat Items
        Expanded(
          child: ListView(
            controller: _chatScrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            children: [
              // 1. Pinned Host Announcement
              _buildPinnedHostCard(),

              const SizedBox(height: 14),

              // 2. BobaBandit Churro Sundae Post
              _buildBobaBanditPost(),

              const SizedBox(height: 14),

              // 3. TacoFiend Thread Post
              _buildTacoFiendPost(),

              const SizedBox(height: 14),

              // 4. MidnightDumpling Live Poll
              _buildMidnightDumplingLivePoll(),

              if (_chatMessages.isNotEmpty) ...[
                const SizedBox(height: 14),
                // Section Header mentioning the bloc
                _buildChatSectionHeader(),
                const SizedBox(height: 10),
                ..._chatMessages.map((msg) => _buildChatMessageBubble(msg)),
              ],
            ],
          ),
        ),

        // Bottom Action & Chat Input Bar
        _buildChatInputArea(),
      ],
    );
  }

  Widget _buildPinnedHostCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F7), Color(0xFFFBF4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFBCFE8), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF9D174D),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.push_pin, size: 10, color: Colors.white),
                    SizedBox(width: 3),
                    Text(
                      'PINNED HOST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bistro Bella Host',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: const Color(0xFF1F1528),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Just now',
                style: TextStyle(fontSize: 11, color: Color(0xFF7C6D85)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Extra 10% off for the next 4 tables booked through Treat Food Bar before 9 PM! 🍕 ✨ Fast pass code applied automatically!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B2A45),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _hasClaimed = !_hasClaimed;
                    _claimedCount += _hasClaimed ? 1 : -1;
                  });
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _hasClaimed ? const Color(0xFFFCE7F3) : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFBCFE8)),
                  ),
                  child: Text(
                    '🎉 Claimed! ($_claimedCount)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _hasClaimed ? const Color(0xFF9D174D) : const Color(0xFF5B2375),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _hasOnMyWay = !_hasOnMyWay;
                    _onMyWayCount += _hasOnMyWay ? 1 : -1;
                  });
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _hasOnMyWay ? const Color(0xFFEDE8FC) : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE9D5FF)),
                  ),
                  child: Text(
                    '🏃 On my way ($_onMyWayCount)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5B2375),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _hasHostLoved = !_hasHostLoved;
                    _hostLoveCount += _hasHostLoved ? 1 : -1;
                  });
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _hasHostLoved ? const Color(0xFFFCE7F3) : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFBCFE8)),
                  ),
                  child: Text(
                    '❤️ $_hostLoveCount',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBobaBanditPost() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E5F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEDE8FC),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BB',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF5B2375),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '@BobaBandit',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: const Color(0xFF1F1528),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Tier 3 Treatie',
                          style: TextStyle(
                            color: Color(0xFF0369A1),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '4m ago • ChocoLuxe Lab',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7C6D85)),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Color(0xFF7C6D85)),
            ],
          ),
          const SizedBox(height: 10),

          // Message
          Text(
            'Just unlocked the ৳6 Churro Sundae split at ChocoLuxe! Who\'s around campus right now to snag the 2nd bowl? 🤤 🍦',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF33253B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),

          // Sundae Image with Overlay Badge
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    AssetConstants.churroSundae,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF3EDF7),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.icecream, size: 40, color: Color(0xFF7C52AA)),
                          SizedBox(height: 6),
                          Text('Churro Sundae Split', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B2375).withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_offer, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'ChocoLuxe Campus Split • Save 50%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Reaction Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildReactionChip('🤤 Drooling ($_droolingCount)', () {
                  setState(() => _droolingCount++);
                }),
                const SizedBox(width: 6),
                _buildReactionChip('🔥 Fire Deal ($_fireDealCount)', () {
                  setState(() => _fireDealCount++);
                }),
                const SizedBox(width: 6),
                _buildReactionChip('⚡ Down to Split! ($_downToSplitCount)', () {
                  setState(() => _downToSplitCount++);
                }),
                const SizedBox(width: 6),
                _buildReactionChip('💖 $_postLoveCount', () {
                  setState(() => _postLoveCount++);
                }),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F5FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEADBEE)),
                    ),
                    child: const Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      size: 15,
                      color: Color(0xFF7C6D85),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Emoji Quick Reaction Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6FD),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFF0E5F8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ['😅', '🍕', '🥳', '💸', '🌮', '💖'].map((emoji) {
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reacted $emoji!'), duration: const Duration(milliseconds: 600)),
                    );
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(emoji, style: const TextStyle(fontSize: 15)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F5FF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFEADBEE)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5B2375),
          ),
        ),
      ),
    );
  }

  Widget _buildTacoFiendPost() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E5F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFCE7F3),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'TF',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF9D174D),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '@TacoFiend',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: const Color(0xFF1F1528),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('●', style: TextStyle(color: Color(0xFF9D174D), fontSize: 8)),
                    ],
                  ),
                  const Text('11m ago', style: TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
                ],
              ),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 18, color: Color(0xFF7C6D85)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Anyone tried the Mega Birria Platter at Taco Bodega? Does the 30% Treat code stack with student discount? 🌮 🧀',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF33253B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildReactionChip('💡 Yes it does! ($_yesItDoesCount)', () {
                setState(() => _yesItDoesCount++);
              }),
              _buildReactionChip('🙌 Worth it ($_worthItCount)', () {
                setState(() => _worthItCount++);
              }),
              _buildReactionChip('👍 $_tacoThumbsCount', () {
                setState(() => _tacoThumbsCount++);
              }),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening thread replies...')),
              );
            },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDF7),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 13, color: Color(0xFF5B2375)),
                  SizedBox(width: 6),
                  Text(
                    'Reply in thread (4 replies) ➔',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5B2375),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMidnightDumplingLivePoll() {
    final totalVotes = _ramenVotes + _wafflesVotes;
    final ramenPct = totalVotes > 0 ? ((_ramenVotes / totalVotes) * 100).round() : 50;
    final wafflesPct = 100 - ramenPct;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E5F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFCCFBF1),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'MD',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F766E),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '@MidnightDumpl...',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: const Color(0xFF1F1528),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE7F3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Poll Maker',
                            style: TextStyle(
                              color: Color(0xFF9D174D),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text('22m ago • Food Poll', style: TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 7, color: Color(0xFF7C52AA)),
                    SizedBox(width: 4),
                    Text(
                      'LIVE POLL',
                      style: TextStyle(
                        color: Color(0xFF7C52AA),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Dinner dilemma: Boba Lounge sweet waffles OR Spicy Miso Ramen? Vote below! 🍜 🧇',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF33253B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),

          // Poll Option 1 (Spicy Miso Ramen)
          _buildPollOptionBar(
            title: '🍜 Spicy Miso Ramen',
            percent: ramenPct,
            isSelected: _userVotedOption == 0,
            fillColor: const Color(0xFFEDE8FC),
            onTap: () {
              if (_userVotedOption == null) {
                setState(() {
                  _userVotedOption = 0;
                  _ramenVotes++;
                });
              }
            },
          ),
          const SizedBox(height: 8),

          // Poll Option 2 (Sweet Boba Waffles)
          _buildPollOptionBar(
            title: '🧇 Sweet Boba Waffles',
            percent: wafflesPct,
            isSelected: _userVotedOption == 1,
            fillColor: const Color(0xFFFCE7F3),
            onTap: () {
              if (_userVotedOption == null) {
                setState(() {
                  _userVotedOption = 1;
                  _wafflesVotes++;
                });
              }
            },
          ),
          const SizedBox(height: 10),

          // Poll Stats Footer
          Row(
            children: [
              Text('🍜 $_ramenVotes votes', style: const TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
              const SizedBox(width: 10),
              Text('🧇 $_wafflesVotes votes', style: const TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.timer_outlined, size: 12, color: Color(0xFF7C6D85)),
                  SizedBox(width: 3),
                  Text('12 mins left', style: TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollOptionBar({
    required String title,
    required int percent,
    required bool isSelected,
    required Color fillColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF8FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C52AA) : const Color(0xFFEADBEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Fill Progress
            FractionallySizedBox(
              widthFactor: percent / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            // Text Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1528),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5B2375),
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

  Widget _buildChatMessageBubble(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEDE8FC),
              child: Text(msg['avatar'] as String, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF5B2375) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.03),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      msg['author'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF9D174D),
                      ),
                    ),
                  Text(
                    msg['text'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: isMe ? Colors.white : const Color(0xFF1F1528),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg['time'] as String,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: isMe ? Colors.white70 : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF5B2375),
              child: Text(msg['avatar'] as String, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ],
      ),
    );
  }

  // --- Chat Section Header mentioning the bloc ---
  Widget _buildChatSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E5F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(91, 35, 117, 0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Food Bar Chat',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF5B2375),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Live Room',
              style: TextStyle(
                color: Color(0xFF9D174D),
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              'Chatting in Food Bar Chat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7C6D85),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Chat Input Area ---
  Widget _buildChatInputArea() {
    final chips = ['🤤 Craving', '🔥 Super Deal', '👥 Where at?', '🌮 ...'];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3EDF7))),
      ),
      child: Column(
        children: [
          // Mention the bloc while chatting
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Chatting in Food Bar Chat',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5B2375),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Live Campus Stream',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Craving suggestion pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.map((chip) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6, bottom: 6),
                  child: InkWell(
                    onTap: () => _handleSendMessage(chip),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF8FD),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFEADBEE)),
                      ),
                      child: Text(
                        chip,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B2375),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Input Row
          Row(
            children: [
              // Attach button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attaching voucher/deal...')),
                  );
                },
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3EDF7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF5B2375), size: 20),
                ),
              ),
              const SizedBox(width: 8),

              // TextField
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8FD),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFEADBEE)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          onSubmitted: (_) => _handleSendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Chatting in Food Bar Chat... Share a craving or split deal...',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const Icon(Icons.sentiment_satisfied_alt_rounded, color: Color(0xFF9CA3AF), size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Purple circular send button
              InkWell(
                onTap: () => _handleSendMessage(),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5B2375),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(91, 35, 117, 0.35),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 3: SAVINGS WALL
  // ==========================================
  Widget _buildSavingsWallView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Foodie Savings Champions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1F1528),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Ranked by highest collective bill discounts unlocked this month.',
          style: TextStyle(fontSize: 12, color: Color(0xFF7C6D85)),
        ),
        const SizedBox(height: 16),
        _buildLeaderboardCard(
          rank: '#1',
          name: 'MidnightDumpling',
          avatar: '🥟',
          title: 'Platter Maestro',
          saved: '৳480',
          badge: '👑 Gold Tier',
          badgeColor: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 10),
        _buildLeaderboardCard(
          rank: '#2',
          name: 'TacoFiend',
          avatar: '🌮',
          title: 'BOGO Hunter',
          saved: '৳395',
          badge: '🥈 Silver VIP',
          badgeColor: const Color(0xFF94A3B8),
        ),
        const SizedBox(height: 10),
        _buildLeaderboardCard(
          rank: '#3',
          name: 'CheesyBoi99',
          avatar: '🍕',
          title: 'Pizza Baron',
          saved: '৳310',
          badge: '🥉 Bronze Elite',
          badgeColor: const Color(0xFFB45309),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard({
    required String rank,
    required String name,
    required String avatar,
    required String title,
    required String saved,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EDF7)),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF5B2375),
            ),
          ),
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFF3EDF7),
            child: Text(avatar, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: const Color(0xFF1F1528),
                  ),
                ),
                Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF7C6D85))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                saved,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
