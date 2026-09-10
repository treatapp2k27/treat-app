enum TerminalStation {
  mainKds,
  hostStand,
  barTerminal,
  floorLeadTablet,
}

class KitchenPartner {
  final String merchantCode;
  final String venueName;
  final String address;
  final bool isLive;
  final bool isAcceptingBookings;
  final TerminalStation activeStation;
  final bool rushMode;
  final bool autoAcceptBundles;
  final int graceWindowMins;
  final int reservationsToday;
  final int pendingActionCount;
  final double treatSalesToday;

  const KitchenPartner({
    this.merchantCode = 'TK-8402',
    this.venueName = 'Spice & Sizzle Bistro',
    this.address = '442 King St West, Level 2',
    this.isLive = true,
    this.isAcceptingBookings = true,
    this.activeStation = TerminalStation.mainKds,
    this.rushMode = false,
    this.autoAcceptBundles = true,
    this.graceWindowMins = 15,
    this.reservationsToday = 18,
    this.pendingActionCount = 4,
    this.treatSalesToday = 680.0,
  });

  KitchenPartner copyWith({
    String? merchantCode,
    String? venueName,
    String? address,
    bool? isLive,
    bool? isAcceptingBookings,
    TerminalStation? activeStation,
    bool? rushMode,
    bool? autoAcceptBundles,
    int? graceWindowMins,
    int? reservationsToday,
    int? pendingActionCount,
    double? treatSalesToday,
  }) {
    return KitchenPartner(
      merchantCode: merchantCode ?? this.merchantCode,
      venueName: venueName ?? this.venueName,
      address: address ?? this.address,
      isLive: isLive ?? this.isLive,
      isAcceptingBookings: isAcceptingBookings ?? this.isAcceptingBookings,
      activeStation: activeStation ?? this.activeStation,
      rushMode: rushMode ?? this.rushMode,
      autoAcceptBundles: autoAcceptBundles ?? this.autoAcceptBundles,
      graceWindowMins: graceWindowMins ?? this.graceWindowMins,
      reservationsToday: reservationsToday ?? this.reservationsToday,
      pendingActionCount: pendingActionCount ?? this.pendingActionCount,
      treatSalesToday: treatSalesToday ?? this.treatSalesToday,
    );
  }
}
