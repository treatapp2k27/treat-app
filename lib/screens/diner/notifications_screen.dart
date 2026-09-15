import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/treat_notification.dart';
import '../../state/diner_state.dart';

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback? onNavigateExplore;
  final VoidCallback? onNavigateProfile;
  final VoidCallback? onNavigateSlip;
  final VoidCallback? onNavigateLudo;
  final VoidCallback? onNavigatePlatters;
  final VoidCallback? onNavigateReceipt;
  final VoidCallback? onNavigateSocial;

  const NotificationsScreen({
    super.key,
    required this.onOpenDrawer,
    this.onNavigateExplore,
    this.onNavigateProfile,
    this.onNavigateSlip,
    this.onNavigateLudo,
    this.onNavigatePlatters,
    this.onNavigateReceipt,
    this.onNavigateSocial,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  // Preferences toggles for the bottom sheet
  bool _prefPlatterRadar = true;
  bool _prefFeastAlerts = true;
  bool _prefSquadChallenges = true;
  bool _prefReceipts = true;
  bool _prefCommunity = false;

  late List<TreatNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      TreatNotification(
        id: 'notif-1',
        categoryLabel: 'FEAST ALERT',
        category: NotificationCategory.plattersAndFeasts,
        timeAgo: 'Just now',
        title: 'Sugar Bloom Cafe accepted your feast request!',
        description:
            'The Decadent Churro Sundae & Dip Bowl for 4 is confirmed and ready. Voucher generated.',
        isRead: false,
        primaryActionText: 'View Digital Slip',
        actionType: 'slip',
      ),
      TreatNotification(
        id: 'notif-2',
        categoryLabel: 'SQUAD LUDO',
        category: NotificationCategory.squadAndLudo,
        timeAgo: '5m ago',
        title: 'BobaBandit challenged you to Treat Squad Ludo!',
        description:
            'Roll for a 50% platter voucher before the room expires in 15 mins.',
        isRead: false,
        secondaryActionText: 'Decline',
        primaryActionText: 'Play Now 🎲',
        actionType: 'ludo',
      ),
      TreatNotification(
        id: 'notif-3',
        categoryLabel: 'FLASH DROP',
        category: NotificationCategory.flashDrops,
        timeAgo: '22m ago',
        title: 'Neon Glaze Fiesta Platter dropped 50% OFF nearby',
        description:
            'Only 2 platter passes remaining at Soho Quarter. Ends in 1h 45m.',
        isRead: false,
        secondaryActionText: 'Loved It',
        primaryActionText: 'Claim Deal',
        actionType: 'deal',
      ),
      TreatNotification(
        id: 'notif-4',
        categoryLabel: 'RECEIPT',
        category: NotificationCategory.receipts,
        timeAgo: 'Yesterday at 8:45 PM',
        title: 'Voucher #TR-8820 redeemed successfully',
        description:
            'Spice & Sizzle Bistro acknowledged your Sunset Sliders order. Thermal slip printed.',
        isRead: true,
        primaryActionText: 'View Receipt',
        actionType: 'receipt',
      ),
      TreatNotification(
        id: 'notif-5',
        categoryLabel: 'COMMUNITY',
        category: NotificationCategory.community,
        timeAgo: '2 days ago',
        title: 'TacoFiend and 4 others reacted to your Food Bar post',
        description:
            '“That churro dip looks insane! Which table are you at?”',
        isRead: true,
        primaryActionText: 'Reply',
        actionType: 'reply',
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<TreatNotification> get _filteredNotifications {
    if (_selectedCategory == NotificationCategory.all) {
      return _notifications;
    }
    return _notifications.where((n) => n.category == _selectedCategory).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications marked as read! ✨',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF5B2375),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleAction(TreatNotification item, bool isPrimary) {
    setState(() {
      item.isRead = true;
    });

    if (item.actionType == 'slip') {
      widget.onNavigateSlip?.call();
    } else if (item.actionType == 'ludo') {
      if (isPrimary) {
        widget.onNavigateLudo?.call();
      } else {
        setState(() {
          _notifications.removeWhere((n) => n.id == item.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ludo challenge declined',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else if (item.actionType == 'deal') {
      if (isPrimary) {
        widget.onNavigatePlatters?.call();
      } else {
        setState(() {
          item.isLoved = !item.isLoved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              item.isLoved ? 'Added to Loved Deals ❤️' : 'Removed from Loved Deals',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else if (item.actionType == 'receipt') {
      widget.onNavigateReceipt?.call();
    } else if (item.actionType == 'reply') {
      widget.onNavigateSocial?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: _buildTopAppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 40),
        children: [
          // 1. Title + New Count Badge + Mark All Read
          _buildHeaderRow(),
          const SizedBox(height: 14),

          // 2. Filter Category Pills (All, Platters & Feasts, Squad & Ludo, etc.)
          _buildFilterChipsRow(),
          const SizedBox(height: 16),

          // 3. Notification Cards List
          if (_filteredNotifications.isEmpty)
            _buildEmptyState()
          else
            ..._filteredNotifications.map((notif) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildNotificationCard(notif),
                )),

          const SizedBox(height: 8),

          // 4. Notification Preferences Banner Card
          _buildPreferencesCard(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Top App Bar (Hamburger, Treat Logo, Search, Profile Avatar)
  // -------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar() {
    final isFoodie = context.watch<DinerState>().isFoodieLoggedIn;
    return AppBar(
      backgroundColor: TreatColors.surface.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 2,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      toolbarHeight: 58,
      title: Row(
        children: [
          // Hamburger Menu
          InkWell(
            onTap: widget.onOpenDrawer,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(
                Icons.menu_rounded,
                color: TreatColors.onSurface,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Treat Logo in center
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                AssetConstants.logo,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text(
                  'Treat',
                  style: GoogleFonts.righteous(
                    fontSize: 22,
                    color: TreatColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),

          // Search Icon
          IconButton(
            icon: const Icon(Icons.search_rounded, color: TreatColors.onSurface, size: 22),
            onPressed: widget.onNavigateExplore,
            tooltip: 'Search Feasts',
          ),

          // Profile Avatar Icon Button
          if (isFoodie) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: widget.onNavigateProfile,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B2375),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Header: Title + Badge + Mark All Read
  // -------------------------------------------------------------
  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title and Badge
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Notifications',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: const Color(0xFF1F1528),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // Pink Pill Badge: "• 3 New"
              if (_unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE040A0), Color(0xFFD6228A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD6228A).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_unreadCount New',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
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

        // Mark all read button
        InkWell(
          onTap: _markAllAsRead,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.done_all_rounded,
                  size: 16,
                  color: Color(0xFF6B21A8),
                ),
                const SizedBox(width: 5),
                Text(
                  'Mark all\nread',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: const Color(0xFF6B21A8),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Filter Category Chips
  // -------------------------------------------------------------
  Widget _buildFilterChipsRow() {
    final chips = [
      {'category': NotificationCategory.all, 'label': 'All (${_notifications.length})'},
      {'category': NotificationCategory.plattersAndFeasts, 'label': 'Platters & Feasts'},
      {'category': NotificationCategory.squadAndLudo, 'label': 'Squad & Ludo'},
      {'category': NotificationCategory.flashDrops, 'label': 'Flash Drops'},
      {'category': NotificationCategory.receipts, 'label': 'Receipts'},
      {'category': NotificationCategory.community, 'label': 'Community'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((item) {
          final cat = item['category'] as NotificationCategory;
          final label = item['label'] as String;
          final isSelected = _selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5B2375) : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5B2375)
                        : const Color(0xFFE8DEEC),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF5B2375).withValues(alpha: 0.22),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF4A3B4F),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // -------------------------------------------------------------
  // Notification Card Component
  // -------------------------------------------------------------
  Widget _buildNotificationCard(TreatNotification item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isRead
              ? const Color(0xFFF2EAF4)
              : const Color(0xFFE9D7EE),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(74, 20, 140, 0.05),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon with overlay badge
          _buildNotificationAvatar(item),
          const SizedBox(width: 14),

          // Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Time + Unread indicator dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: item.categoryLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: _getCategoryColor(item),
                            ),
                          ),
                          TextSpan(
                            text: '  •  ${item.timeAgo}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A7A8E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Unread Dot
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),

                // Title
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: const Color(0xFF1F1528),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  item.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B5872),
                    height: 1.35,
                    fontStyle: item.category == NotificationCategory.community
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons matching mockup
                _buildActionButtons(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Left Avatar Icon with Badges
  // -------------------------------------------------------------
  Widget _buildNotificationAvatar(TreatNotification item) {
    Color bgColor;
    Color iconColor;
    IconData iconData;
    IconData? badgeIcon;
    Color? badgeColor;

    switch (item.category) {
      case NotificationCategory.plattersAndFeasts:
        bgColor = const Color(0xFFFCEAF5);
        iconColor = const Color(0xFFD6228A);
        iconData = Icons.restaurant_rounded;
        badgeIcon = Icons.auto_awesome_rounded;
        badgeColor = const Color(0xFFD6228A);
        break;
      case NotificationCategory.squadAndLudo:
        bgColor = const Color(0xFFF0E5FF);
        iconColor = const Color(0xFF7C3AED);
        iconData = Icons.casino_rounded;
        badgeIcon = Icons.groups_rounded;
        badgeColor = const Color(0xFF7C3AED);
        break;
      case NotificationCategory.flashDrops:
        bgColor = const Color(0xFFFFEBF6);
        iconColor = const Color(0xFFD6228A);
        iconData = Icons.local_fire_department_rounded;
        badgeIcon = Icons.percent_rounded;
        badgeColor = const Color(0xFFD6228A);
        break;
      case NotificationCategory.receipts:
        bgColor = const Color(0xFFE0F7FA);
        iconColor = const Color(0xFF00838F);
        iconData = Icons.receipt_long_rounded;
        badgeIcon = null;
        badgeColor = null;
        break;
      case NotificationCategory.community:
      default:
        bgColor = const Color(0xFFF3E8FF);
        iconColor = const Color(0xFF7C3AED);
        iconData = Icons.favorite_border_rounded;
        badgeIcon = null;
        badgeColor = null;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Icon(
            iconData,
            color: iconColor,
            size: 22,
          ),
        ),

        // Bottom right badge overlay
        if (badgeIcon != null && badgeColor != null)
          Positioned(
            right: -3,
            bottom: -3,
            child: Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: Icon(
                badgeIcon,
                color: Colors.white,
                size: 9.5,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCategoryColor(TreatNotification item) {
    switch (item.category) {
      case NotificationCategory.plattersAndFeasts:
      case NotificationCategory.flashDrops:
        return const Color(0xFFD6228A);
      case NotificationCategory.squadAndLudo:
        return const Color(0xFF7C3AED);
      case NotificationCategory.receipts:
        return const Color(0xFF00838F);
      case NotificationCategory.community:
      default:
        return const Color(0xFF7C3AED);
    }
  }

  // -------------------------------------------------------------
  // Card Action Buttons
  // -------------------------------------------------------------
  Widget _buildActionButtons(TreatNotification item) {
    // 1. Feast Alert: "View Digital Slip ->" gradient button
    if (item.actionType == 'slip') {
      return Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () => _handleAction(item, true),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE040A0), Color(0xFFB2107B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD6228A).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.primaryActionText ?? 'View Digital Slip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. Squad Ludo: Decline + "Play Now 🎲"
    if (item.actionType == 'ludo') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Decline Button
          InkWell(
            onTap: () => _handleAction(item, false),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEF6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                item.secondaryActionText ?? 'Decline',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5B4A61),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Play Now Button
          InkWell(
            onTap: () => _handleAction(item, true),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
              decoration: BoxDecoration(
                color: const Color(0xFF633990),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF633990).withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item.primaryActionText ?? 'Play Now 🎲',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 3. Flash Drop: "🤍 Loved It" + "🎟 Claim Deal"
    if (item.actionType == 'deal') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Loved It button
          InkWell(
            onTap: () => _handleAction(item, false),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
              decoration: BoxDecoration(
                color: item.isLoved ? const Color(0xFFFFD1E6) : const Color(0xFFFCEAF5),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.isLoved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 14,
                    color: const Color(0xFFB2107B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.isLoved ? 'Loved!' : 'Loved It',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB2107B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Claim Deal button
          InkWell(
            onTap: () => _handleAction(item, true),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
              decoration: BoxDecoration(
                color: const Color(0xFFD6228A),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD6228A).withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.primaryActionText ?? 'Claim Deal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // 4. Receipt: "👁 View Receipt"
    if (item.actionType == 'receipt') {
      return Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () => _handleAction(item, true),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: Color(0xFF00838F),
                ),
                const SizedBox(width: 5),
                Text(
                  item.primaryActionText ?? 'View Receipt',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00838F),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 5. Community: "↩ Reply"
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => _handleAction(item, true),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EEF6),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.reply_rounded,
                size: 15,
                color: Color(0xFF4A3B4F),
              ),
              const SizedBox(width: 4),
              Text(
                item.primaryActionText ?? 'Reply',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A3B4F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Bottom Card: Notification Preferences Banner
  // -------------------------------------------------------------
  Widget _buildPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE8DEF8),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(99, 57, 144, 0.05),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Target / Radar Icon in rounded container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E5FF),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.track_changes_rounded,
              color: Color(0xFF633990),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Preferences',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1F1528),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Turn on Platter Radar to never miss 50%...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7C6C80),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Tune settings button
          InkWell(
            onTap: _showPreferencesModal,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F0FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5D5EF), width: 1),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF633990),
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Preferences Bottom Sheet
  // -------------------------------------------------------------
  void _showPreferencesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDACBDF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notification Preferences',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F1528),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Customize which alerts wake your phone and update your feed in real-time.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: const Color(0xFF6B5872),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggles
                  _buildToggleTile(
                    title: 'Platter Radar 🎯',
                    subtitle: 'Instant alerts when secret platters drop 50% nearby',
                    value: _prefPlatterRadar,
                    onChanged: (val) {
                      setModalState(() => _prefPlatterRadar = val);
                      setState(() => _prefPlatterRadar = val);
                    },
                  ),
                  _buildToggleTile(
                    title: 'Feast Alerts & Bookings 🍽',
                    subtitle: 'Confirmations, voucher codes and kitchen slips',
                    value: _prefFeastAlerts,
                    onChanged: (val) {
                      setModalState(() => _prefFeastAlerts = val);
                      setState(() => _prefFeastAlerts = val);
                    },
                  ),
                  _buildToggleTile(
                    title: 'Squad Challenges & Ludo 🎲',
                    subtitle: 'Game invites and group platter splitting challenges',
                    value: _prefSquadChallenges,
                    onChanged: (val) {
                      setModalState(() => _prefSquadChallenges = val);
                      setState(() => _prefSquadChallenges = val);
                    },
                  ),
                  _buildToggleTile(
                    title: 'Order Receipts 🧾',
                    subtitle: 'Digital slips and merchant redemption proofs',
                    value: _prefReceipts,
                    onChanged: (val) {
                      setModalState(() => _prefReceipts = val);
                      setState(() => _prefReceipts = val);
                    },
                  ),
                  _buildToggleTile(
                    title: 'Community Bites & Likes 💜',
                    subtitle: 'When friends comment on your feasts and stories',
                    value: _prefCommunity,
                    onChanged: (val) {
                      setModalState(() => _prefCommunity = val);
                      setState(() => _prefCommunity = val);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1528),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: const Color(0xFF7C6C80),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFFD6228A),
            activeTrackColor: const Color(0xFFFCEAF5),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F0FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF8A7A8E),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No notifications in this category',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check other filters or wait for nearby flash drops!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFF8A7A8E),
            ),
          ),
        ],
      ),
    );
  }
}
