import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/platter_deal.dart';
import '../../state/diner_state.dart';

class TopReviewedFeastsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal)? onSelectDeal;
  final VoidCallback? onNavigateProfile;
  final VoidCallback? onNavigateNotifications;
  final VoidCallback? onSearch;

  const TopReviewedFeastsScreen({
    super.key,
    required this.onOpenDrawer,
    this.onSelectDeal,
    this.onNavigateProfile,
    this.onNavigateNotifications,
    this.onSearch,
  });

  @override
  State<TopReviewedFeastsScreen> createState() => _TopReviewedFeastsScreenState();
}

class _TopReviewedFeastsScreenState extends State<TopReviewedFeastsScreen> {
  int _selectedFilterIndex = 0; // 0: All Top Rated 4.9+, 1: Best Value Feasts
  final Set<String> _lovedCards = {};

  // Mock reviewer data matching the user's mockup image
  final List<Map<String, dynamic>> _hallOfFamePlatters = [
    {
      'id': 'volcano-churro',
      'title': 'Molten Biscoff Churro Volcano',
      'restaurant': 'Sugar Bloom Cafe',
      'price': '\$22.00',
      'perPerson': '(\$11/p)',
      'badge': 'Trending #1 Dessert',
      'badgeColor': const Color(0xFFA6056D),
      'rating': '4.95',
      'reviewsCount': '980 reviews',
      'quote':
          '"Pure dessert ecstasy! The churros are hot and crispy, ice cream is heavenly." — @SweetToothSam',
      'image':
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=800&q=80',
      'fallbackAsset': AssetConstants.churroSundae,
      'deal': PlatterDeal.sampleDeals.first,
    },
    {
      'id': 'seafood-bucket',
      'title': 'Supreme Seafood Snack Bucket',
      'restaurant': 'Ocean Catch Lounge',
      'price': '\$64.00',
      'perPerson': '(\$16/p)',
      'badge': 'Best Group Sharing',
      'badgeColor': const Color(0xFF00838F),
      'rating': '4.92',
      'reviewsCount': '750 reviews',
      'quote':
          '"Tons of crispy calamari and tiger prawns. Crisp dipping sauces." — @BobaBandit',
      'image':
          'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=800&q=80',
      'fallbackAsset': AssetConstants.bistroBella,
      'deal': PlatterDeal.sampleDeals.length > 1
          ? PlatterDeal.sampleDeals[1]
          : PlatterDeal.fiestaPlatter,
    },
    {
      'id': 'giant-breadstick',
      'title': '1-Meter Giant Cheesy Breadstick',
      'restaurant': 'Bella Crust Kitchen',
      'price': '\$28.00',
      'perPerson': '(\$7/p)',
      'badge': 'Viral Cheese Pull',
      'badgeColor': const Color(0xFF653993),
      'rating': '4.90',
      'reviewsCount': '520 reviews',
      'quote':
          '"The cheese pull is insane, our whole table went crazy for this." — @CheesyNoms',
      'image':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80',
      'fallbackAsset': AssetConstants.bistroBella,
      'deal': PlatterDeal.sampleDeals.length > 2
          ? PlatterDeal.sampleDeals[2]
          : PlatterDeal.fiestaPlatter,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7FC),
      appBar: _buildMainTopNavbar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Header with "Top Reviewed Feasts" & "500+ Verified" badge
          _buildHeaderRow(),
          const SizedBox(height: 14),

          // 2. Filter Tabs (All Top Rated ★ 4.9+ | Best Value Feasts)
          _buildFilterTabs(),
          const SizedBox(height: 14),

          // 3. Sorting & Live Updates Row
          _buildSortingRow(),
          const SizedBox(height: 16),

          // 4. Hero Card 1: Mega Fiesta Sizzle Platter (#1 Community Choice)
          _buildHeroCard(),
          const SizedBox(height: 24),

          // 5. Section Header: Hall of Fame Platters
          _buildHallOfFameHeader(),
          const SizedBox(height: 14),

          // 6. Hall of Fame Platters Cards
          ..._hallOfFamePlatters.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildHallOfFameCard(item),
              )),

          // 7. Verified Diner Reviews Guarantee Box
          _buildVerifiedGuaranteeBox(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Top Main Navbar (already in design)
  // -------------------------------------------------------------
  PreferredSizeWidget _buildMainTopNavbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Color(0xFF201A24), size: 24),
        onPressed: widget.onOpenDrawer,
        tooltip: 'Open menu',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Color(0xFF201A24), size: 23),
          onPressed: widget.onSearch ?? () {},
          tooltip: 'Search feasts',
        ),
        const SizedBox(width: 2),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            onTap: widget.onNavigateProfile ?? () {},
            child: Center(
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFA6056D), Color(0xFF7C52AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(color: Color(0xFFF2E6F5), height: 1),
      ),
    );
  }

  // -------------------------------------------------------------
  // Header Row: Top Reviewed Feasts & 500+ Verified Badge
  // -------------------------------------------------------------
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEBF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFFA6056D),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Top Reviewed Feasts',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: const Color(0xFF201A24),
                    letterSpacing: -0.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF0F8),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFF6CEE7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.security_rounded,
                color: Color(0xFFD6228A),
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                '500+ Verified',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD6228A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Filter Tabs: All Top Rated ★ 4.9+ & Best Value Feasts
  // -------------------------------------------------------------
  Widget _buildFilterTabs() {
    return Row(
      children: [
        // Tab 1: All Top Rated ★ 4.9+
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _selectedFilterIndex == 0
                    ? const Color(0xFF653993)
                    : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _selectedFilterIndex == 0
                      ? const Color(0xFF653993)
                      : const Color(0xFFEADBEE),
                  width: 1.2,
                ),
                boxShadow: _selectedFilterIndex == 0
                    ? [
                        BoxShadow(
                          color: const Color(0xFF653993).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: _selectedFilterIndex == 0
                          ? Colors.white
                          : const Color(0xFF653993),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'All Top Rated ★ 4.9+',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _selectedFilterIndex == 0
                            ? Colors.white
                            : const Color(0xFF4A3B56),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Tab 2: Best Value Feasts
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _selectedFilterIndex == 1
                    ? const Color(0xFF653993)
                    : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _selectedFilterIndex == 1
                      ? const Color(0xFF653993)
                      : const Color(0xFFEADBEE),
                  width: 1.2,
                ),
                boxShadow: _selectedFilterIndex == 1
                    ? [
                        BoxShadow(
                          color: const Color(0xFF653993).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      color: _selectedFilterIndex == 1
                          ? Colors.white
                          : const Color(0xFF706776),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Best Value Feasts',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _selectedFilterIndex == 1
                            ? Colors.white
                            : const Color(0xFF4A3B56),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Sorting & Live Updates Row
  // -------------------------------------------------------------
  Widget _buildSortingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort_rounded, size: 16, color: Color(0xFF8E7E98)),
                const SizedBox(width: 5),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sorted by: ',
                        style: GoogleFonts.dmSans(
                          fontSize: 11.5,
                          color: const Color(0xFF706776),
                        ),
                      ),
                      TextSpan(
                        text: 'Most & Highest Reviewed (500+)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF201A24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFD6228A),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Live Updates',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD6228A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Hero Card: Mega Fiesta Sizzle Platter
  // -------------------------------------------------------------
  Widget _buildHeroCard() {
    const cardId = 'hero-mega-fiesta';
    final isLoved = _lovedCards.contains(cardId);
    final deal = PlatterDeal.fiestaPlatter;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEDBEE), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(101, 57, 147, 0.08),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Overlays
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9.5,
                child: Image.network(
                  'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=800&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AssetConstants.tacoBodega,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Top-left: #1 Community Choice Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA6056D), Color(0xFFD6228A)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA6056D).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '#1 Community Choice',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top-right: Rating Badge
              Positioned(
                top: 12,
                right: 56,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: Color(0xFFFFB300)),
                      const SizedBox(width: 4),
                      Text(
                        '4.98 (1,420)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Far Top-right: Loved Heart Circle Button
              Positioned(
                top: 10,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isLoved) {
                        _lovedCards.remove(cardId);
                      } else {
                        _lovedCards.add(cardId);
                      }
                    });
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 17,
                        color: const Color(0xFFA6056D),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom-left: Location
              Positioned(
                bottom: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 12, color: Color(0xFFE2B2E8)),
                      const SizedBox(width: 4),
                      Text(
                        'Soho Quarter • 0.3 mi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom-right: Feast for 3–4
              Positioned(
                bottom: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF653993).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Feast for 3–4',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Below Image
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Pricing Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mega Fiesta Sizzle Platter',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w900,
                              fontSize: 16.5,
                              color: const Color(0xFF201A24),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Spice & Sizzle Bistro • Smoked meats & shareables',
                            style: GoogleFonts.dmSans(
                              fontSize: 11.5,
                              color: const Color(0xFF706776),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$45.00',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: const Color(0xFFA6056D),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '\$65.00',
                              style: GoogleFonts.dmSans(
                                fontSize: 11.5,
                                color: const Color(0xFFA59BA8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '\$15.00/person',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF00838F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 99% Squad Satisfaction banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF0F8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF5D3E8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_rounded,
                        size: 14,
                        color: Color(0xFFA6056D),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '99% Squad Satisfaction • 640 photo reviews uploaded',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA6056D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Testimonial Quote Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF4FC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF0E4F4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7C52AA),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'TF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"The pulled brisket and churro combo blew our squad away! Best table deal in London hands down."',
                              style: GoogleFonts.dmSans(
                                fontSize: 11.5,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF2D2335),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '— @TacoFiend (VIP Level 3)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF7E7388),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Action Buttons Row: Loved It + Select This Platter ->
                Row(
                  children: [
                    // Loved It Action Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFA6056D),
                        side: BorderSide(
                          color: isLoved
                              ? const Color(0xFFA6056D)
                              : const Color(0xFFE5B8DC),
                          width: 1.2,
                        ),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        backgroundColor: isLoved
                            ? const Color(0xFFFDE8F4)
                            : Colors.transparent,
                      ),
                      icon: Icon(
                        isLoved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 15,
                        color: const Color(0xFFA6056D),
                      ),
                      label: Text(
                        'Loved It',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isLoved) {
                            _lovedCards.remove(cardId);
                          } else {
                            _lovedCards.add(cardId);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 10),

                    // Select This Platter -> Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF653993),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                        ),
                        onPressed: () {
                          widget.onSelectDeal?.call(deal);
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Select This Platter',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 15),
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

  // -------------------------------------------------------------
  // Hall of Fame Header
  // -------------------------------------------------------------
  Widget _buildHallOfFameHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFA6056D),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Hall of Fame Platters',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: const Color(0xFF201A24),
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Ranked by Diners',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7C52AA),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Hall of Fame Card
  // -------------------------------------------------------------
  Widget _buildHallOfFameCard(Map<String, dynamic> item) {
    final cardId = item['id'] as String;
    final isLoved = _lovedCards.contains(cardId);
    final deal = item['deal'] as PlatterDeal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEDBEE), width: 1.1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(101, 57, 147, 0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Badges
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  item['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    item['fallbackAsset'] as String,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Top-left: Category Badge
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item['badgeColor'] as Color,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: (item['badgeColor'] as Color).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item['badge'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Bottom-left: Star Rating
              Positioned(
                bottom: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 13, color: Color(0xFFFFB300)),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating']} (${item['reviewsCount']})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom-right: Restaurant Name Pill
              Positioned(
                bottom: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item['restaurant'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Below Image
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: const Color(0xFF201A24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${item['price']} ',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: const Color(0xFFA6056D),
                            ),
                          ),
                          TextSpan(
                            text: item['perPerson'] as String,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: const Color(0xFF706776),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Review Quote Snippet
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '“',
                      style: TextStyle(
                        fontSize: 20,
                        height: 0.9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA6056D),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item['quote'] as String,
                        style: GoogleFonts.dmSans(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF4A3B56),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons Row
                Row(
                  children: [
                    // Loved It
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFA6056D),
                        side: BorderSide(
                          color: isLoved
                              ? const Color(0xFFA6056D)
                              : const Color(0xFFE5B8DC),
                          width: 1.1,
                        ),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        backgroundColor: isLoved
                            ? const Color(0xFFFDE8F4)
                            : Colors.transparent,
                      ),
                      icon: Icon(
                        isLoved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 14,
                        color: const Color(0xFFA6056D),
                      ),
                      label: Text(
                        'Loved It',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isLoved) {
                            _lovedCards.remove(cardId);
                          } else {
                            _lovedCards.add(cardId);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),

                    // Select This Platter ->
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF653993),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          widget.onSelectDeal?.call(deal);
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Select This Platter',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 14),
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

  // -------------------------------------------------------------
  // Verified Diner Reviews Guarantee Box
  // -------------------------------------------------------------
  Widget _buildVerifiedGuaranteeBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0F8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF6CEE7), width: 1.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF5CCE5)),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFFA6056D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '★ 100% Verified Diner Reviews',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: const Color(0xFFA6056D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'All reviews and star ratings are authentic and submitted only after completed Treat table visits.',
                  style: GoogleFonts.dmSans(
                    fontSize: 11.5,
                    color: const Color(0xFF706776),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
