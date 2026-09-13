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

  final String walkTime;
  final double rating;
  final int reviewsCount;
  final String? saveText;
  final String? perPersonText;

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
    this.walkTime = '0.4 mi • 8 mins walk',
    this.rating = 4.9,
    this.reviewsCount = 420,
    this.saveText,
    this.perPersonText,
  });

  double get savings => originalPrice - price;
  int get discountPercent => (((originalPrice - price) / originalPrice) * 100).round();
  double perPersonCost(int partySize) => price / (partySize > 0 ? partySize : 1);

  static const PlatterDeal sugarBloomPlatter = PlatterDeal(
    id: 'platter-sugar-bloom',
    restaurantId: 'res-sugar-bloom',
    restaurantName: 'Sugar Bloom Cafe & Brunch',
    restaurantCode: 'SB-105',
    title: 'Sugar Bloom Cafe & Brunch',
    subtitle: 'Sweet & savory sharing board with drinks',
    price: 105.0,
    originalPrice: 133.0,
    servesCountMin: 3,
    servesCountMax: 4,
    inclusions: [
      'Artisan Waffles & Berries',
      'Avocado & Egg Brioche',
      'Matcha & Iced Lattes',
      'Seasonal Fruit Platter'
    ],
    badgeText: 'Top Brunch Pick',
    imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
    isHighDemand: true,
    walkTime: '0.4 mi • 8 mins walk',
    rating: 4.9,
    reviewsCount: 420,
    saveText: 'Save \$28 • Pass',
    perPersonText: '\$35/person',
  );

  static const PlatterDeal sugarBloomFeastPlatter = PlatterDeal(
    id: 'platter-sugar-bloom-2',
    restaurantId: 'res-sugar-bloom',
    restaurantName: 'Sugar Bloom Cafe & Brunch',
    restaurantCode: 'SB-106',
    title: 'Sugar Bloom Cafe & Brunch',
    subtitle: 'Sweet & savory sharing board with drinks',
    price: 105.0,
    originalPrice: 133.0,
    servesCountMin: 3,
    servesCountMax: 4,
    inclusions: [
      'Gourmet Pastry Tower',
      'Smoked Salmon Croissants',
      'Cold Brew Trio',
      'Mini Acai Bowls'
    ],
    badgeText: 'Trending Choice',
    imageUrl: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?auto=format&fit=crop&w=800&q=80',
    isHighDemand: false,
    walkTime: '0.4 mi • 8 mins walk',
    rating: 4.9,
    reviewsCount: 420,
    saveText: 'Save \$28 • Pass',
    perPersonText: '\$35/person',
  );

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
    walkTime: '0.8 mi • 15 mins walk',
    rating: 4.8,
    reviewsCount: 310,
    saveText: 'Save \$20 • Pass',
    perPersonText: '\$15/person',
  );

  static const PlatterDeal megaFeastPlatter = PlatterDeal(
    id: 'platter-2',
    restaurantId: 'res-1',
    restaurantName: 'Spice & Sizzle Bistro',
    restaurantCode: 'TK-8402',
    title: 'Mega Feast Platter Tier B',
    subtitle: 'Smoky BBQ Wings x8, Loaded Nachos Bowl, 3x Craft Sodas',
    price: 138.0,
    originalPrice: 164.0,
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
    walkTime: '1.1 mi • 22 mins walk',
    rating: 4.7,
    reviewsCount: 198,
    saveText: 'Save \$26 • Pass',
    perPersonText: '\$46/person',
  );

  static const PlatterDeal sunsetSlidersPlatter = PlatterDeal(
    id: 'deal-sunset-sliders',
    restaurantId: 'res-spice-sizzle',
    restaurantName: 'Spice & Sizzle Bistro (#TK-8402)',
    restaurantCode: 'TK-8402',
    title: 'The Sunset Sliders & Fries Feast',
    subtitle: '12 Crispy Sliders, Loaded Truffle Fries, 4 Milkshakes',
    price: 32.0,
    originalPrice: 58.0,
    servesCountMin: 4,
    servesCountMax: 4,
    inclusions: [
      '🍔 12 Crispy Sliders',
      '🍟 Loaded Truffle Fries',
      '🥤 4 Milkshakes',
    ],
    badgeText: 'Lowest Price Guarantee - \$32 Total',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
    isHighDemand: true,
    walkTime: '0.4 mi • 8 mins walk',
    rating: 4.9,
    reviewsCount: 840,
    saveText: 'Save 45% OFF',
    perPersonText: '(\$8/portion)',
  );

  static const PlatterDeal oceanCalamariPlatter = PlatterDeal(
    id: 'deal-ocean-calamari',
    restaurantId: 'res-ocean-catch',
    restaurantName: 'Ocean Catch Lounge',
    restaurantCode: 'OC-3601',
    title: 'Crispy Ocean Calamari & Prawn Feast',
    subtitle: 'Crispy Prawns, Golden Calamari, Sweet Chili Glaze, Wedges',
    price: 36.0,
    originalPrice: 60.0,
    servesCountMin: 4,
    servesCountMax: 4,
    inclusions: [
      '🍤 Crispy Prawns',
      '🐙 Golden Calamari',
      '🌶 Sweet Chili Glaze',
      '🥔 Wedges',
    ],
    badgeText: "Chef's Top Rated - \$36 Total",
    imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?auto=format&fit=crop&w=800&q=80',
    isHighDemand: true,
    walkTime: '0.5 mi • 10 mins walk',
    rating: 4.95,
    reviewsCount: 1200,
    saveText: 'Save 40% OFF',
    perPersonText: '(\$9/portion)',
  );

  static const PlatterDeal fiestaNachosPlatter = PlatterDeal(
    id: 'deal-fiesta-nachos',
    restaurantId: 'res-la-cantina',
    restaurantName: 'La Cantina Bites',
    restaurantCode: 'LC-2805',
    title: 'Fiesta Loaded Nachos & BBQ Wings',
    subtitle: 'Smoky BBQ Wings x10, Loaded Nachos Grande, Churros x4',
    price: 28.0,
    originalPrice: 48.0,
    servesCountMin: 4,
    servesCountMax: 5,
    inclusions: [
      '🍗 Smoky BBQ Wings x10',
      '🧀 Loaded Nachos Grande',
      '🥖 Churros x4',
    ],
    badgeText: 'Budget Steal - \$28 Total',
    imageUrl: 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=800&q=80',
    isHighDemand: false,
    walkTime: '0.7 mi • 14 mins walk',
    rating: 4.88,
    reviewsCount: 120,
    saveText: 'Save 42% OFF',
    perPersonText: '(\$7/portion)',
  );

  static const List<PlatterDeal> wireframePlatters = [
    sunsetSlidersPlatter,
    oceanCalamariPlatter,
    fiestaNachosPlatter,
  ];

  static const List<PlatterDeal> sampleDeals = [
    sugarBloomPlatter,
    sugarBloomFeastPlatter,
    fiestaPlatter,
    megaFeastPlatter,
  ];
}
