import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/platter_deal.dart';
import '../../widgets/treat_header.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal)? onSelectDeal;
  final VoidCallback? onExploreMore;

  const FavoritesScreen({
    super.key,
    required this.onOpenDrawer,
    this.onSelectDeal,
    this.onExploreMore,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedFilter = 0; // 0: All, 1: Feast Boards, 2: Sweet Lounges
  final Set<String> _lovedItemIds = {'fav_1', 'fav_2', 'fav_3'};

  final List<Map<String, dynamic>> _favorites = [
    {
      'id': 'fav_1',
      'title': 'Sugar Bloom Cafe & Brunch',
      'description': 'Sweet & savory sharing board with drinks',
      'price': '\$105.00',
      'splitPrice': '\$35/person',
      'saveBadge': 'Save \$28 • Pass',
      'distance': '0.4 mi • 8 mins walk',
      'rating': '4.9',
      'reviews': '420',
      'category': 'Feast Boards',
      'imageUrl':
          'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 'fav_2',
      'title': 'Sprinkle & Sizzle Social',
      'description': 'Loaded signature waffles & group smash slider tray',
      'price': '\$96.00',
      'splitPrice': '\$32/person',
      'saveBadge': 'Save \$20 • Pass',
      'distance': '0.6 mi • 12 mins walk',
      'rating': '4.9',
      'reviews': '128',
      'category': 'Sweet Lounges',
      'imageUrl':
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
    },
    {
      'id': 'fav_3',
      'title': 'Sugar Smash & Patty Lounge',
      'description': 'Artisan sparkling dessert milkshakes & combo platters',
      'price': '\$84.00',
      'splitPrice': '\$28/person',
      'saveBadge': 'Save \$18 • Pass',
      'distance': '0.9 mi • 16 mins walk',
      'rating': '4.8',
      'reviews': '94',
      'category': 'Sweet Lounges',
      'imageUrl':
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=800&q=80',
    },
  ];

  void _toggleLoved(String id) {
    setState(() {
      if (_lovedItemIds.contains(id)) {
        _lovedItemIds.remove(id);
      } else {
        _lovedItemIds.add(id);
      }
    });

    final isNowLoved = _lovedItemIds.contains(id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isNowLoved ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isNowLoved
                    ? 'Added to your Loved Favorites! ❤️'
                    : 'Removed from Favorites',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: TreatColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFavorites = _favorites.where((item) {
      if (_selectedFilter == 1) return item['category'] == 'Feast Boards';
      if (_selectedFilter == 2) return item['category'] == 'Sweet Lounges';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Treat',
        actionIcon: Icons.celebration,
        onActionTap: widget.onExploreMore,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 36),
        children: [
          // Filter Chips
          Row(
            children: [
              _buildFilterChip('All Loved (${_lovedItemIds.length})', 0),
              const SizedBox(width: 8),
              _buildFilterChip('Feast Boards', 1),
              const SizedBox(width: 8),
              _buildFilterChip('Sweet Lounges', 2),
            ],
          ),
          const SizedBox(height: 16),

          // Header Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 3,
                      height: 22,
                      decoration: BoxDecoration(
                        color: TreatColors.secondary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Your Loved Treat Spots',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: TreatColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${filteredFavorites.length} Spots',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: TreatColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Cards List
          if (filteredFavorites.isEmpty)
            _buildEmptyState()
          else
            ...filteredFavorites.map((item) => _buildFavoriteCard(item)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = index),
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? TreatColors.secondary
                : TreatColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(124, 82, 170, 0.25),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ]
                : const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    )
                  ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : TreatColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    final id = item['id'] as String;
    final isLoved = _lovedItemIds.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          // Hero Image with Overlays (matching screenshot)
          Stack(
            children: [
              Image.network(
                item['imageUrl'] as String,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: const Color(0xFFF3E6FB),
                  alignment: Alignment.center,
                  child: const Icon(Icons.restaurant, size: 48, color: TreatColors.primary),
                ),
              ),

              // Bottom Left Walking Badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.directions_walk_rounded, size: 14, color: Color(0xFF80D0F0)),
                      const SizedBox(width: 4),
                      Text(
                        item['distance'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Right Rating Badge
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFB703)),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating']} (${item['reviews']})',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF2B2035),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              color: TreatColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['description'] as String,
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
                    const SizedBox(width: 12),

                    // Price & Split
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['price'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE040A0), // Hot pink accent from image
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          item['splitPrice'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: TreatColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Bottom Action Buttons (matching screenshot)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Save Pass Pill Button
                    InkWell(
                      onTap: () {
                        widget.onSelectDeal?.call(PlatterDeal.sampleDeals.first);
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E6FB), // Soft lavender pill
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item['saveBadge'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                color: TreatColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Loved It Action Button
                    InkWell(
                      onTap: () => _toggleLoved(id),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C52AA), // Deep purple button from screenshot
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(124, 82, 170, 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Loved It',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isLoved ? Icons.favorite : Icons.favorite_border,
                              size: 15,
                              color: Colors.white,
                            ),
                          ],
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text('❤️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'No Loved Spots Yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: TreatColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap "Loved It ♡" on any feasting spot or platter to save it here for quick group bookings!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: TreatColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: widget.onExploreMore,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: TreatColors.secondary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Explore Spots ➔',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
