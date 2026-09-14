import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/asset_constants.dart';
import '../../models/platter_deal.dart';

class LovedPackageItem {
  final String id;
  final String title;
  final String restaurantName;
  final double price;
  final String perPersonText;
  final String wasPrice;
  final String ratingText;
  final String lovedDate;
  final String imageUrl;
  final List<String> tags;
  final int partySize;
  final bool isAsset;

  const LovedPackageItem({
    required this.id,
    required this.title,
    required this.restaurantName,
    required this.price,
    required this.perPersonText,
    required this.wasPrice,
    required this.ratingText,
    required this.lovedDate,
    required this.imageUrl,
    required this.tags,
    this.partySize = 4,
    this.isAsset = false,
  });
}

class FavoritesScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal)? onSelectDeal;
  final VoidCallback? onExploreMore;
  final VoidCallback? onNavigateProfile;

  const FavoritesScreen({
    super.key,
    required this.onOpenDrawer,
    this.onSelectDeal,
    this.onExploreMore,
    this.onNavigateProfile,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedFilter = 0; // 0: All (5), 1: Under ৳35 (3), 2: Feasts for 4+ (2)
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Set<String> _unfavoritedIds = {};

  final List<LovedPackageItem> _packages = [
    const LovedPackageItem(
      id: 'sunset-sliders',
      title: 'The Sunset Sliders & Fries Feast',
      restaurantName: 'Spice & Sizzle Bistro • 0.8 mi away',
      price: 32.0,
      perPersonText: '(৳8/person)',
      wasPrice: 'Was: ৳50',
      ratingText: '4.9 (840)',
      lovedDate: 'Loved May 18',
      imageUrl:
          'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
      tags: ['12 Crispy Sliders', 'Truffle Fries', '4 Shakes'],
      partySize: 4,
    ),
    const LovedPackageItem(
      id: 'churro-sundae',
      title: 'Decadent Churro Sundae & Dip Bowl',
      restaurantName: 'Sugar Bloom Cafe & Brunch • 0.4 mi away',
      price: 22.0,
      perPersonText: '(৳5.50/person)',
      wasPrice: 'Was: ৳38',
      ratingText: '4.98 (2.1k)',
      lovedDate: 'Loved May 15',
      imageUrl: 'assets/images/churro_sundae.jpg',
      tags: ['Warm Cinnamon Churros x12', 'Soft Serve Trio', 'Dip Flight'],
      partySize: 4,
      isAsset: true,
    ),
    const LovedPackageItem(
      id: 'calamari-prawn',
      title: 'Crispy Ocean Calamari & Prawn Feast',
      restaurantName: 'Ocean Catch Lounge • 1.2 mi away',
      price: 36.0,
      perPersonText: '(৳9/person)',
      wasPrice: 'Was: ৳60',
      ratingText: '4.95 (1.2k)',
      lovedDate: 'Loved May 10',
      imageUrl:
          'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=800&q=80',
      tags: ['Golden Prawns', 'Crispy Calamari', 'Craft Sodas'],
      partySize: 4,
    ),
    const LovedPackageItem(
      id: 'birria-taco-tower',
      title: 'Fiesta Street Taco & Queso Mountain',
      restaurantName: 'Taco Bodega Cantina • 0.5 mi away',
      price: 28.0,
      perPersonText: '(৳7/person)',
      wasPrice: 'Was: ৳45',
      ratingText: '4.88 (950)',
      lovedDate: 'Loved May 08',
      imageUrl:
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=800&q=80',
      tags: ['10 Birria Tacos', 'Queso Mountain', 'Jarritos 4-Pack'],
      partySize: 4,
    ),
    const LovedPackageItem(
      id: 'ramen-bao-board',
      title: 'Tokyo Midnight Ramen & Bao Board',
      restaurantName: 'Ramen Samurai Lounge • 1.0 mi away',
      price: 42.0,
      perPersonText: '(৳10.50/person)',
      wasPrice: 'Was: ৳65',
      ratingText: '4.92 (1.5k)',
      lovedDate: 'Loved May 02',
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80',
      tags: ['4 Rich Miso Ramens', 'Steamed Pork Bao x6', 'Gyoza Platter'],
      partySize: 4,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shareWithSquad(LovedPackageItem item) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.group_add, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Squad share link generated for "${item.title}"! 🚀',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5B2375),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite(LovedPackageItem item) {
    setState(() {
      if (_unfavoritedIds.contains(item.id)) {
        _unfavoritedIds.remove(item.id);
      } else {
        _unfavoritedIds.add(item.id);
      }
    });

    final isLoved = !_unfavoritedIds.contains(item.id);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLoved
              ? 'Saved "${item.title}" back to Loved Packages! ❤️'
              : 'Removed "${item.title}" from Loved Packages',
        ),
        backgroundColor: const Color(0xFF5B2375),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final availablePackages = _packages.where((pkg) {
      if (_unfavoritedIds.contains(pkg.id)) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matches = pkg.title.toLowerCase().contains(query) ||
            pkg.restaurantName.toLowerCase().contains(query) ||
            pkg.tags.any((t) => t.toLowerCase().contains(query));
        if (!matches) return false;
      }
      if (_selectedFilter == 1) {
        return pkg.price < 35.0;
      }
      if (_selectedFilter == 2) {
        return pkg.partySize >= 4 && pkg.price >= 35.0;
      }
      return true;
    }).toList();

    final totalSavedCount = _packages.length - _unfavoritedIds.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildTopAppBar(),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // 1. Title Row & "5 Saved" Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'My Loved Packages',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFFBCFE8), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 13,
                      color: Color(0xFFBE185D),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$totalSavedCount Saved',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFBE185D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 2. Subtitle
          Text(
            'Your favorite budget-friendly feasts and top-reviewed packages, ready to book or split with your squad anytime.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5E74),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // 3. Search Bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFEADBEE), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.02),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 19,
                  color: Color(0xFF7C6D85),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F1528),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search saved treats...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E92A6),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF7C6D85),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Filter Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('All ($totalSavedCount)', 0),
                const SizedBox(width: 8),
                _buildFilterPill('Under ৳35 (3)', 1),
                const SizedBox(width: 8),
                _buildFilterPill('Feasts for 4+ (2)', 2),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 5. "Ready to Treat?" Callout Banner
          _buildReadyToTreatBanner(),
          const SizedBox(height: 16),

          // 6. Packages List
          if (availablePackages.isEmpty)
            _buildEmptyState()
          else
            ...availablePackages.map((item) => _buildPackageCard(item)),

          const SizedBox(height: 12),

          // 7. Bottom Discovery Card
          _buildDiscoveryCard(),
        ],
      ),
    );
  }

  // --- Top App Bar ---
  Widget _buildTopAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      color: Colors.white,
      child: Row(
        children: [
          // 3-Line Hamburger Menu Icon
          InkWell(
            onTap: widget.onOpenDrawer,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.menu, color: Color(0xFF1F1528), size: 24),
            ),
          ),
          const Spacer(),
          // Treat Logo
          Image.asset(
            AssetConstants.logo,
            height: 30,
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
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: widget.onExploreMore,
          ),
          const SizedBox(width: 12),
          // Notification Bell Icon
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1F1528), size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          // Circular Profile Avatar (#5B2375) - Redirects to Profile Settings
          InkWell(
            onTap: widget.onNavigateProfile,
            borderRadius: BorderRadius.circular(999),
            child: Tooltip(
              message: 'Profile Settings',
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B2375),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Pill ---
  Widget _buildFilterPill(String label, int index) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B2375) : const Color(0xFFF3EDF7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B2375) : const Color(0xFFEADBEE),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5A4D62),
          ),
        ),
      ),
    );
  }

  // --- Ready to Treat Banner ---
  Widget _buildReadyToTreatBanner() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF0F7), Color(0xFFFFE4F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFCE7F3), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular magenta icon with pizza
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFD6228A),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.local_pizza_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Ready to Treat?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F1528),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFFBCFE8)),
                      ),
                      child: Text(
                        '3 Squad Online',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFBE185D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Pick any saved feast below to launch a zero-hassle instant group split right now!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B5E74),
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

  // --- Package Card ---
  Widget _buildPackageCard(LovedPackageItem item) {
    final isLoved = !_unfavoritedIds.contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E5F8), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Image with Overlays
          Stack(
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: item.isAsset
                    ? Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF3E6FB),
                          alignment: Alignment.center,
                          child: const Icon(Icons.restaurant, size: 48, color: Color(0xFF7C52AA)),
                        ),
                      )
                    : Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF3E6FB),
                          alignment: Alignment.center,
                          child: const Icon(Icons.restaurant, size: 48, color: Color(0xFF7C52AA)),
                        ),
                      ),
              ),

              // Top-left: "♥ Loved May 18"
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
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
                      const Icon(
                        Icons.favorite,
                        size: 12,
                        color: Color(0xFFD6228A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.lovedDate,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF9D174D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top-right: Circle heart button
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  key: ValueKey('fav_btn_${item.id}'),
                  onTap: () => _toggleFavorite(item),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isLoved ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isLoved ? const Color(0xFFE11D48) : const Color(0xFF9E92A6),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom-left: "★ 4.9 (840)"
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
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
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFEAB308),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.ratingText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F1528),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '৳${item.price.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF5B2375),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                item.perPersonText,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B5E74),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        item.wasPrice,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9CA3AF),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Title
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),

                // Restaurant & Distance
                Row(
                  children: [
                    const Icon(
                      Icons.storefront_rounded,
                      size: 14,
                      color: Color(0xFF7C52AA),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.restaurantName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B5E74),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tags Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.tags.map((tag) => _buildItemTag(tag)).toList(),
                ),
                const SizedBox(height: 12),

                // "Squad Share" Wide Pill Button
                InkWell(
                  onTap: () => _shareWithSquad(item),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 9.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F7),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFFCE7F3), width: 1.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.group_add_rounded,
                          size: 16,
                          color: Color(0xFFBE185D),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Squad Share',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFBE185D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTag(String tag) {
    Color bgColor = const Color(0xFFF3EDF7);
    Color textColor = const Color(0xFF5B2375);
    IconData icon = Icons.check_circle_outline;

    final lower = tag.toLowerCase();
    if (lower.contains('slider') || lower.contains('burger') || lower.contains('taco')) {
      bgColor = const Color(0xFFF3EDF7);
      textColor = const Color(0xFF5B2375);
      icon = Icons.lunch_dining_rounded;
    } else if (lower.contains('fries') || lower.contains('truffle') || lower.contains('nacho')) {
      bgColor = const Color(0xFFF3EDF7);
      textColor = const Color(0xFF5B2375);
      icon = Icons.diamond_outlined;
    } else if (lower.contains('shake') || lower.contains('soda') || lower.contains('jarritos')) {
      bgColor = const Color(0xFFFCE7F3);
      textColor = const Color(0xFF9D174D);
      icon = Icons.wine_bar_rounded;
    } else if (lower.contains('churro') || lower.contains('waffle')) {
      bgColor = const Color(0xFFFCE7F3);
      textColor = const Color(0xFF9D174D);
      icon = Icons.bakery_dining_rounded;
    } else if (lower.contains('soft serve') || lower.contains('ice cream')) {
      bgColor = const Color(0xFFEDE8FC);
      textColor = const Color(0xFF7C52AA);
      icon = Icons.icecream_rounded;
    } else if (lower.contains('dip') || lower.contains('sauce')) {
      bgColor = const Color(0xFFE0F2FE);
      textColor = const Color(0xFF0284C7);
      icon = Icons.palette_outlined;
    } else if (lower.contains('prawn') || lower.contains('calamari')) {
      bgColor = const Color(0xFFF3EDF7);
      textColor = const Color(0xFF5B2375);
      icon = Icons.set_meal_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            tag,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Discovery Card ---
  Widget _buildDiscoveryCard() {
    return InkWell(
      onTap: widget.onExploreMore,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0E5F8), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 8,
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
                color: Color(0xFFF3EDF7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF5B2375),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Looking for more delicious deals?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F1528),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap Explore to discover newly dropped budget feasts with 4.8+ ratings around town.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B5E74),
                      height: 1.3,
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

  // --- Empty State ---
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 48, color: Color(0xFFBE185D)),
          const SizedBox(height: 12),
          Text(
            'No packages match your search',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F1528),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try clearing your search or picking another filter.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFF7C6D85),
            ),
          ),
        ],
      ),
    );
  }
}
