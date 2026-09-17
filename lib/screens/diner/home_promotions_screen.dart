import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/bangladesh_locations.dart';
import '../../models/platter_deal.dart';
import '../../state/budget_planner_state.dart';
import '../../state/diner_state.dart';
import '../../widgets/bangladesh_location_picker_dialog.dart';

class HomePromotionsScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal) onSelectDeal;
  final VoidCallback onNavigateBudgetPlanner;
  final VoidCallback? onNavigateProfile;
  final VoidCallback? onNavigateNotifications;
  final VoidCallback? onNavigateFavorites;
  final VoidCallback? onBackToLogin;
  final VoidCallback? onNavigateLogin;

  const HomePromotionsScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onSelectDeal,
    required this.onNavigateBudgetPlanner,
    this.onNavigateProfile,
    this.onNavigateNotifications,
    this.onNavigateFavorites,
    this.onBackToLogin,
    this.onNavigateLogin,
  });

  @override
  State<HomePromotionsScreen> createState() => _HomePromotionsScreenState();
}

class _HomePromotionsScreenState extends State<HomePromotionsScreen> {
  int _selectedFilterIndex = 0;
  final Set<String> _lovedItems = {'platter-1'};
  late final PageController _carouselController;
  final ScrollController _categoryScrollController = ScrollController();
  Timer? _carouselTimer;
  int _activeCarouselPage = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _filters = [
    {
      'label': 'Trending Platters',
      'icon': Icons.local_fire_department,
    },
    {
      'label': 'Squad Feasts',
      'icon': Icons.groups_rounded,
    },
    {
      'label': 'Flash Drops',
      'icon': Icons.bolt_rounded,
    },
    {
      'label': 'Dessert Craze',
      'icon': Icons.cake_rounded,
    },
    {
      'label': 'Taco & Nacho Trays',
      'icon': Icons.fastfood_rounded,
    },
    {
      'label': 'Mega Deep-Dish',
      'icon': Icons.local_pizza_rounded,
    },
    {
      'label': 'Slushie Pitchers',
      'icon': Icons.local_drink_rounded,
    },
    {
      'label': 'Midnight Munchies',
      'icon': Icons.nightlife_rounded,
    },
  ];

