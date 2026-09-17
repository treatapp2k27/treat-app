import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/bangladesh_locations.dart';

class BangladeshLocationPickerDialog extends StatefulWidget {
  final String currentLocation;
  final ValueChanged<String> onLocationSelected;

  const BangladeshLocationPickerDialog({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<BangladeshLocationPickerDialog> createState() =>
      _BangladeshLocationPickerDialogState();
}

class _BangladeshLocationPickerDialogState
    extends State<BangladeshLocationPickerDialog> {
  late TextEditingController _customInputController;
  late TextEditingController _districtSearchController;

  String _selectedDivision = 'All';
  String _selectedDistrict = BangladeshLocations.defaultDistrict;
  String _selectedUpazila = BangladeshLocations.defaultUpazila;
  String? _selectedRoad;
  String _districtSearchQuery = '';


  @override
  void initState() {
    super.initState();
    _customInputController = TextEditingController();
    _districtSearchController = TextEditingController();

    // If current location matches a known road or area, pre-select it
    for (final road in BangladeshLocations.feniSadarRoads) {
      if (widget.currentLocation.contains(road)) {
        _selectedRoad = road;
        _selectedDistrict = 'Feni';
        _selectedUpazila = 'Feni Sadar';
        break;
      }
    }
  }

  @override
  void dispose() {
    _customInputController.dispose();
    _districtSearchController.dispose();
    super.dispose();
  }

  List<String> _getFilteredDistricts() {
    List<String> list;
    if (_selectedDivision == 'All') {
      list = BangladeshLocations.allDistricts;
    } else {
      list = BangladeshLocations.districtsByDivision[_selectedDivision] ?? [];
    }

    if (_districtSearchQuery.trim().isEmpty) {
      return list;
    }

    final q = _districtSearchQuery.trim().toLowerCase();
    return list.where((d) => d.toLowerCase().contains(q)).toList();
  }

  List<String> _getUpazilasForSelectedDistrict() {
    return BangladeshLocations.upazilasByDistrict[_selectedDistrict] ??
        ['$_selectedDistrict Sadar', 'Central Zone', 'Outer Zone'];
  }

  String _buildFormattedLocationString() {
    if (_selectedRoad != null && _selectedRoad!.isNotEmpty) {
      return '$_selectedRoad, $_selectedUpazila';
    }
    return '$_selectedUpazila, $_selectedDistrict';
  }

  void _confirmAndApply(String location) {
    widget.onLocationSelected(location);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDistricts = _getFilteredDistricts();
    final upazilas = _getUpazilasForSelectedDistrict();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 750),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFEADBEE),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(101, 57, 147, 0.16),
              blurRadius: 32,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -----------------------------------------------------------
            // Modal Header
            // -----------------------------------------------------------
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFCF7FD),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2E6F5), width: 1.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA6056D), Color(0xFF7C52AA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA6056D).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.map_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: const Color(0xFF201A24),
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Select District, Upazila & Preferred Road',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF706776),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF706776)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // Current Active Selection Bar
            // -----------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: const Color(0xFFF9F1FC),
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    color: Color(0xFFA6056D),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Selected: ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF706776),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _selectedRoad != null
                          ? '$_selectedRoad, $_selectedUpazila, $_selectedDistrict'
                          : '$_selectedUpazila, $_selectedDistrict',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA6056D),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // Main Scrollable Body
            // -----------------------------------------------------------
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Neighborhood Select (Preferable roads in Feni Sadar)
                    Text(
                      'Quick neighborhood select:',
                      style: GoogleFonts.dmSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildSectionHeader(
                      icon: Icons.alt_route_rounded,
                      title: 'Preferable Roads in Feni Sadar',
                      badge: '${BangladeshLocations.feniSadarRoads.length} Hotspots',
                      badgeColor: const Color(0xFFA6056D),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap any preferable road to pinpoint local platters & feasts:',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF706776),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Multi-button preferable road grid
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BangladeshLocations.feniSadarRoads.map((road) {
                        final isSelected = _selectedRoad == road ||
                            widget.currentLocation.contains(road);
                        final subtitle =
                            BangladeshLocations.feniRoadSubtitles[road];

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedRoad = road;
                                _selectedDistrict = 'Feni';
                                _selectedUpazila = 'Feni Sadar';
                              });
                              _confirmAndApply('$road, Feni Sadar');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFA6056D)
                                    : const Color(0xFFFCF7FE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFA6056D)
                                      : const Color(0xFFEADBEE),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFA6056D)
                                              .withOpacity(0.28),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle_rounded
                                        : Icons.location_on_outlined,
                                    size: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFFA6056D),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    road,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w700,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF201A24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFF0E4F4), height: 1),
                    const SizedBox(height: 14),

                    // 2. District Selection (All 64 districts in Bangladesh)
                    _buildSectionHeader(
                      icon: Icons.location_city_rounded,
                      title: 'District in Bangladesh',
                      badge: '$_selectedDistrict Selected',
                      badgeColor: const Color(0xFF653993),
                    ),
                    const SizedBox(height: 8),

                    // Division filter tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          'All',
                          ...BangladeshLocations.districtsByDivision.keys,
                        ].map((div) {
                          final isDivSelected = _selectedDivision == div;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(
                                div == 'All' ? 'All (64)' : div,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDivSelected
                                      ? Colors.white
                                      : const Color(0xFF5A4D64),
                                ),
                              ),
                              selected: isDivSelected,
                              selectedColor: const Color(0xFF653993),
                              backgroundColor: const Color(0xFFF7F2FA),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: isDivSelected
                                      ? const Color(0xFF653993)
                                      : const Color(0xFFE2D6EE),
                                ),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedDivision = div;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // District quick search input
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF6FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2D6EE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              size: 16, color: Color(0xFF94899C)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _districtSearchController,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF201A24),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search district (e.g. Feni, Dhaka)...',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFFA098A5),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _districtSearchQuery = val;
                                });
                              },
                            ),
                          ),
                          if (_districtSearchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _districtSearchController.clear();
                                setState(() {
                                  _districtSearchQuery = '';
                                });
                              },
                              child: const Icon(Icons.close_rounded,
                                  size: 16, color: Color(0xFF94899C)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // District Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: filteredDistricts.map((dist) {
                        final isDistSelected = _selectedDistrict == dist;
                        final isFeni = dist == 'Feni';

                        return ActionChip(
                          avatar: isDistSelected
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : (isFeni
                                  ? const Icon(Icons.star,
                                      size: 14, color: Color(0xFFA6056D))
                                  : null),
                          label: Text(
                            dist,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: isDistSelected || isFeni
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isDistSelected
                                  ? Colors.white
                                  : (isFeni
                                      ? const Color(0xFFA6056D)
                                      : const Color(0xFF201A24)),
                            ),
                          ),
                          backgroundColor: isDistSelected
                              ? const Color(0xFF653993)
                              : (isFeni
                                  ? const Color(0xFFFDE8F4)
                                  : const Color(0xFFF8F2FC)),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isDistSelected
                                  ? const Color(0xFF653993)
                                  : (isFeni
                                      ? const Color(0xFFA6056D)
                                      : const Color(0xFFE2D6EE)),
                              width: isFeni || isDistSelected ? 1.2 : 0.8,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDistrict = dist;
                              final newUpazilas =
                                  BangladeshLocations.upazilasByDistrict[dist];
                              _selectedUpazila = (newUpazilas != null &&
                                      newUpazilas.isNotEmpty)
                                  ? newUpazilas.first
                                  : '$dist Sadar';
                              _selectedRoad = null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 3. Upazila / Zone Selection
                    _buildSectionHeader(
                      icon: Icons.place_rounded,
                      title: 'Upazila / Area under $_selectedDistrict',
                      badge: _selectedUpazila,
                      badgeColor: const Color(0xFFA6056D),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: upazilas.map((upz) {
                        final isUpzSelected = _selectedUpazila == upz;
                        final isFeniSadar =
                            _selectedDistrict == 'Feni' && upz == 'Feni Sadar';

                        return ActionChip(
                          avatar: isUpzSelected
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                          label: Text(
                            upz,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: isUpzSelected || isFeniSadar
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isUpzSelected
                                  ? Colors.white
                                  : (isFeniSadar
                                      ? const Color(0xFFA6056D)
                                      : const Color(0xFF201A24)),
                            ),
                          ),
                          backgroundColor: isUpzSelected
                              ? const Color(0xFFA6056D)
                              : (isFeniSadar
                                  ? const Color(0xFFFDE8F4)
                                  : const Color(0xFFF8F2FC)),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isUpzSelected
                                  ? const Color(0xFFA6056D)
                                  : const Color(0xFFE2D6EE)),
                            ),
                          onPressed: () {
                            setState(() {
                              _selectedUpazila = upz;
                              if (!isFeniSadar) {
                                _selectedRoad = null;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),


                    // 5. Custom Address or Zip Code
                    _buildSectionHeader(
                      icon: Icons.edit_location_alt_rounded,
                      title: 'Or enter a custom city or zip code:',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _customInputController,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF201A24),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Soho Quarter or 10012',
                        hintStyle: GoogleFonts.dmSans(
                          color: const Color(0xFFA098A5),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFBF6FD),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2D6EE)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFFA6056D), width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------
            // Modal Bottom Actions
            // -----------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFFCF7FD),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: Color(0xFFF2E6F5), width: 1.2),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF706776),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6056D),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final customVal = _customInputController.text.trim();
                      if (customVal.isNotEmpty) {
                        _confirmAndApply(customVal);
                      } else {
                        _confirmAndApply(_buildFormattedLocationString());
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'Update Location',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
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

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: badgeColor ?? const Color(0xFFA6056D)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF201A24),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: (badgeColor ?? const Color(0xFFA6056D)).withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: badgeColor ?? const Color(0xFFA6056D),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
