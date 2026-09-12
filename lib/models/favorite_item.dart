import 'platter_deal.dart';

class FavoriteItem {
  final String id;
  final String title;
  final String description;
  final String restaurantName;
  final String price;
  final double rawPrice;
  final String splitPrice;
  final String saveBadge;
  final String distance;
  final String rating;
  final String reviews;
  final String category;
  final String imageUrl;
  final List<String> items;
  final String? topBadge;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.description,
    this.restaurantName = '',
    required this.price,
    this.rawPrice = 0.0,
    this.splitPrice = '',
    this.saveBadge = '',
    this.distance = '0.4 mi • 8 mins walk',
    this.rating = '4.9',
    this.reviews = '420',
    this.category = 'Feast Boards',
    required this.imageUrl,
    this.items = const [],
    this.topBadge,
  });

  factory FavoriteItem.fromPlatterDeal(PlatterDeal deal) {
    return FavoriteItem(
      id: deal.id,
      title: deal.title,
      description: deal.subtitle,
      restaurantName: deal.restaurantName,
      price: '\$${deal.price.toStringAsFixed(2)}',
      rawPrice: deal.price,
      splitPrice: deal.perPersonText ?? '\$${(deal.price / 4).toStringAsFixed(0)}/person',
      saveBadge: deal.saveText ?? 'Save ${deal.discountPercent}% OFF',
      distance: deal.walkTime,
      rating: deal.rating.toString(),
      reviews: deal.reviewsCount.toString(),
      category: 'Feast Boards',
      imageUrl: deal.imageUrl,
      items: deal.inclusions,
      topBadge: deal.badgeText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'restaurantName': restaurantName,
      'price': price,
      'rawPrice': rawPrice,
      'splitPrice': splitPrice,
      'saveBadge': saveBadge,
      'distance': distance,
      'rating': rating,
      'reviews': reviews,
      'category': category,
      'imageUrl': imageUrl,
      'items': items,
      'topBadge': topBadge,
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      restaurantName: (map['restaurantName'] as String?) ?? '',
      price: map['price'] as String,
      rawPrice: (map['rawPrice'] as num?)?.toDouble() ?? 0.0,
      splitPrice: (map['splitPrice'] as String?) ?? '',
      saveBadge: (map['saveBadge'] as String?) ?? '',
      distance: (map['distance'] as String?) ?? '0.4 mi • 8 mins walk',
      rating: (map['rating'] as String?) ?? '4.9',
      reviews: (map['reviews'] as String?) ?? '420',
      category: (map['category'] as String?) ?? 'Feast Boards',
      imageUrl: map['imageUrl'] as String,
      items: (map['items'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      topBadge: map['topBadge'] as String?,
    );
  }

  static final List<FavoriteItem> initialFavorites = [
    const FavoriteItem(
      id: 'deal-sunset-sliders',
      title: 'The Sunset Sliders & Fries Feast',
      description: '12 Crispy Sliders, Loaded Truffle Fries & 4 Milkshakes',
      restaurantName: 'Spice & Sizzle Bistro (#TK-8402)',
      price: '\$32.00',
      rawPrice: 32.0,
      splitPrice: '\$8/person',
      saveBadge: 'Save 45% OFF',
      distance: '0.4 mi • 8 mins walk',
      rating: '4.9',
      reviews: '840',
      category: 'Feast Boards',
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
      items: ['🍔 12 Crispy Sliders', '🍟 Loaded Truffle Fries', '🥤 4 Milkshakes'],
      topBadge: 'Lowest Price Guarantee • \$32 Total (\$8/person)',
    ),
    const FavoriteItem(
      id: 'fav_1',
      title: 'Sugar Bloom Cafe & Brunch',
      description: 'Sweet & savory sharing board with drinks',
      restaurantName: 'Sugar Bloom Cafe & Brunch',
      price: '\$105.00',
      rawPrice: 105.0,
      splitPrice: '\$35/person',
      saveBadge: 'Save \$28 • Pass',
      distance: '0.4 mi • 8 mins walk',
      rating: '4.9',
      reviews: '420',
      category: 'Feast Boards',
      imageUrl: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?auto=format&fit=crop&w=800&q=80',
      items: ['Artisan Waffles', 'Avocado Toast', 'Berry Bowl', 'Iced Matcha'],
    ),
    const FavoriteItem(
      id: 'fav_2',
      title: 'Sprinkle & Sizzle Social',
      description: 'Loaded signature waffles & group smash slider tray',
      restaurantName: 'Sprinkle & Sizzle Social',
      price: '\$96.00',
      rawPrice: 96.0,
      splitPrice: '\$32/person',
      saveBadge: 'Save \$20 • Pass',
      distance: '0.6 mi • 12 mins walk',
      rating: '4.9',
      reviews: '128',
      category: 'Sweet Lounges',
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
      items: ['Belgian Waffles', 'Caramel Drizzle', 'Vanilla Bean Gelato'],
    ),
  ];
}
