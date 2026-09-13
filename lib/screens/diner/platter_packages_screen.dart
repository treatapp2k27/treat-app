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

  const PlatterPackagesScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectPlatter,
    required this.onEditBudget,
    this.onBackToLogin,
  });

  @override
  State<PlatterPackagesScreen> createState() => _PlatterPackagesScreenState();
}

class _PlatterPackagesScreenState extends State<PlatterPackagesScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: 'food platters & packs');
  String _searchQuery = 'food platters & packs';
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
              'Squad link for ${deal.restaurantName} is ready! Split the feast bill: \$${deal.price.toStringAsFixed(2)} total (${deal.perPersonText ?? "\$8/person"}).',
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
                    Row(
                      children: [
                        const Icon(Icons.tune_rounded,
                            color: Color(0xFF7C52AA), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Filters & Sort',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2B1A3A),
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

    // Build the list of platters to display
    List<PlatterDeal> platters = List.from(PlatterDeal.wireframePlatters);

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
            return title.contains('calamari') || sub.contains('calamari') || inc.contains('calamari');
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
      platters.sort((a, b) => a.price.compareTo(b.price));
    }

    // Apply search filter if active and not default
    if (_searchQuery.isNotEmpty &&
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
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 56,
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
                IconButton(
                  icon: Icon(
                    isFoodieLoggedIn ? Icons.menu : Icons.arrow_back_ios_new_rounded,
                    color: TreatColors.onSurface,
                    size: isFoodieLoggedIn ? 24 : 20,
                  ),
                  tooltip: isFoodieLoggedIn ? 'Menu' : 'Back to Login',
                  onPressed: isFoodieLoggedIn ? widget.onOpenDrawer : widget.onBackToLogin,
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
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: TreatColors.onSurfaceVariant, size: 22),
                      onPressed: () {},
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
          // Search & Filter Bar Row matching mockup
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: TreatColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: TreatColors.outlineVariant.withValues(alpha: 0.6),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(124, 82, 170, 0.06),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          size: 18, color: TreatColors.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TreatColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search platters & packs',
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
                          child: const Icon(Icons.close,
                              size: 16, color: TreatColors.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
              ),
              // Filter Button with Badge '2' (visible for logged-in Foodie, hidden in Explore Without Sign In)
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

          // Sort Pills & Food Bar Categories (Horizontally Slidable)
          SizedBox(
            height: 42,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((cat) {
                  final isSort = cat['type'] == 'sort';
                  final isSelected = isSort
                      ? (_selectedSort.toString() == cat['val'] && _selectedCategory == 'All')
                      : (_selectedCategory == cat['val']);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSort) {
                            _selectedSort = int.parse(cat['val']!);
                            _selectedCategory = 'All';
                          } else {
                            _selectedCategory = isSelected ? 'All' : cat['val']!;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TreatColors.secondary
                              : TreatColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : TreatColors.outlineVariant.withValues(alpha: 0.6),
                          ),
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(
                                    color: Color.fromRGBO(124, 82, 170, 0.28),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat['icon']!, style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 6),
                            Text(
                              cat['label']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : TreatColors.onSurfaceVariant,
                              ),
                            ),
                            if (isSelected && isSort && cat['val'] == '1') ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Smart Recommendations Callout Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TreatColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TreatColors.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: TreatColors.secondary.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TreatColors.secondary, TreatColors.primary],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: TreatColors.onSurfaceVariant,
                        height: 1.35,
                      ),
                      children: [
                        TextSpan(
                          text: 'Smart Recommendations: ',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            color: TreatColors.secondaryDark,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Curated strictly by lowest cost per foodie & highest culinary reviews.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Cards Feed
          ...platters.map((deal) => _buildPlatterCard(deal)),

          // Footer Loading Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: TreatColors.secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.thumb_up_alt_rounded,
                      color: TreatColors.secondary, size: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  'More Delicious Deals Loading...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: TreatColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'We scan menus 24/7 to guarantee you and your squad the biggest bites for the lowest bucks.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: TreatColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatterCard(PlatterDeal deal) {
    final dinerState = context.watch<DinerState>();
    final isLoved = dinerState.isFavorite(deal.id);

    final reviewText = deal.reviewsCount >= 1000
        ? '${(deal.reviewsCount / 1000).toStringAsFixed(1)}k'
        : '${deal.reviewsCount}';

    String portionBadge = 'Feeds ${deal.servesCountMax} portion';
    if (deal.id == 'deal-fiesta-nachos') {
      portionBadge = '#2 Feeds 4-5 portion';
    } else if (deal.id == 'deal-sunset-sliders') {
      portionBadge = '#1 Feeds 4 portion';
    } else if (deal.id == 'deal-ocean-calamari') {
      portionBadge = '#3 Feeds 4 portion';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF0EBF5),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Overlays matching mockup
          Stack(
            children: [
              Image.network(
                deal.imageUrl,
                height: 195,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 195,
                  color: TreatColors.secondaryFixed,
                  alignment: Alignment.center,
                  child: const Icon(Icons.fastfood,
                      size: 48, color: TreatColors.secondary),
                ),
              ),

              // Top-Left Badge (Budget Steal / Lowest Price Guarantee with Per-portion cost)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sell_outlined,
                          size: 13, color: Color(0xFF7C52AA)),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deal.badgeText,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF2B1A3A),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (deal.perPersonText != null)
                            Text(
                              deal.perPersonText!,
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF655B6E),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Top-Right Badge (Rating & Reviews)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          size: 13, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text(
                        '${deal.rating.toStringAsFixed(deal.rating == 4.9 ? 1 : 2)} ($reviewText+)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2B1A3A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom-Left Badge (Feeds X Portion)
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.groups_rounded,
                          size: 13, color: Color(0xFF7C52AA)),
                      const SizedBox(width: 4),
                      Text(
                        portionBadge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7C52AA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details Content Body
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  deal.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2B1A3A),
                  ),
                ),
                const SizedBox(height: 4),

                // Venue Subtitle
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined,
                        size: 14, color: Color(0xFF655B6E)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        deal.restaurantName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF655B6E),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Inclusions Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: deal.inclusions.map((chip) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F4FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFECE4F2)),
                      ),
                      child: Text(
                        chip,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4A3E54),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Price & Discount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${deal.price.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2B1A3A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '\$${deal.originalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF9E92A6),
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE7F3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        deal.saveText ??
                            'Save ${deal.discountPercent}% OFF',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD6228A),
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action Buttons Row (Loved It & Share with Squad)
                Row(
                  children: [
                    // Loved It Button (Only available for logged-in Foodies; NOT available for Explore Without Sign In)
                    if (dinerState.isFoodieLoggedIn) ...[
                      Expanded(
                        child: InkWell(
                          onTap: () => _toggleLoved(deal),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: isLoved
                                  ? const Color(0xFFFCE7F3)
                                  : const Color(0xFFFFF0F7),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFFFBCFE8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isLoved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: const Color(0xFFD6228A),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Loved It',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD6228A),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],

                    // Share with Squad Button
                    Expanded(
                      child: InkWell(
                        onTap: () => _shareWithSquad(deal),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE8FC),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFFDDD6FE),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.group_add_rounded,
                                  color: Color(0xFF7C52AA), size: 16),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Share with Squad',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF7C52AA),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
