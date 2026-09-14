class DinerPersona {
  final String id;
  final String handle;
  final String avatarEmoji;
  final String avatarUrl;
  final bool isVip;
  final int vipLevel;
  final int treatsClaimed;
  final double totalSaved;
  final List<String> dietTags;
  final int preferredSquadSize;
  final double budgetTarget;
  final double walletBalance;
  final String email;
  final String contactNumber;
  final bool autoSplitBill;
  final bool hideRealName;
  final bool allowSquadInvite;
  final bool ghostBrowsing;
  final bool instantDropAlerts;
  final bool tableHoldReminders;
  final bool dealRadarAlerts;

  const DinerPersona({
    required this.id,
    required this.handle,
    required this.avatarEmoji,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
    this.isVip = true,
    this.vipLevel = 2,
    this.treatsClaimed = 34,
    this.totalSaved = 185.0,
    this.dietTags = const [
      'Spicy Lover',
      'Halal',
      'Vegetarian',
      'Nut-Free',
      'Late Night Spots',
      'Platter Craver'
    ],
    this.preferredSquadSize = 3,
    this.budgetTarget = 120.0,
    this.walletBalance = 45.00,
    this.email = 'foodie@treat.circle',
    this.contactNumber = '+1 (555) 382-9012',
    this.autoSplitBill = true,
    this.hideRealName = true,
    this.allowSquadInvite = true,
    this.ghostBrowsing = false,
    this.instantDropAlerts = true,
    this.tableHoldReminders = true,
    this.dealRadarAlerts = true,
  });

  DinerPersona copyWith({
    String? id,
    String? handle,
    String? avatarEmoji,
    String? avatarUrl,
    bool? isVip,
    int? vipLevel,
    int? treatsClaimed,
    double? totalSaved,
    List<String>? dietTags,
    int? preferredSquadSize,
    double? budgetTarget,
    double? walletBalance,
    String? email,
    String? contactNumber,
    bool? autoSplitBill,
    bool? hideRealName,
    bool? allowSquadInvite,
    bool? ghostBrowsing,
    bool? instantDropAlerts,
    bool? tableHoldReminders,
    bool? dealRadarAlerts,
  }) {
    return DinerPersona(
      id: id ?? this.id,
      handle: handle ?? this.handle,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVip: isVip ?? this.isVip,
      vipLevel: vipLevel ?? this.vipLevel,
      treatsClaimed: treatsClaimed ?? this.treatsClaimed,
      totalSaved: totalSaved ?? this.totalSaved,
      dietTags: dietTags ?? this.dietTags,
      preferredSquadSize: preferredSquadSize ?? this.preferredSquadSize,
      budgetTarget: budgetTarget ?? this.budgetTarget,
      walletBalance: walletBalance ?? this.walletBalance,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      autoSplitBill: autoSplitBill ?? this.autoSplitBill,
      hideRealName: hideRealName ?? this.hideRealName,
      allowSquadInvite: allowSquadInvite ?? this.allowSquadInvite,
      ghostBrowsing: ghostBrowsing ?? this.ghostBrowsing,
      instantDropAlerts: instantDropAlerts ?? this.instantDropAlerts,
      tableHoldReminders: tableHoldReminders ?? this.tableHoldReminders,
      dealRadarAlerts: dealRadarAlerts ?? this.dealRadarAlerts,
    );
  }

  static const List<Map<String, String>> presetPersonas = [
    {'handle': 'MidnightDumpling', 'emoji': '🥟'},
    {'handle': 'TacoFiend', 'emoji': '🌮'},
    {'handle': 'BobaBandit', 'emoji': '🧋'},
    {'handle': 'SweetTooth', 'emoji': '🍩'},
    {'handle': 'SpicyNoodleGod', 'emoji': '🍜'},
    {'handle': 'CrispyCroissant', 'emoji': '🥐'},
    {'handle': 'CurryCaptain', 'emoji': '🍛'},
    {'handle': 'PizzaPrince', 'emoji': '🍕'},
  ];
}