  // Workable Platter Carousel Items matching the design mockup
  late final List<Map<String, dynamic>> _platters;

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.92);

    // Automatic slider after 3 sec
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_carouselController.hasClients || _platters.isEmpty) return;
      final nextPage = (_activeCarouselPage + 1) % _platters.length;
      _carouselController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });

    _platters = [
      {
        'id': 'platter-3',
        'title': 'Neon Glaze Fiesta Platter',
        'description':
            'Buy 1 signature mega dessert & group taco tray, get second free! Made for 3-5 hungry sweeties.',
        'price': 32.0,
        'originalPrice': 64.0,
        'savedPercent': '50% SAVED',
        'badgeDeal': '2-FOR-1 DEAL',
        'badgeDealIcon': Icons.bolt_rounded,
        'distance': '0.4 mi away',
        'timeLeft': 'Ends in 2h 14m',
        'perkNote': 'Includes 6 sweet dips',
        'imageUrl':
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
        'fallbackEmoji': '🍩🌮🍨',
        'deal': PlatterDeal.sampleDeals.length > 2
            ? PlatterDeal.sampleDeals[2]
            : PlatterDeal.fiestaPlatter,
      },
      {
        'id': 'platter-1',
        'title': 'Tokyo Berry Mochi Dream',
        'description':
            'Warm strawberry mochi stack, matcha cream dips & 4 iced sakura slushies for your whole squad.',
        'price': 28.0,
        'originalPrice': 48.0,
        'savedPercent': '42% SAVED',
        'badgeDeal': 'SQUAD FEAST',
        'badgeDealIcon': Icons.groups_rounded,
        'distance': '0.6 mi away',
        'timeLeft': 'Ends in 3h 30m',
        'perkNote': 'Includes 4 craft matcha floats',
        'imageUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        'fallbackEmoji': '🍓🍵🍡',
        'deal': PlatterDeal.fiestaPlatter,
      },
      {
        'id': 'platter-2',
        'title': 'Squad Crunch & Slush Tower',
        'description':
            'Valid for 4+ sweeties! Loaded churro bites, Belgian waffle towers, and sparkling slush pitcher.',
        'price': 36.0,
        'originalPrice': 60.0,
        'savedPercent': '40% SAVED',
        'badgeDeal': 'MEGA DEAL',
        'badgeDealIcon': Icons.auto_awesome,
        'distance': '0.9 mi away',
        'timeLeft': 'Ends in 1h 45m',
        'perkNote': 'Includes sparkling slush pitcher',
        'imageUrl':
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80',
        'fallbackEmoji': '🧇🍧✨',
        'deal': PlatterDeal.megaFeastPlatter,
      },
      {
        'id': 'platter-4',
        'title': 'Sugar Cloud Pancake Platter',
        'description':
            '4 fluffy Japanese souffle cloud pancakes, cotton candy crown, warm maple butter & sparkle syrups.',
        'price': 24.0,
        'originalPrice': 40.0,
        'savedPercent': '40% SAVED',
        'badgeDeal': 'FLASH DROP',
        'badgeDealIcon': Icons.electric_bolt_rounded,
        'distance': '0.3 mi away',
        'timeLeft': 'Ends in 45m',
        'perkNote': 'Includes cotton candy crown',
        'imageUrl':
            'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?auto=format&fit=crop&w=800&q=80',
        'fallbackEmoji': '🥞🍭☁️',
        'deal': PlatterDeal.sampleDeals.length > 2
            ? PlatterDeal.sampleDeals[2]
            : PlatterDeal.fiestaPlatter,
      },
    ];
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    _categoryScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleLoved(String id, String itemName) {
    final isFoodie = context.read<DinerState>().isFoodieLoggedIn;
    if (!isFoodie) {
      (widget.onNavigateLogin ?? widget.onBackToLogin)?.call();
      return;
    }

    setState(() {
      if (_lovedItems.contains(id)) {
        _lovedItems.remove(id);
      } else {
        _lovedItems.add(id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final isLoved = _lovedItems.contains(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isLoved ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isLoved
                    ? 'Added "$itemName" to Loved!'
                    : 'Removed "$itemName" from Loved',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: isLoved ? TreatColors.primary : TreatColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final dinerState = context.watch<DinerState>();

    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: _buildTopAppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 48),
        children: [
          // 0. Location Pill Bar with Feni Sadar Quick Roads (Shown ONLY for Foodie login, NOT for Explore without Login)
          if (dinerState.isFoodieLoggedIn) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: _buildLocationBar(context),
            ),
            const SizedBox(height: 10),
          ],

          // 1. Live Nearby Platters Ticker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildLiveTicker(),
          ),
          const SizedBox(height: 12),

          // 2. Search Sweets, Spots & Group Platters Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 14),

          // 3. Filter Category Chips (Trending Platters, Squad Feasts, etc.)
          _buildFilterChipsRow(),
          const SizedBox(height: 20),

          // 4. Section: HOT NEARBY - Hottest Platters Near You (Workable Carousel / Slider)
          _buildHottestPlattersCarouselSection(),
          const SizedBox(height: 28),

          // 5. Section: WHAT'S ON NOW - Exploring Current Events
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildExploringEventsSection(),
          ),
          const SizedBox(height: 26),

        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Optimized Topbar Map & Quick Location Bar
  // -------------------------------------------------------------
  Widget _buildLocationBar(BuildContext context) {
    final dinerState = context.watch<DinerState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Location & Map Pill Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: const Color(0xFFEADBEE),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(124, 82, 170, 0.09),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Row(
            children: [
              // Dual Map Radar Pin Icon Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showChangeLocationModal(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA6056D), Color(0xFF7C52AA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA6056D).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // User's location title
              Expanded(
                child: InkWell(
                  onTap: () => _showChangeLocationModal(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      dinerState.userLocation,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1624),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Magenta CHANGE button (Preserves test expectation)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showChangeLocationModal(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA6056D), Color(0xFFBF1180)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA6056D).withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.swap_horiz_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'CHANGE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Separator dot
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0D3E5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Purple radius dropdown pill (Preserves test expectation)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showRadiusModal(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF653993),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dinerState.locationRadius,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Quick Road Selection Row under Feni Sadar (Multiple buttons right on Homepage)
        const SizedBox(height: 7),
        _buildFeniSadarQuickRoadsRow(context),
      ],
    );
  }

  // -------------------------------------------------------------
  // Quick Road Buttons Row under Feni Sadar on Homepage
  // -------------------------------------------------------------
  Widget _buildFeniSadarQuickRoadsRow(BuildContext context) {
    final dinerState = context.watch<DinerState>();
    final roads = BangladeshLocations.feniSadarRoads;

    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: roads.length + 2,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Label indicator
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EAF8),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE2D4EA)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.explore_rounded,
                      size: 13, color: Color(0xFFA6056D)),
                  const SizedBox(width: 4),
                  Text(
                    'Feni Sadar Roads:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA6056D),
                    ),
                  ),
                ],
              ),
            );
          }

          if (index == roads.length + 1) {
            // "+ More BD Districts" button
            return ActionChip(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              backgroundColor: const Color(0xFFFBF6FD),
              shape: const StadiumBorder(
                side: BorderSide(color: Color(0xFFE5D7EB)),
              ),
              avatar: const Icon(
                Icons.add_location_alt_rounded,
                size: 12,
                color: Color(0xFF653993),
              ),
              label: Text(
                '+ All BD Districts',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF653993),
                ),
              ),
              onPressed: () => _showChangeLocationModal(context),
            );
          }

          final road = roads[index - 1];
          final isSelected = dinerState.userLocation.contains(road);

          return ActionChip(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            backgroundColor: isSelected ? const Color(0xFFA6056D) : Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFA6056D)
                    : const Color(0xFFE5D7EB),
                width: isSelected ? 1.4 : 1.0,
              ),
            ),
            avatar: Icon(
              isSelected ? Icons.check : Icons.near_me_rounded,
              size: 12,
              color: isSelected ? Colors.white : const Color(0xFFA6056D),
            ),
            label: Text(
              road,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF2C2235),
              ),
            ),
            onPressed: () {
              context.read<DinerState>().setUserLocation('$road, Feni Sadar');
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Location updated to $road, Feni Sadar'),
                  duration: const Duration(milliseconds: 1500),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFFA6056D),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showChangeLocationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BangladeshLocationPickerDialog(
        currentLocation: context.read<DinerState>().userLocation,
        onLocationSelected: (newLocation) {
          context.read<DinerState>().setUserLocation(newLocation);
        },
      ),
    );
  }

  void _showRadiusModal(BuildContext context) {
    final radiusOptions = [
      'Within 1 mi',
      'Within 2 mi',
      'Within 5 mi',
      'Within 10 mi',
      'Within 15 mi',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final currentRadius = context.watch<DinerState>().locationRadius;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD3E2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Select Search Radius',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: const Color(0xFF201A24),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find food platters and instant drops within:',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFF706776),
                  ),
                ),
                const SizedBox(height: 12),
                ...radiusOptions.map((opt) {
                  final isSelected = opt == currentRadius;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF2E8FC) : const Color(0xFFF6F3F7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? const Color(0xFF653993) : const Color(0xFFA098A5),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      opt,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? const Color(0xFF653993) : const Color(0xFF201A24),
                      ),
                    ),
                    onTap: () {
                      context.read<DinerState>().setLocationRadius(opt);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // Top App Bar matching mockup
  // -------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar() {
    final isFoodieLoggedIn = context.watch<DinerState>().isFoodieLoggedIn;
    return AppBar(
      backgroundColor: TreatColors.surface.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 2,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      toolbarHeight: 58,
      title: Row(
        children: [
          // Hamburger Menu Button (Foodie) OR Back Button (Guest / Explore Without Sign In)
          InkWell(
            onTap: isFoodieLoggedIn ? widget.onOpenDrawer : widget.onBackToLogin,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(
                isFoodieLoggedIn ? Icons.menu : Icons.arrow_back_ios_new_rounded,
                color: TreatColors.onSurface,
                size: isFoodieLoggedIn ? 24 : 20,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Treat Logo (Treat button only enabled for Foodie login, not available for Explore Without Sign In)
          Expanded(
            child: InkWell(
              onTap: isFoodieLoggedIn ? widget.onNavigateBudgetPlanner : null,
              borderRadius: BorderRadius.circular(8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AssetConstants.logo,
                  height: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),


          // Favorites, Notifications & Profile Avatar Icon Buttons (Shown ONLY for Foodie login, NOT in Explore without Sign In)
          if (context.watch<DinerState>().isFoodieLoggedIn) ...[
            const SizedBox(width: 4),
            // Favorites Icon Button
            InkWell(
              onTap: widget.onNavigateFavorites,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: TreatColors.onSurface,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: widget.onNavigateNotifications,
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: TreatColors.onSurface,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD6228A),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: widget.onNavigateProfile,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD6228A),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Live Nearby Platters Ticker Bar
  // -------------------------------------------------------------
  Widget _buildLiveTicker() {
    return Row(
      children: [
        Icon(
          Icons.language,
          size: 16,
          color: TreatColors.secondary.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'Live nearby platters updating in real-time',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: TreatColors.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: TreatColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: TreatColors.secondaryFixed,
              width: 1.2,
            ),
          ),
          child: Text(
            '14 Active Feasts',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: TreatColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Search Sweets & Spots Input Bar
  // -------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: TreatColors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: TreatColors.onSurfaceVariant,
          ),
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
                hintText: 'Search sweets, spots & group pla...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: TreatColors.onSurfaceVariant.withValues(alpha: 0.65),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: TreatColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.tune_rounded,
                size: 16,
                color: TreatColors.secondary,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter sliders: sorting by nearest distance & highest discounts!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Filter Category Chips (Horizontal Scrollable)
  // -------------------------------------------------------------
  Widget _buildFilterChipsRow() {
    return SizedBox(
      height: 42,
      child: SingleChildScrollView(
        controller: _categoryScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_filters.length, (index) {
            final filter = _filters[index];
            final isSelected = index == _selectedFilterIndex;

            final bg = isSelected ? TreatColors.secondary : TreatColors.surfaceContainerLowest;
            final textFg = isSelected ? Colors.white : TreatColors.onSurface;
            final iconFg = isSelected ? Colors.white : TreatColors.secondary;

            return Padding(
              padding: EdgeInsets.only(right: index < _filters.length - 1 ? 8 : 0),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedFilterIndex = index);
                  if (_categoryScrollController.hasClients) {
                    final target = (index * 130.0).clamp(0.0, _categoryScrollController.position.maxScrollExtent);
                    _categoryScrollController.animateTo(
                      target,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(999),
                    border: isSelected
                        ? null
                        : Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.5)),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color.fromRGBO(124, 82, 170, 0.35),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        filter['icon'] as IconData,
                        size: 16,
                        color: iconFg,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        filter['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: textFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // HOT NEARBY - Hottest Platters Near You (Workable Carousel / Slider)
  // -------------------------------------------------------------
  Widget _buildHottestPlattersCarouselSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 15,
                          color: Color(0xFFE040A0),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'HOT NEARBY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: const Color(0xFFE040A0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Hottest Platters Near You',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                        color: TreatColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter radius pill / Subtitle link
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Showing platters within 1.2 miles of your location!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: TreatColors.secondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Within 1.2 mi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: TreatColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: TreatColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Carousel Slider container with PageView
        SizedBox(
          height: 440,
          child: PageView.builder(
            controller: _carouselController,
            physics: const BouncingScrollPhysics(),
            itemCount: _platters.length,
            onPageChanged: (index) {
              setState(() {
                _activeCarouselPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _platters[index];
              return _buildCarouselCard(item, index);
            },
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Single Platter Carousel Card matching the design
  // -------------------------------------------------------------
  Widget _buildCarouselCard(Map<String, dynamic> item, int index) {
    final isLoved = _lovedItems.contains(item['id'] as String);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TreatColors.outlineVariant.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.12),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Food Image Container with Overlay Badges
          Stack(
            children: [
              SizedBox(
                height: 190,
                width: double.infinity,
                child: Image.network(
                  item['imageUrl'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD6EE), Color(0xFFEEDCFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item['fallbackEmoji'] as String,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient shadow overlay on image
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.30),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Top Left Badge: ⚡ 2-FOR-1 DEAL
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE040A0),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(224, 64, 160, 0.45),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['badgeDealIcon'] as IconData,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['badgeDeal'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top Right Badge: 0.4 mi away
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item['distance'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Bottom Left Badge on image: ⏱ Ends in 2h 14m
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: TreatColors.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['timeLeft'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: TreatColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Card Body Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title & Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          color: TreatColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['description'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                          color: TreatColors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Pricing row with Discount Badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '৳${(item['price'] as double).toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: TreatColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '৳${(item['originalPrice'] as double).toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                              color: TreatColors.outline,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ group',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: TreatColors.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: TreatColors.secondaryFixed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['savedPercent'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                                color: TreatColors.onSecondaryFixedVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['perkNote'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE040A0),
                        ),
                      ),
                    ],
                  ),

                  // Action Buttons Row: Loved It + View Details
                  Row(
                    children: [
                      // Loved It Toggle Button
                      Expanded(
                        flex: 5,
                        child: OutlinedButton.icon(
                          onPressed: () => _toggleLoved(
                            item['id'] as String,
                            item['title'] as String,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isLoved
                                ? const Color(0xFFE040A0)
                                : TreatColors.onSurface,
                            side: BorderSide(
                              color: isLoved
                                  ? const Color(0xFFE040A0)
                                  : TreatColors.outlineVariant,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: Icon(
                            isLoved ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isLoved
                                ? const Color(0xFFE040A0)
                                : TreatColors.secondary,
                          ),
                          label: Text(
                            isLoved ? 'Loved' : 'Loved It',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // View Details Action Button
                      Expanded(
                        flex: 6,
                        child: ElevatedButton(
                          onPressed: () {
                            final deal = item['deal'] as PlatterDeal;
                            context.read<BudgetPlannerState>().selectPlatter(deal);
                            widget.onSelectDeal(deal);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TreatColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Details',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
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
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // WHAT'S ON NOW - Exploring Current Events Section
  // -------------------------------------------------------------
  Widget _buildExploringEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 15,
              color: Color(0xFFE040A0),
            ),
            const SizedBox(width: 4),
            Text(
              "WHAT'S ON NOW",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: const Color(0xFFE040A0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Exploring Current Events',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
            color: TreatColors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Popular happenings & live gatherings near Soho Quarter',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: TreatColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 14),

        // Event Card 1: Sprinkle & Sizzle Social
        _buildEventCard(
          id: 'event-1',
          name: 'Sprinkle & Sizzle Social',
          rating: '4.9 (1.2k)',
          tableBadge: 'Instant Table',
          tableBadgeIcon: Icons.bolt_rounded,
          location: 'Soho Quarter • 0.4 miles away',
          costCategory: '৳৳ • Feasts',
          liveRibbon: '🎉 Live Event Tonight: Neon Dessert Rave',
          price: '৳28',
          priceUnit: '/ person avg',
          tags: ['Waffle Sliders', 'Boba Cocktails', 'Funky Booths'],
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAI0nXAGOn5z6bdt7tUpeXQ25PdhR9-ArKdCBUnDu9K7fVgHVT7dnjTfUlS6m7Aobwkgcl3Mo4AFhIWAbVYlF2si30TPDz5ZhXQrbAcGIAdEIhYjhxsxjQqKQjoum3cSJJ3kJ7ibeXlHS-c635oq6v8XOjaiM0sLKr-Nw031Gs1NBkRCNltcjvFPQ-4GGfb3PvvCMdq8AnHJUyiszsBm1oZqbLOTpMfeMaJ36mJClJa8iw__UzGVePMkQ',
          fallbackEmoji: '🍧🍹🎉',
          actionLabel: 'Join Gathering',
          onAction: () {
            final isFoodie = context.read<DinerState>().isFoodieLoggedIn;
            if (!isFoodie) {
              (widget.onNavigateLogin ?? widget.onBackToLogin)?.call();
              return;
            }
            final deal = PlatterDeal.fiestaPlatter;
            context.read<BudgetPlannerState>().selectPlatter(deal);
            widget.onSelectDeal(deal);
          },
        ),
        const SizedBox(height: 18),

        // Event Card 2: Sugar Bloom Cafe & Brunch
        _buildEventCard(
          id: 'event-2',
          name: 'Sugar Bloom Cafe & Brunch',
          rating: '4.9 (420)',
          tableBadge: 'Foodie Trivia Feast',
          tableBadgeIcon: Icons.cake_rounded,
          location: 'Wardour St, Soho • Open till 11 PM',
          imageOverlaySubtitle: '0.4 mi • 8 mins walk',
          costCategory: '৳৳ • Feasts',
          price: '৳35',
          priceUnit: '/ person',
          tags: ['Sweet & Savory Board', 'Craft Milkshakes', 'Trivia Host'],
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC-sDzPusqpFUmqYi-cDYUoEfIVm_LEL-RisEaCn8vxp-Gpt08mdYjdg6WQH4P3Sz5_NW3faaPeSvNbliasdcrO6AjC_Xa0faUiPJ51iaM14qc-TUXY88sBmJN5CX9Qeu0SZ0FWpvmLdMr2Mjbv8QxwgF8EI9Zaixke5qRW0PY-2joDD3DkONh0RRmbsktg-s1HmnjMro86czBsyZx2c344F2tlOVhzRpdf9OosaI4_rXIiurSWCEtm2Q',
          fallbackEmoji: '☕🥞✨',
          actionLabel: 'RSVP Table',
          onAction: () {
            final isFoodie = context.read<DinerState>().isFoodieLoggedIn;
            if (!isFoodie) {
              (widget.onNavigateLogin ?? widget.onBackToLogin)?.call();
              return;
            }
            final deal = PlatterDeal.sampleDeals.length > 2
                ? PlatterDeal.sampleDeals[2]
                : PlatterDeal.fiestaPlatter;
            context.read<BudgetPlannerState>().selectPlatter(deal);
            widget.onSelectDeal(deal);
          },
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Single Event Card matching the wireframe mockup
  // -------------------------------------------------------------
  Widget _buildEventCard({
    required String id,
    required String name,
    required String rating,
    required String tableBadge,
    required IconData tableBadgeIcon,
    required String location,
    String? imageOverlaySubtitle,
    required String costCategory,
    String? liveRibbon,
    required String price,
    required String priceUnit,
    required List<String> tags,
    required String imageUrl,
    required String fallbackEmoji,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final isLoved = _lovedItems.contains(id);

    return Container(
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TreatColors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.10),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Banner Image with Overlays
          Stack(
            children: [
              SizedBox(
                height: 185,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEEDCFF), Color(0xFFC8EAFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        fallbackEmoji,
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.70),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Top Badges Row
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFE040A0),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            rating,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: TreatColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Table Badge (e.g. Instant Table)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TreatColors.secondary.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tableBadgeIcon, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                tableBadge,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Share Button
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gathering link for "$name" copied! Share with squad.'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.40),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom overlay on image
              Positioned(
                bottom: liveRibbon != null ? 34 : 12,
                left: 14,
                right: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 6),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  imageOverlaySubtitle ?? location,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.90),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: TreatColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        costCategory,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: TreatColors.onTertiaryFixed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Optional bottom neon ribbon on image
              if (liveRibbon != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE040A0).withValues(alpha: 0.92),
                          TreatColors.secondary.withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                    child: Text(
                      liveRibbon,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Event Card Content Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Title + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                              color: TreatColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 13,
                                color: TreatColors.secondary,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  location,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: TreatColors.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                costCategory,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: TreatColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Price Tag
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: TreatColors.secondary,
                          ),
                        ),
                        Text(
                          priceUnit,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: TreatColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: TreatColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: TreatColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Action Buttons Row (Loved It + Join / RSVP)
                Row(
                  children: [
                    // Loved It Toggle Button
                    Expanded(
                      flex: 5,
                      child: OutlinedButton.icon(
                        onPressed: () => _toggleLoved(id, name),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isLoved
                                ? const Color(0xFFE040A0)
                                : TreatColors.onSurface,
                          side: BorderSide(
                            color: isLoved
                                ? const Color(0xFFE040A0)
                                : TreatColors.outlineVariant,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: Icon(
                          isLoved ? Icons.favorite : Icons.favorite_border,
                          size: 15,
                          color: isLoved
                              ? const Color(0xFFE040A0)
                              : TreatColors.secondary,
                        ),
                        label: Text(
                          isLoved ? 'Loved' : 'Loved It',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Primary Action Button
                    Expanded(
                      flex: 6,
                      child: ElevatedButton(
                        onPressed: onAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TreatColors.secondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                actionLabel,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded, size: 14),
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
}
