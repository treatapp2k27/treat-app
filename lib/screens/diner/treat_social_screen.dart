import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/treat_colors.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

class TreatSocialScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback? onExploreTreats;

  const TreatSocialScreen({
    super.key,
    required this.onOpenDrawer,
    this.onExploreTreats,
  });

  @override
  State<TreatSocialScreen> createState() => _TreatSocialScreenState();
}

class _TreatSocialScreenState extends State<TreatSocialScreen> {
  int _activeTab = 0; // 0: Feed, 1: Live Chat, 2: Savings Wall
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Social feed mock state with like interactions
  final List<Map<String, dynamic>> _feedPosts = [
    {
      'id': 'post_1',
      'emoji': '🍬',
      'author': 'MidnightDumpling',
      'avatar': '🥟',
      'district': 'Midtown',
      'timeAgo': '12 mins ago',
      'savedAmount': 'Saved \$32',
      'text':
          'Just crushed the 4-person slider & shake platter at Sprinkle & Sizzle! Split 4 ways with @TacoFiend and it was only \$8 each!',
      'likes': 42,
      'isLiked': true,
      'replies': 8,
      'tag': 'Slider Platter',
    },
    {
      'id': 'post_2',
      'emoji': '🌮',
      'author': 'TacoFiend',
      'avatar': '🌮',
      'district': 'SoHo Arts',
      'timeAgo': '35 mins ago',
      'savedAmount': 'Saved \$20',
      'text':
          'Voucher TREAT50 worked like magic on the Fiesta Taco Tray. Table sparklers on the boba tower were unreal ✨',
      'likes': 89,
      'isLiked': false,
      'replies': 14,
      'tag': 'TREAT50 Used',
    },
    {
      'id': 'post_3',
      'emoji': '🍕',
      'author': 'CheesyBoi99',
      'avatar': '🍕',
      'district': 'Downtown Alley',
      'timeAgo': '1 hour ago',
      'savedAmount': 'Saved \$45',
      'text':
          'Group BOGO unlocked just in time! Scored 2 mega deep-dish pies and free cinnamon crunch donut drops for the crew.',
      'likes': 64,
      'isLiked': false,
      'replies': 11,
      'tag': 'Group BOGO',
    },
  ];

  // Live Food Bar Chat messages
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
      'text': 'Use code WEEKENDVIBE for \$20 off group platters today guys!',
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

