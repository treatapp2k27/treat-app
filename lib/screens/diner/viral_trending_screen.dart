import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/treat_colors.dart';
import '../../models/bangladesh_locations.dart';
import '../../models/platter_deal.dart';
import '../../state/diner_state.dart';
import '../../widgets/bangladesh_location_picker_dialog.dart';

class ViralTrendingScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final Function(PlatterDeal deal)? onSelectDeal;
  final VoidCallback? onNavigateNotifications;
  final VoidCallback? onNavigateProfile;
  final VoidCallback? onExploreMore;

  const ViralTrendingScreen({
    super.key,
    required this.onOpenDrawer,
    this.onSelectDeal,
    this.onNavigateNotifications,
    this.onNavigateProfile,
    this.onExploreMore,
  });

  @override
  State<ViralTrendingScreen> createState() => _ViralTrendingScreenState();
}

class _ViralTrendingScreenState extends State<ViralTrendingScreen> {
  int _selectedPlatformIndex = 0;
  int _selectedTagIndex = 0;
  final Set<String> _lovedItemIds = {'sundae-1', 'birria-2'};
  final TextEditingController _bountyLinkController = TextEditingController();

  final List<Map<String, dynamic>> _platformFilters = [
    {'label': 'All Viral (24)', 'icon': null},
    {'label': 'TikTok (11)', 'icon': Icons.music_note_rounded},
    {'label': 'Instagram (8)', 'icon': Icons.camera_alt_rounded},
    {'label': 'Facebook (5)', 'icon': Icons.public_rounded},
  ];

  final List<String> _tagChips = [
    '🧀 Cheese Pulls',
    '🍧 Mega Desserts',
    '🌮 Street Platters',
    '🔥 Secret Menus',
    '✨ Foodie Bounties',
  ];

  @override
  void dispose() {
    _bountyLinkController.dispose();
    super.dispose();
  }

  void _toggleLoved(String id, String title) {
    setState(() {
      if (_lovedItemIds.contains(id)) {
        _lovedItemIds.remove(id);
      } else {
        _lovedItemIds.add(id);
      }
    });

    final isLoved = _lovedItemIds.contains(id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLoved ? 'Added "$title" to Loved!' : 'Removed "$title" from Loved',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        backgroundColor: isLoved ? const Color(0xFFD6228A) : const Color(0xFF653993),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _submitBounty() {
    final text = _bountyLinkController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please paste a TikTok or Instagram link to submit!',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFFD6228A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _bountyLinkController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 Bounty submitted! 200 Treat Coins will be credited once verified.',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF653993),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: _buildTopAppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 48),
        children: [
          // 1. Location & Radius Pill Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildLocationRadiusBar(),
          ),
          const SizedBox(height: 12),

          // 2. 24 Viral Dishes Announcement Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildAnnouncementBanner(),
          ),
          const SizedBox(height: 14),

          // 3. Platform Filter Chips (Row 1)
          _buildPlatformFilterRow(),
          const SizedBox(height: 10),

          // 4. Food Craze Tags (Row 2)
          _buildTagChipsRow(),
          const SizedBox(height: 18),

