class Restaurant {
  final String id;
  final String code; // e.g. TK-8402
  final String name;
  final String address;
  final String category;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final double distanceMiles;
  final String walkingTime;
  final bool isVerified;
  final bool hasInstantTable;
  final String phone;

  const Restaurant({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.distanceMiles,
    required this.walkingTime,
    this.isVerified = true,
    this.hasInstantTable = true,
    this.phone = '+1 555-234-5678',
  });

  static const Restaurant sampleSpiceAndSizzle = Restaurant(
    id: 'res-1',
    code: 'TK-8402',
    name: 'Spice & Sizzle Bistro',
    address: '442 King St West, Level 2',
    category: 'Casual Dining',
    rating: 4.9,
    reviewCount: 420,
    imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80',
    distanceMiles: 0.4,
    walkingTime: '8 mins walk',
  );

  static const List<Restaurant> sampleRestaurants = [
    sampleSpiceAndSizzle,
    Restaurant(
      id: 'res-2',
      code: 'TK-3012',
      name: 'Sprinkle & Sizzle Social',
      address: 'Soho Quarter, Level 1',
      category: 'Dessert Craze',
      rating: 4.9,
      reviewCount: 1200,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      distanceMiles: 0.4,
      walkingTime: '6 mins walk',
    ),
    Restaurant(
      id: 'res-3',
      code: 'TK-9021',
      name: 'Ramen Lab Neon Alley',
      address: '77 Neon Alley, Downtown',
      category: 'Fast Treat',
      rating: 4.8,
      reviewCount: 340,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80',
      distanceMiles: 0.8,
      walkingTime: '14 mins walk',
    ),
    Restaurant(
      id: 'res-4',
      code: 'TK-5520',
      name: 'Acai Glow Promenade',
      address: '12 Uptown Promenade',
      category: 'Street Bites',
      rating: 4.7,
      reviewCount: 88,
      imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=600&q=80',
      distanceMiles: 1.1,
      walkingTime: '20 mins walk',
    ),
  ];
}
