import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/favorite_item.dart';
import '../../models/platter_deal.dart';
import '../../state/diner_state.dart';

class PlatterPackagesScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal platter) onSelectPlatter;
  final VoidCallback onEditBudget;
  final VoidCallback? onBackToLogin;
  final VoidCallback? onNavigateNotifications;

  const PlatterPackagesScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectPlatter,
    required this.onEditBudget,
    this.onBackToLogin,
    this.onNavigateNotifications,
  });

  @override
  State<PlatterPackagesScreen> createState() => _PlatterPackagesScreenState();
}

class _PlatterPackagesScreenState extends State<PlatterPackagesScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: 'food platters & packz');
  String _searchQuery = 'food platters & packz';
  bool _initializedController = false;
  int _selectedSort = 0; // 0: Recommended for You, 1: Lowest Price First
  String _selectedCategory = 'All';

  final List<Map<String, String>> _categories = const [
    {'label': 'Recommended for You', 'icon': '🔥', 'type': 'sort', 'val': '0'},
    {'label': 'Lowest Price First', 'icon': '💰', 'type': 'sort', 'val': '1'},
    {'label': 'Sliders & Burgers', 'icon': '🍔', 'type': 'cat', 'val': 'sliders'},
    {'label': 'Ocean Seafood', 'icon': '🍤', 'type': 'cat', 'val': 'seafood'},
    {'label': 'Fiesta & Nachos', 'icon': '🌮', 'type': 'cat', 'val': 'nachos'},
    {'label': 'Mega Feast Boards', 'icon': '🍕', 'type': 'cat', 'val': 'feast'},
    {'label': 'Sweet Treats', 'icon': '🍰', 'type': 'cat', 'val': 'sweet'},
    {'label': 'Slushies & Shakes', 'icon': '🥤', 'type': 'cat', 'val': 'drinks'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shareWithSquad(PlatterDeal deal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: TreatColors.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: TreatColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: TreatColors.secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group_add_rounded,
                      color: TreatColors.secondary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share with Squad',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: TreatColors.onSurface,
                        ),
                      ),
                      Text(
                        deal.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: TreatColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Squad link for ${deal.restaurantName} is ready! Split the feast bill: \$${deal.price.toStringAsFixed(2)} total (${deal.perPersonText ?? "\$15/person"}).',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: TreatColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Squad Invite Link copied to clipboard! 📋',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: TreatColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TreatColors.secondaryDark,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              child: Text(
                'Copy Squad Invite Link',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLoved(PlatterDeal deal) {
    final added = context
        .read<DinerState>()
        .toggleFavorite(FavoriteItem.fromPlatterDeal(deal));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              added ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                added
                    ? 'Added "${deal.title}" to your Loved Favorites! ❤️'
                    : 'Removed from Favorites',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD6228A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.tune_rounded,
                              color: Color(0xFF7C52AA), size: 22),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Filters & Sort',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2B1A3A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9D174D),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '2 Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'SORT BY',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF655B6E),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Recommended for You'),
                      selected: _selectedSort == 0,
                      onSelected: (val) {
                        setState(() => _selectedSort = 0);
                        setModalState(() {});
                      },
                      selectedColor: const Color(0xFFEDE8FC),
                      labelStyle: TextStyle(
                        color: _selectedSort == 0
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFF655B6E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Lowest Price First'),
                      selected: _selectedSort == 1,
                      onSelected: (val) {
                        setState(() => _selectedSort = 1);
                        setModalState(() {});
                      },
                      selectedColor: const Color(0xFFEDE8FC),
                      labelStyle: TextStyle(
                        color: _selectedSort == 1
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFF655B6E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'CRAVING CATEGORIES',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF655B6E),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories
                      .where((c) => c['type'] == 'cat')
                      .map((cat) {
                    final isSel = _selectedCategory == cat['val'];
                    return ChoiceChip(
                      label: Text('${cat['icon']} ${cat['label']}'),
                      selected: isSel,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = val ? cat['val']! : 'All';
                        });
                        setModalState(() {});
                      },
                      selectedColor: const Color(0xFFEDE8FC),
                      labelStyle: TextStyle(
                        color: isSel
                            ? const Color(0xFF7C52AA)
                            : const Color(0xFF655B6E),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onEditBudget();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C52AA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      'Open Smart Budget Planner',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final isFoodieLoggedIn = dinerState.isFoodieLoggedIn;

    if (!_initializedController) {
      _initializedController = true;
      final defaultQuery = isFoodieLoggedIn ? 'food platters & packz' : 'food platters & packs';
      _searchController.text = defaultQuery;
      _searchQuery = defaultQuery;
    }

    // Build the list of platters to display
    List<PlatterDeal> platters = isFoodieLoggedIn
        ? [
            PlatterDeal.fiestaPlatter,
            PlatterDeal.megaFeastPlatter,
            PlatterDeal.supremeSeafoodPlatter,
          ]
        : [
            PlatterDeal.sunsetSlidersPlatter,
            PlatterDeal.oceanCalamariPlatter,
            PlatterDeal.fiestaNachosPlatter,
          ];

    // Apply category filter if active
    if (_selectedCategory != 'All') {
      final filtered = platters.where((p) {
        final title = p.title.toLowerCase();
        final sub = p.subtitle.toLowerCase();
        final inc = p.inclusions.map((e) => e.toLowerCase()).join(' ');
        switch (_selectedCategory) {
          case 'sliders':
            return title.contains('slider') || sub.contains('slider') || inc.contains('slider');
          case 'seafood':
            return title.contains('calamari') || title.contains('seafood') || sub.contains('calamari') || inc.contains('calamari') || inc.contains('prawn');
          case 'nachos':
            return title.contains('nacho') || sub.contains('nacho') || inc.contains('nacho');
          case 'feast':
            return title.contains('feast') || sub.contains('feast') || inc.contains('board');
          case 'sweet':
            return title.contains('sweet') || sub.contains('sweet') || inc.contains('churro');
          case 'drinks':
            return inc.contains('shake') || inc.contains('soda') || inc.contains('slush') || inc.contains('drink');
          default:
            return true;
        }
      }).toList();
      if (filtered.isNotEmpty) {
        platters = filtered;
      }
    }

    // Apply sorting
    if (_selectedSort == 1) {
      platters.sort((a, b) =>
          a.perPersonCost(a.servesCountMin).compareTo(b.perPersonCost(b.servesCountMin)));
    }

    // Apply search filter if active and not default mockup query
    if (_searchQuery.isNotEmpty &&
        _searchQuery.toLowerCase() != 'food platters & packz' &&
        _searchQuery.toLowerCase() != 'food platters & packs') {
      final q = _searchQuery.toLowerCase();
      platters = platters.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.restaurantName.toLowerCase().contains(q) ||
            p.inclusions.any((inc) => inc.toLowerCase().contains(q));
      }).toList();
    }

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: TreatColors.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(
                  color: TreatColors.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isFoodieLoggedIn
                    ? IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: TreatColors.onSurface,
                          size: 24,
                        ),
                        tooltip: 'Menu',
                        onPressed: widget.onOpenDrawer,
                      )
                    : InkWell(
                        onTap: widget.onBackToLogin,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFEDE5F2),
                              width: 1.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(124, 82, 170, 0.08),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: TreatColors.onSurface,
                            size: 17,
                          ),
                        ),
                      ),
                Image.asset(
                  AssetConstants.logo,
                  height: 28,
                  errorBuilder: (_, __, ___) => Text(
                    'Treat',
                    style: GoogleFonts.righteous(
                      fontSize: 24,
                      color: TreatColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: TreatColors.onSurface, size: 22),
                      onPressed: () {},
                    ),
                    if (isFoodieLoggedIn)
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded,
                            color: TreatColors.onSurfaceVariant, size: 22),
                        onPressed: () => widget.onNavigateNotifications?.call(),
                      ),
                    if (isFoodieLoggedIn) ...[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5B2375),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 18),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 36),
        children: [
          // 1. Search & Filter Bar Row matching mockup
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFFECE4F2),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(124, 82, 170, 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          size: 18, color: Color(0xFF4A3E54)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2B1A3A),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search platters & packages...',
                            hintStyle: TextStyle(
                              color: TreatColors.onSurfaceVariant.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        InkWell(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.clear,
                              size: 16, color: Color(0xFF71717A)),
                        ),
                    ],
                  ),
                ),
              ),
              // Filter Button with Badge '2'
              if (isFoodieLoggedIn) ...[
                const SizedBox(width: 10),
                InkWell(
                  onTap: _openFilterModal,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8FC),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(124, 82, 170, 0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tune_rounded,
                            size: 18, color: Color(0xFF7C52AA)),
                        const SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF7C52AA),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9D174D),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // 2. Budget Summary Card
          _buildBudgetSummaryCard(),
          const SizedBox(height: 16),

          // 3. Discovered Platter Packages Header
          _buildDiscoveredHeader(),
          const SizedBox(height: 14),

          // 4. Squad Allocation Card
          _buildSquadAllocationCard(),
          const SizedBox(height: 18),

          // 5. Platter Cards Feed
          ...platters.map((deal) => _buildPlatterCard(deal)),

          // 6. Treat Booking Guarantee Container
          _buildBookingGuarantee(),
        ],
      ),
    );
  }

  Widget _buildBudgetSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0E5F8)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFEADBF5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded,
                color: Color(0xFF7C52AA), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Budget: \$120',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2B1A3A),
                      ),
                    ),
                    Text(
                      ' • 3 Guests •',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF71717A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Casual Dining',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: const Color(0xFF71717A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tax Included & Service Matched',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD6228A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: widget.onEditBudget,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1E5F6),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE4D2EE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7C52AA),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.edit_outlined,
                      size: 12, color: Color(0xFF7C52AA)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discovered Platter Packages',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2B1A3A),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select your group feast package to request booking with the kitchen',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: const Color(0xFF71717A),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2F8),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFCE7F3)),
          ),
          child: const Icon(Icons.celebration_rounded,
              color: Color(0xFFD6228A), size: 18),
        ),
      ],
    );
  }

  Widget _buildSquadAllocationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCE7F3)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE7F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.savings_outlined,
                color: Color(0xFFD6228A), size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Squad Allocation: \$120.00',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2B1A3A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All platters leave ample budget for cocktails & dessert!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            alignment: Alignment.center,
            child: Text(
              '3+',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatterCard(PlatterDeal deal) {
    final dinerState = context.watch<DinerState>();
    final isLoved = dinerState.isFavorite(deal.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0EBF5),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.05),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Heart / Favorite Toggle
          Row(
            children: [
              const Spacer(),
              InkWell(
                key: ValueKey('fav_btn_${deal.id}'),
                onTap: () => _toggleLoved(deal),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isLoved
                        ? const Color(0xFFFCE7F3)
                        : const Color(0xFFFAF7FC),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isLoved
                          ? const Color(0xFFFBCFE8)
                          : const Color(0xFFECE4F2),
                    ),
                  ),
                  child: Icon(
                    isLoved ? Icons.favorite : Icons.favorite_border,
                    color: isLoved
                        ? const Color(0xFFD6228A)
                        : const Color(0xFF7C52AA),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Inset Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: deal.imageUrl.startsWith('assets/')
                ? Image.asset(
                    deal.imageUrl,
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImageFallback(),
                  )
                : Image.network(
                    deal.imageUrl,
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImageFallback(),
                  ),
          ),
          const SizedBox(height: 14),

          // Title & Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  deal.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2B1A3A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (deal.originalPrice > deal.price) ...[
                    Text(
                      '\$${deal.originalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: const Color(0xFF9CA3AF),
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    '\$${deal.price.toStringAsFixed(2)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF5B2375),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Servings line
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 2,
            children: [
              Text(
                'Serves ${deal.servesCountMin}-${deal.servesCountMax} Foodies',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD6228A),
                ),
              ),
              Text(
                deal.perPersonText ??
                    '(\$${(deal.price / deal.servesCountMin).toStringAsFixed(2)} / person)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: const Color(0xFF71717A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Package Inclusions Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F4FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF0EBF5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        size: 14, color: Color(0xFF7C52AA)),
                    const SizedBox(width: 6),
                    Text(
                      'PACKAGE INCLUSIONS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: deal.inclusions.map((inc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE9DFF2)),
                      ),
                      child: Text(
                        inc,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4A3E54),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Solid Purple CTA Button
          ElevatedButton(
            onPressed: () => widget.onSelectPlatter(deal),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E358A),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 46),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select This Platter',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
          if (!dinerState.isFoodieLoggedIn) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _shareWithSquad(deal),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FC),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.group_add_rounded,
                        color: Color(0xFF7C52AA), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Share with Squad',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF7C52AA),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingGuarantee() {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3ECF8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFBE185D),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Treat Booking Guarantee',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2B1A3A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kitchen holds the table and locks platter pricing for 20 minutes once selected.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: const Color(0xFF655B6E),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      height: 185,
      color: const Color(0xFFF0E5F8),
      alignment: Alignment.center,
      child: const Icon(Icons.fastfood_rounded,
          size: 40, color: Color(0xFF7C52AA)),
    );
  }
}
