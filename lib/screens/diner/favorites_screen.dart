import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/favorite_item.dart';
import '../../models/platter_deal.dart';
import '../../state/diner_state.dart';
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

  void _removeFavorite(FavoriteItem item) {
    final dinerState = context.read<DinerState>();
    dinerState.removeFavorite(item.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Removed "${item.title}" from Favorites',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFFFFD166),
          onPressed: () {
            dinerState.addFavorite(item);
          },
        ),
        backgroundColor: TreatColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addSampleFavorite() {
    final dinerState = context.read<DinerState>();
    dinerState.addFavorite(
      FavoriteItem.fromPlatterDeal(PlatterDeal.sunsetSlidersPlatter),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Added "The Sunset Sliders & Fries Feast" to Favorites! ❤️'),
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
    final dinerState = context.watch<DinerState>();
    final allFavorites = dinerState.favorites;

    final filteredFavorites = allFavorites.where((item) {
      if (_selectedFilter == 1) return item.category == 'Feast Boards';
      if (_selectedFilter == 2) return item.category == 'Sweet Lounges';
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
              _buildFilterChip('All Loved (${allFavorites.length})', 0),
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

  Widget _buildFavoriteCard(FavoriteItem item) {
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
          // Hero Image with Overlays
          Stack(
            children: [
              Image.network(
                item.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: const Color(0xFFF3E6FB),
                  alignment: Alignment.center,
                  child: const Icon(Icons.restaurant,
                      size: 48, color: TreatColors.primary),
                ),
              ),

              // Top Right Delete / Trash Button
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () => _removeFavorite(item),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: Color(0xFFEF4444)),
                  ),
                ),
              ),

              // Bottom Left Walking Badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      const Icon(Icons.directions_walk_rounded,
                          size: 14, color: Color(0xFF80D0F0)),
                      const SizedBox(width: 4),
                      Text(
                        item.distance,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      const Icon(Icons.star_rounded,
                          size: 15, color: Color(0xFFFFB703)),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating} (${item.reviews})',
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

          // Content Box
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: TreatColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: TreatColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.price,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: TreatColors.secondary,
                          ),
                        ),
                        Text(
                          item.splitPrice,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: TreatColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Inclusions if any
                if (item.items.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.items.map((it) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8EEFC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          it,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6A1B9A),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 14),

                // Bottom Action Buttons
                Row(
                  children: [
                    // Save badge button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.onSelectDeal?.call(
                            PlatterDeal.sampleDeals.firstWhere(
                              (d) => d.id == item.id,
                              orElse: () => PlatterDeal.sampleDeals.first,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8EEFC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Center(
                            child: Text(
                              item.saveBadge.isNotEmpty
                                  ? item.saveBadge
                                  : 'View Feast Details',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6A1B9A),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Loved It / Remove Favorite Button
                    InkWell(
                      onTap: () => _removeFavorite(item),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: TreatColors.secondary,
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
                            const Icon(
                              Icons.favorite,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: widget.onExploreMore,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              const SizedBox(width: 10),
              InkWell(
                onTap: _addSampleFavorite,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFD8B4FE)),
                  ),
                  child: Text(
                    '+ Add Sample Feast',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF7C52AA),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
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