  // Savings Wall Leaderboard
  final List<Map<String, dynamic>> _leaderboard = [
    {
      'rank': 1,
      'author': 'MidnightDumpling',
      'avatar': '🥟',
      'title': 'Platter Maestro',
      'saved': '\$480',
      'feasts': 16,
      'badge': '👑 Gold Tier',
      'badgeColor': TreatColors.primary,
    },
    {
      'rank': 2,
      'author': 'TacoFiend',
      'avatar': '🌮',
      'title': 'BOGO Hunter',
      'saved': '\$395',
      'feasts': 12,
      'badge': '🥈 Silver VIP',
      'badgeColor': TreatColors.secondary,
    },
    {
      'rank': 3,
      'author': 'BobaQueen',
      'avatar': '🧋',
      'title': 'Slushie Connoisseur',
      'saved': '\$310',
      'feasts': 9,
      'badge': '🥉 Bronze Star',
      'badgeColor': TreatColors.tertiary,
    },
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({
        'author': 'MidnightDumpling',
        'avatar': '🥟',
        'text': text,
        'time': 'Just now',
        'isMe': true,
      });
      _chatController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleLike(String postId) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Treat',
        actionIcon: Icons.celebration,
        onActionTap: widget.onExploreTreats,
      ),
      body: Column(
        children: [
          // Sub-Tabs Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildSegmentTab('Community Feed', Icons.dynamic_feed, 0),
                const SizedBox(width: 8),
                _buildSegmentTab('Food Bar Chat', Icons.forum_outlined, 1, hasLiveDot: true),
                const SizedBox(width: 8),
                _buildSegmentTab('Savings Wall', Icons.leaderboard_outlined, 2),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: _buildActiveTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab(String label, IconData icon, int index, {bool hasLiveDot = false}) {
    final isActive = _activeTab == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = index),
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      Color(0xFF7C52AA), // Funky Purple
                      Color(0xFFE040A0), // Candy Berry Pink
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive ? null : TreatColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : TreatColors.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(224, 64, 160, 0.28),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
                : const [
                    BoxShadow(
                      color: Color.fromRGBO(124, 82, 170, 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    )
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive ? Colors.white : TreatColors.secondary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                    color: isActive ? Colors.white : TreatColors.onSurface,
                  ),
                ),
              ),
              if (hasLiveDot) ...[
                const SizedBox(width: 5),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : TreatColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isActive ? Colors.white : TreatColors.success)
                            .withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildFeedView();
      case 1:
        return _buildChatView();
      case 2:
        return _buildLeaderboardView();
      default:
        return _buildFeedView();
    }
  }

  // ---------------------------------------------------------------------------
  // Tab 0: Community Feed
  // ---------------------------------------------------------------------------
  Widget _buildFeedView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 36),
      children: [
        // Social Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF3E6FB), Color(0xFFE5D5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(124, 82, 170, 0.08),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: TreatColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.celebration, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Foodie Savings Pulse',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: TreatColors.onSurface,
                      ),
                    ),
                    Text(
                      'Over \$1,480 saved by local groups this week!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: TreatColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Feed Items
        ..._feedPosts.map((post) => _buildPostCard(post)),
      ],
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final isLiked = post['isLiked'] as bool;
    final likes = post['likes'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TreatCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar, Author, District, Saved Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: TreatColors.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          post['avatar'] as String,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    post['author'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: TreatColors.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: TreatColors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    post['district'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: TreatColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              post['timeAgo'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: TreatColors.onSurfaceVariant.withValues(alpha: 0.8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: TreatColors.primaryFixed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.savings_outlined, size: 13, color: TreatColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        post['savedAmount'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          color: TreatColors.onPrimaryFixedVariant,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content text
            Text(
              post['text'] as String,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                height: 1.4,
                color: TreatColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Tag & Interactions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TreatColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '# ${post['tag']}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: TreatColors.onSecondaryFixed,
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLike(post['id'] as String),
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isLiked ? TreatColors.secondary : TreatColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$likes',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isLiked ? TreatColors.secondary : TreatColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 15,
                          color: TreatColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['replies']}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: TreatColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 1: Live Food Bar Chat
  // ---------------------------------------------------------------------------
  Widget _buildChatView() {
    return Column(
      children: [
        // Live Chatroom Room Pill
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: TreatColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: TreatColors.outlineVariant.withValues(alpha: 0.6),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: TreatColors.secondary.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [TreatColors.secondary, TreatColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Live Town Foodie Chat • 128 foodies online',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: TreatColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Message List
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final msg = _chatMessages[index];
              final isMe = msg['isMe'] as bool;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe) ...[
                      Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(right: 8, bottom: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TreatColors.secondaryFixed.withValues(alpha: 0.7),
                              TreatColors.primaryFixed.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TreatColors.outlineVariant.withValues(alpha: 0.7),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (msg['avatar'] as String?) ?? '🍽️',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.72,
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 4),
                                child: Text(
                                  msg['author'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: TreatColors.secondaryDark,
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? const LinearGradient(
                                        colors: [
                                          TreatColors.secondary,
                                          TreatColors.primary
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isMe
                                    ? null
                                    : TreatColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                                border: isMe
                                    ? null
                                    : Border.all(
                                        color: TreatColors.outlineVariant
                                            .withValues(alpha: 0.6),
                                        width: 1.0,
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isMe
                                        ? TreatColors.primary
                                            .withValues(alpha: 0.25)
                                        : TreatColors.secondary
                                            .withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                msg['text'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                  color: isMe
                                      ? Colors.white
                                      : TreatColors.onSurface,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 3, right: 4, left: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['time'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w500,
                                      color: TreatColors.onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.done_all_rounded,
                                      size: 12,
                                      color: TreatColors.primary
                                          .withValues(alpha: 0.8),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Message Input Field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: TreatColors.surfaceContainerLowest,
            border: Border(
              top: BorderSide(
                color: TreatColors.outlineVariant.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: TreatColors.secondary.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: TreatColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: TreatColors.outlineVariant.withValues(alpha: 0.7),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 17,
                          color: TreatColors.secondary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            onSubmitted: (_) => _handleSendMessage(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: TreatColors.onSurface,
                            ),
                            cursorColor: TreatColors.primary,
                            decoration: InputDecoration(
                              hintText: 'Share a secret spot, voucher or drop...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: TreatColors.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _handleSendMessage,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [TreatColors.secondary, TreatColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: TreatColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 2: Savings Wall & Leaderboard
  // ---------------------------------------------------------------------------
  Widget _buildLeaderboardView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 36),
      children: [
        // Trophy Header
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(255, 179, 0, 0.3),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foodie Savings Champions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ranked by total group dining dollars saved this month!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: const Color(0xFF4E342E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Leaderboard Cards
        ..._leaderboard.map((item) {
          final rank = item['rank'] as int;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEDE5F2)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Rank Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? const Color(0xFFFFD54F)
                        : (rank == 2 ? const Color(0xFFCFD8DC) : const Color(0xFFFFCCBC)),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#$rank',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Avatar
                Text(item['avatar'] as String, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['author'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: TreatColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item['title']} • ${item['feasts']} Feasts',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: TreatColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Amount Saved
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['saved'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: TreatColors.primary,
                      ),
                    ),
                    Text(
                      'Total Saved',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: TreatColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