          // 5. Card 1: The Molten Biscoff & Churro Volcano Sundae
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildVolcanoSundaeCard(),
          ),
          const SizedBox(height: 24),

          // 6. Section Header: Fresh Social Drops
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFreshDropsHeader(),
          ),
          const SizedBox(height: 14),

          // 7. Card 2: Mega 4-Tier Loaded Birria Quesataco Platter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildBirriaQuesatacoCard(),
          ),
          const SizedBox(height: 20),

          // 8. Card 3: The 1-Meter Giant Cheesy Garlic Breadstick Feast
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCheesyBreadstickCard(),
          ),
          const SizedBox(height: 20),

          // 9. Card 4: Fluffy Japanese Souffle Pancake Cloud Stack
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSoufflePancakesCard(),
          ),
          const SizedBox(height: 24),

          // 10. Card 5: Foodie Bounty Banner ("Spot a Viral Craving?")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFoodieBountyCard(),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Top App Bar (Standard 58px matching Homepage)
  // -------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: TreatColors.surface.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 2,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      toolbarHeight: 58,
      title: Row(
        children: [
          // Hamburger Menu Button
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

          // Treat Logo
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
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
            ),
          ),

          // Search Icon
          IconButton(
            icon: const Icon(Icons.search_rounded, color: TreatColors.onSurface, size: 22),
            onPressed: widget.onExploreMore,
          ),
          const SizedBox(width: 4),

          // Circular Profile Avatar
          InkWell(
            onTap: widget.onNavigateProfile,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5B2375),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Location & Radius Bar
  // -------------------------------------------------------------
  Widget _buildLocationRadiusBar() {
    final dinerState = context.watch<DinerState>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDE5F2),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.06),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Magenta Circle Pin Icon
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFDE8F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFFD6228A),
              size: 19,
            ),
          ),
          const SizedBox(width: 10),

          // Location and Radius details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Location & Radius',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7A6F82),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        dinerState.userLocation,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F1528),
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Color(0xFF1F1528),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD6228A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dinerState.locationRadius,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5B2375),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Color(0xFF5B2375),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Change button
          InkWell(
            onTap: () => _showChangeLocationModal(context),
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Change',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD6228A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangeLocationModal(BuildContext context) {
    final dinerState = context.read<DinerState>();
    final preferredOptions = BangladeshLocations.feniSadarRoads
        .map((road) => '$road, Feni Sadar')
        .toList();

    // Default dropdown selection to current user location or first preferred road
    String selectedArea = preferredOptions.contains(dinerState.userLocation)
        ? dinerState.userLocation
        : preferredOptions.firstWhere(
            (opt) => dinerState.userLocation.contains(opt.split(',').first),
            orElse: () => preferredOptions.first,
          );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFA6056D),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Trending Area',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: const Color(0xFF201A24),
                        ),
                      ),
                      Text(
                        'Preferred locations from homepage:',
                        style: GoogleFonts.dmSans(
                          fontSize: 11.5,
                          color: const Color(0xFF706776),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred Road / Location (Feni Sadar)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5A4D64),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown of preferred locations from homepage
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF6FD),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2D6EE), width: 1.2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedArea,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFFA6056D)),
                          items: preferredOptions.map((area) {
                            return DropdownMenuItem<String>(
                              value: area,
                              child: Row(
                                children: [
                                  const Icon(Icons.place_rounded,
                                      size: 15, color: Color(0xFFA6056D)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      area,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF201A24),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedArea = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Tap Popular Roads
                    Text(
                      'Quick Select Road:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        'Mizan Road',
                        'SSK Road',
                        'Hospital Road',
                        'Doctorpara Road',
                        'Mohipal Road',
                        'Trunk Road',
                      ].map((road) {
                        final formatted = '$road, Feni Sadar';
                        final isChosen = selectedArea == formatted;
                        return ActionChip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            road,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isChosen ? FontWeight.w800 : FontWeight.w600,
                              color: isChosen ? Colors.white : const Color(0xFF201A24),
                            ),
                          ),
                          backgroundColor: isChosen
                              ? const Color(0xFFA6056D)
                              : const Color(0xFFF7F0FA),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isChosen
                                  ? const Color(0xFFA6056D)
                                  : const Color(0xFFE2D6EE),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              selectedArea = formatted;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Button to open full Bangladesh 64-district modal
                    InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        showDialog(
                          context: context,
                          builder: (c) => BangladeshLocationPickerDialog(
                            currentLocation: dinerState.userLocation,
                            onLocationSelected: (newLoc) {
                              context.read<DinerState>().setUserLocation(newLoc);
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.travel_explore_rounded,
                                  size: 16, color: Color(0xFF653993)),
                              const SizedBox(width: 6),
                              Text(
                                '+ Explore All 64 BD Districts',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF653993),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF706776),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6056D),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  elevation: 0,
                ),
                onPressed: () {
                  context.read<DinerState>().setUserLocation(selectedArea);
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Apply Location',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // 24 Viral Dishes Announcement Banner
  // -------------------------------------------------------------
  Widget _buildAnnouncementBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFFF3C7E3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: const Color(0xFF4A2758),
                ),
                children: [
                  TextSpan(
                    text: '24 Viral Dishes ',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFD6228A),
                    ),
                  ),
                  const TextSpan(
                    text: 'trending near you right now',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Color(0xFFD6228A),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Platform Filter Chips (Row 1)
  // -------------------------------------------------------------
  Widget _buildPlatformFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_platformFilters.length, (index) {
          final filter = _platformFilters[index];
          final isSelected = _selectedPlatformIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedPlatformIndex = index),
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5B2375) : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF5B2375) : const Color(0xFFEDE5F2),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color.fromRGBO(91, 35, 117, 0.22),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filter['icon'] != null) ...[
                      Icon(
                        filter['icon'] as IconData,
                        size: 14,
                        color: isSelected ? Colors.white : const Color(0xFF5B2375),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      filter['label'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1F1528),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------
  // Food Craze Tag Chips (Row 2)
  // -------------------------------------------------------------
  Widget _buildTagChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_tagChips.length, (index) {
          final tag = _tagChips[index];
          final isSelected = _selectedTagIndex == index;

          Color bg = Colors.white;
          Color border = const Color(0xFFEDE5F2);

          if (index == 0) {
            bg = const Color(0xFFFFF9E6);
            border = const Color(0xFFFFE699);
          } else if (index == 1) {
            bg = const Color(0xFFFFEBF6);
            border = const Color(0xFFFFB3DF);
          } else if (index == 2) {
            bg = const Color(0xFFE6F7FF);
            border = const Color(0xFF99DEFF);
          } else if (index == 3) {
            bg = const Color(0xFFFFF2E8);
            border = const Color(0xFFFFD4B8);
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTagIndex = index),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                decoration: BoxDecoration(
                  color: isSelected ? bg : bg.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFD6228A) : border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2A1C30),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 1: Volcano Sundae
  // -------------------------------------------------------------
  Widget _buildVolcanoSundaeCard() {
    const itemId = 'sundae-1';
    const itemTitle = 'The Molten Biscoff & Churro Volcano Sundae';
    final isLoved = _lovedItemIds.contains(itemId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE5F2), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image with Overlays
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.45,
                child: Image.asset(
                  AssetConstants.churroSundae,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.network(
                    'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=800&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient vignette for overlays
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Top-Left Badge: VIRAL ON TIKTOK • 2.4M Views • 0.3 mi away
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00E676),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'VIRAL ON TIKTOK • 2.4M Views • 0.3 mi away',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top-Right Heart Button
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => _toggleLoved(itemId, itemTitle),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: const Color(0xFFD6228A),
                    ),
                  ),
                ),
              ),

              // Center Play Button
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFF5B2375),
                    size: 32,
                  ),
                ),
              ),

              // Bottom-Left Audio Tag
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Sugar Bloom Original Audio ...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom-Right Instant Feast Tag
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFFD6228A), size: 14),
                      const SizedBox(width: 3),
                      Text(
                        'Instant Feast',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD6228A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugar Bloom Cafe • Soho',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD6228A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  itemTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Creator Row
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFD6EE),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=120&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('👑', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@churroqueen',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1F1528),
                            ),
                          ),
                          Text(
                            'Verified Foodie Creator',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7A6F82),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite, size: 12, color: Color(0xFFD6228A)),
                          const SizedBox(width: 3),
                          Text(
                            '184.2k',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F1528),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.share_rounded, size: 12, color: Color(0xFF7A6F82)),
                          const SizedBox(width: 3),
                          Text(
                            '2.8k',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F1528),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.bookmark_rounded, size: 12, color: Color(0xFF7A6F82)),
                          const SizedBox(width: 3),
                          Text(
                            '412',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F1528),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Buttons: Loved It + Order Platter Pass
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLoved(itemId, itemTitle),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isLoved ? const Color(0xFFD6228A) : const Color(0xFFFDE8F4),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD6228A), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 15,
                              color: isLoved ? Colors.white : const Color(0xFFD6228A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isLoved ? 'Loved' : 'Loved It',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isLoved ? Colors.white : const Color(0xFFD6228A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (widget.onSelectDeal != null) {
                            widget.onSelectDeal!(PlatterDeal.sampleDeals.first);
                          }
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B2375),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(91, 35, 117, 0.3),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Order Platter Pass',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '£34 pass (33% OFF)',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFEADBEE),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
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
  // Section Header: Fresh Social Drops
  // -------------------------------------------------------------
  Widget _buildFreshDropsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF5B2375),
                size: 20,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Fresh Social Drops',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Updated 4m ago',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF7A6F82),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Card 2: Mega 4-Tier Loaded Birria Quesataco Platter
  // -------------------------------------------------------------
  Widget _buildBirriaQuesatacoCard() {
    const itemId = 'birria-2';
    const itemTitle = 'Mega 4–Tier Loaded Birria Quesataco Platter';
    final isLoved = _lovedItemIds.contains(itemId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE5F2), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.asset(
                  AssetConstants.tacoBodega,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.network(
                    'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=800&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Top-Left Instagram Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        'INSTAGRAM REEL • 880k Views • Soho',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Trending Banner on image
              Positioned(
                bottom: 10,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD6228A), Color(0xFFE040A0)],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          'Trending #1 in London this weekend',
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
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cantina Fuego • Old Compton St',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD6228A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  itemTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '£36 for 4 foodies • Includes 4 rich consommé dipping cups, salsa flight & house churros.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B4A62),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLoved(itemId, itemTitle),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isLoved ? const Color(0xFFD6228A) : const Color(0xFFFDE8F4),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD6228A), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 15,
                              color: isLoved ? Colors.white : const Color(0xFFD6228A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isLoved ? 'Loved' : 'Loved It',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isLoved ? Colors.white : const Color(0xFFD6228A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (widget.onSelectDeal != null) {
                            widget.onSelectDeal!(PlatterDeal.sampleDeals.length > 1
                                ? PlatterDeal.sampleDeals[1]
                                : PlatterDeal.fiestaPlatter);
                          }
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B2375),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(91, 35, 117, 0.3),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Claim Table Pass',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
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
  // Card 3: The 1-Meter Giant Cheesy Garlic Breadstick Feast
  // -------------------------------------------------------------
  Widget _buildCheesyBreadstickCard() {
    const itemId = 'breadstick-3';
    const itemTitle = 'The 1–Meter Giant Cheesy Garlic Breadstick Feast';
    final isLoved = _lovedItemIds.contains(itemId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE5F2), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.asset(
                  AssetConstants.bistroBella,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.network(
                    'https://images.unsplash.com/photo-1541745537411-b8046dc6d66c?auto=format&fit=crop&w=800&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Facebook Trending Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'f',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'FACEBOOK TRENDING • Soho Foodies Group • 1.2k comments',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bella Crust Kitchen • Dean St',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD6228A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  itemTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Cheese stretch quote container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF4FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8D4FF)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.format_quote_rounded, size: 16, color: Color(0xFF653993)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '"The cheese stretch on this monster is un..."',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5B2375),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLoved(itemId, itemTitle),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isLoved ? const Color(0xFFD6228A) : const Color(0xFFFDE8F4),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD6228A), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 15,
                              color: isLoved ? Colors.white : const Color(0xFFD6228A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isLoved ? 'Loved' : 'Loved It',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isLoved ? Colors.white : const Color(0xFFD6228A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (widget.onSelectDeal != null) {
                            widget.onSelectDeal!(PlatterDeal.fiestaPlatter);
                          }
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B2375),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(91, 35, 117, 0.3),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Feast 🍴',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
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

  // -------------------------------------------------------------
  // Card 4: Fluffy Japanese Souffle Pancake Cloud Stack
  // -------------------------------------------------------------
  Widget _buildSoufflePancakesCard() {
    const itemId = 'pancake-4';
    const itemTitle = 'Fluffy Japanese Souffle Pancake Cloud Stack';
    final isLoved = _lovedItemIds.contains(itemId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE5F2), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(124, 82, 170, 0.08),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  'https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=800&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFFFF0E6),
                    child: const Center(
                      child: Text('🥞', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
              ),

              // TikTok Secret Menu Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        'TIKTOK SECRET MENU • 650k Views',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Secret Perk Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    'Secret Perk',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5B2375),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cloud Nine Bakery • Greek St',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD6228A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  itemTitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F1528),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '£18 / couple • Includes free matcha glaze drop with your Treat table reservation code.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B4A62),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLoved(itemId, itemTitle),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isLoved ? const Color(0xFFD6228A) : const Color(0xFFFDE8F4),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFD6228A), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 15,
                              color: isLoved ? Colors.white : const Color(0xFFD6228A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isLoved ? 'Loved' : 'Loved It',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isLoved ? Colors.white : const Color(0xFFD6228A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '🎟 Voucher unlocked: Cloud Nine Free Matcha Glaze added!',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                              ),
                              backgroundColor: const Color(0xFF653993),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5B2375),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(91, 35, 117, 0.3),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Voucher 🎟',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
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

  // -------------------------------------------------------------
  // Card 5: Foodie Bounty Card ("Spot a Viral Craving?")
  // -------------------------------------------------------------
  Widget _buildFoodieBountyCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF532470),
            Color(0xFF7E216B),
            Color(0xFFB01D78),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(83, 36, 112, 0.35),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Badge and Sparkles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FOODIE BOUNTY',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFFD6EE),
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD6EE),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            'Spot a Viral Craving?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            'Found an insane TikTok or Instagram feast that isn\'t listed on Treat yet? Paste the video link to earn 200 Treat Coins and get a 20% off platter pass!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF9E8FF),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Input Bar with Embedded Submit Button
          Container(
            padding: const EdgeInsets.fromLTRB(14, 4, 5, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bountyLinkController,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F1528),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Paste TikTok or Instagram reel link...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E8FA5),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _submitBounty,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6228A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Perks row
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFFFFD6EE)),
                    const SizedBox(width: 4),
                    Text(
                      'Instant community review',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFD6EE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.card_giftcard_rounded, size: 13, color: Color(0xFFFFD6EE)),
                    const SizedBox(width: 4),
                    Text(
                      '1,420 dishes added this week',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFD6EE),
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
