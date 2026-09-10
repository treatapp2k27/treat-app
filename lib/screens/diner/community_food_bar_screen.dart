import 'package:flutter/material.dart';
import '../../core/theme/treat_colors.dart';
import '../../core/theme/treat_typography.dart';
import '../../widgets/treat_card.dart';
import '../../widgets/treat_header.dart';

import '../../models/platter_deal.dart';

class CommunityFoodBarScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback onExploreTreats;
  final Function(PlatterDeal deal)? onSelectDeal;

  const CommunityFoodBarScreen({
    super.key,
    required this.onOpenDrawer,
    required this.onExploreTreats,
    this.onSelectDeal,
  });

  @override
  State<CommunityFoodBarScreen> createState() => _CommunityFoodBarScreenState();
}

class _CommunityFoodBarScreenState extends State<CommunityFoodBarScreen> {
  int _activeTab = 0; // 0: Platters, 1: Combos, 2: Desserts
  bool _joinedPot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TreatColors.background,
      appBar: TreatHeader(
        onMenuTap: widget.onOpenDrawer,
        actionLabel: 'Treat',
        actionIcon: Icons.celebration,
        onActionTap: widget.onExploreTreats,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 36),
        children: [
          // Filter Tabs
          Row(
            children: [
              _buildTabButton('Feast Platters', Icons.lunch_dining_outlined, 0),
              const SizedBox(width: 8),
              _buildTabButton('Group Combos', Icons.groups_rounded, 1, hasBadge: true),
              const SizedBox(width: 8),
              _buildTabButton('Dessert Towers', Icons.cake_outlined, 2),
            ],
          ),
          const SizedBox(height: 16),

          // Hotlist Rush Hour Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: TreatColors.potBannerGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: TreatColors.pillShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LIVE HOTLIST PULSE',
                              style: TreatTypography.labelSmall.copyWith(
                                color: TreatColors.primaryFixed,
                                letterSpacing: 1.2,
                                fontSize: 9,
                              ),
                            ),
                            Text(
                              'Food Bar Rush Hour',
                              style: TreatTypography.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.whatshot, size: 14, color: TreatColors.secondary),
                          const SizedBox(width: 4),
                          Text(
                            '842 Claims',
                            style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Group BOGO Progress Meter
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: TreatColors.secondaryFixed,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _joinedPot ? '94%' : '92%',
                          style: TreatTypography.labelSmall.copyWith(
                            color: TreatColors.onSecondaryFixed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group BOGO Unlocking',
                              style: TreatTypography.labelMedium.copyWith(color: Colors.white),
                            ),
                            Text(
                              _joinedPot ? 'You joined! 6 sweets left for Free Donut Drops' : 'Only 8 sweets away from Free Donut Drops!',
                              style: TreatTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() => _joinedPot = !_joinedPot);
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _joinedPot ? Colors.white : TreatColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _joinedPot ? 'Joined ✓' : 'Join Pot',
                            style: TreatTypography.labelSmall.copyWith(
                              color: _joinedPot ? TreatColors.secondary : TreatColors.onTertiaryFixed,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Trending Budget Feasts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 20, color: TreatColors.primary),
                  const SizedBox(width: 6),
                  Text('Trending Budget Feasts', style: TreatTypography.titleMedium),
                ],
              ),
              InkWell(
                onTap: widget.onExploreTreats,
                child: Row(
                  children: [
                    Text('View map', style: TreatTypography.labelSmall.copyWith(color: TreatColors.tertiary)),
                    const Icon(Icons.chevron_right, size: 16, color: TreatColors.tertiary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Feast Cards
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFeastCard(
                  rank: '#1 Spot Bistro Bella',
                  priceBadge: '\$9.50 Feast',
                  title: 'Artisan Truffle Slice & Shake',
                  discountText: '50% OFF',
                  location: 'Downtown Arts • 14 groups chilling',
                  imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
                ),
                const SizedBox(width: 12),
                _buildFeastCard(
                  rank: '#2 Spot Ramen Lab',
                  priceBadge: '\$11.90 Combo',
                  title: 'Spicy Miso & Gyoza Duo',
                  discountText: 'Deal',
                  location: 'Neon Alley • 340 claims today',
                  imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80',
                ),
                const SizedBox(width: 12),
                _buildFeastCard(
                  rank: '#3 Spot Acai Glow',
                  priceBadge: '\$7.00 Snack',
                  title: 'Glazed Acai Super Bowl',
                  discountText: 'Quick',
                  location: 'Uptown Promenade • 80+ joined',
                  imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=600&q=80',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: Foodie Savings Feed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.diversity_3, size: 20, color: TreatColors.secondary),
                  const SizedBox(width: 6),
                  Text('Foodie Savings Feed', style: TreatTypography.titleMedium),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TreatColors.secondaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Real-time Splits',
                  style: TreatTypography.labelSmall.copyWith(
                    color: TreatColors.onSecondaryFixedVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Feed Post 1
          _buildFeedItem(
            emoji: '🍬',
            author: 'Anonymous Foodie',
            district: 'Midtown',
            timeAgo: '14 mins ago • Split via Food Bar Tab',
            savedAmount: 'Saved \$32',
            text: 'Just scored the 4-person slider platter at Spice & Sizzle. Divided 3 ways and ended up costing less than fast food!',
            likesCount: 28,
            commentsCount: 7,
          ),
          const SizedBox(height: 12),

          // Feed Post 2
          _buildFeedItem(
            emoji: '🌮',
            author: 'TacoFiend',
            district: 'Soho',
            timeAgo: '42 mins ago • Secret Voucher',
            savedAmount: 'Saved \$20',
            text: 'Used code TREAT50 at Sprinkle & Sizzle! Pancakes were gigantic and the sparklers on the milkshakes were top tier.',
            likesCount: 54,
            commentsCount: 12,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon, int index, {bool hasBadge = false}) {
    final isActive = _activeTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = index),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? TreatColors.secondary : TreatColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive ? TreatColors.pillShadow : const [
              BoxShadow(
                color: Color.fromRGBO(124, 82, 170, 0.06),
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isActive ? Colors.white : TreatColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TreatTypography.labelSmall.copyWith(
                    color: isActive ? Colors.white : TreatColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasBadge) ...[
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: TreatColors.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeastCard({
    required String rank,
    required String priceBadge,
    required String title,
    required String discountText,
    required String location,
    required String imageUrl,
  }) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: TreatColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: TreatColors.candyShadow,
        border: Border.all(color: TreatColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 110, color: TreatColors.primaryFixed),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TreatColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    rank,
                    style: TreatTypography.labelSmall.copyWith(color: Colors.white, fontSize: 9),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    priceBadge,
                    style: TreatTypography.labelSmall.copyWith(color: TreatColors.secondary, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TreatTypography.titleSmall.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      discountText,
                      style: TreatTypography.labelSmall.copyWith(color: TreatColors.primary, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TreatTypography.bodySmall.copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem({
    required String emoji,
    required String author,
    required String district,
    required String timeAgo,
    required String savedAmount,
    required String text,
    required int likesCount,
    required int commentsCount,
  }) {
    return TreatCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: TreatColors.heroCardGradient,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(author, style: TreatTypography.titleSmall),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: TreatColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(district, style: TreatTypography.labelSmall.copyWith(fontSize: 9)),
                          ),
                        ],
                      ),
                      Text(timeAgo, style: TreatTypography.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TreatColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, size: 12, color: TreatColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      savedAmount,
                      style: TreatTypography.labelSmall.copyWith(color: TreatColors.onPrimaryFixedVariant, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: TreatTypography.bodyMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, size: 16, color: TreatColors.primary),
                  const SizedBox(width: 4),
                  Text('$likesCount', style: TreatTypography.bodySmall),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 16, color: TreatColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('$commentsCount replies', style: TreatTypography.bodySmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
