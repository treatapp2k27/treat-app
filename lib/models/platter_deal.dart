class PlatterDeal {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantCode;
  final String title;
  final String subtitle;
  final double price;
  final double originalPrice;
  final int servesCountMin;
  final int servesCountMax;
  final List<String> inclusions;
  final String badgeText;
  final String imageUrl;
  final bool isHighDemand;

  const PlatterDeal({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantCode,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.servesCountMin,
    required this.servesCountMax,
    required this.inclusions,
    required this.badgeText,
    required this.imageUrl,
    this.isHighDemand = false,
  });

  double get savings => originalPrice - price;
  int get discountPercent => (((originalPrice - price) / originalPrice) * 100).round();
  double perPersonCost(int partySize) => price / (partySize > 0 ? partySize : 1);

  static const PlatterDeal fiestaPlatter = PlatterDeal(
    id: 'platter-1',
    restaurantId: 'res-1',
    restaurantName: 'Spice & Sizzle Bistro',
    restaurantCode: 'TK-8402',
    title: 'The Fiesta Treat Platter',
    subtitle: '12 Crispy Sliders, Basket Truffle Fries, 4 Milkshakes & Sauces',
    price: 45.0,
    originalPrice: 65.0,
    servesCountMin: 3,
    servesCountMax: 4,
    inclusions: [
      '12 Crispy Sliders',
      'Truffle Fries',
      '4 Milkshakes',
      'Dipping Sauces'
    ],
    badgeText: 'Best Match for \$120 Budget (Saves \$75 on Squad)',
    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80',
    isHighDemand: true,
  );

  static const PlatterDeal megaFeastPlatter = PlatterDeal(
    id: 'platter-2',
    restaurantId: 'res-1',
    restaurantName: 'Spice & Sizzle Bistro',
    restaurantCode: 'TK-8402',
    title: 'Mega Feast Platter Tier B',
    subtitle: 'Smoky BBQ Wings x8, Loaded Nachos Bowl, 3x Craft Sodas',
    price: 38.0,
    originalPrice: 54.0,
    servesCountMin: 2,
    servesCountMax: 3,
    inclusions: [
      '8 Smoky BBQ Wings',
      'Loaded Nachos Bowl',
      '3x Craft Sodas',
      'Garlic Toast Triangles'
    ],
    badgeText: 'High In-Demand Tonight',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
    isHighDemand: false,
  );

  static const List<PlatterDeal> sampleDeals = [
    fiestaPlatter,
    megaFeastPlatter,
    PlatterDeal(
      id: 'platter-3',
      restaurantId: 'res-2',
      restaurantName: 'Sprinkle & Sizzle Social',
      restaurantCode: 'TK-3012',
      title: 'Neon Glaze Fiesta Platter',
      subtitle: 'Signature mega dessert & group taco tray combo',
      price: 52.0,
      originalPrice: 85.0,
      servesCountMin: 3,
      servesCountMax: 5,
      inclusions: [
        'Rainbow Pancake Tower',
        '6x Sweet Glazed Tacos',
        'Sparkler Slushies Pitcher'
      ],
      badgeText: '2-FOR-1 DEAL',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
      isHighDemand: true,
    ),
  ];
}
