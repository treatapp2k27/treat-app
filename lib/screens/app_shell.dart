import 'package:flutter/material.dart';
import '../core/theme/treat_colors.dart';
import '../core/theme/treat_typography.dart';
import '../widgets/diner_drawer.dart';
import '../widgets/treat_bottom_nav_bar.dart';
import 'diner/choose_treat_budget_screen.dart';
import 'diner/community_food_bar_screen.dart';
import 'diner/treat_social_screen.dart';
import 'diner/favorites_screen.dart';
import 'diner/foodie_profile_settings_screen.dart';
import 'diner/gateway_explore_screen.dart';
import 'diner/home_promotions_screen.dart';
import 'diner/location_sharing_screen.dart';
import 'diner/platter_booking_confirmation_screen.dart';
import 'diner/platter_packages_screen.dart';
import 'diner/reservation_confirmed_slip_screen.dart';
import 'diner/scanned_voucher_receipt_screen.dart';
import 'diner/treat_opening_screen.dart';
import 'diner/welcome_anonymous_screen.dart';
import 'kitchen/floor_table_availability_screen.dart';
import 'kitchen/kitchen_dashboard_screen.dart';
import 'kitchen/kitchen_login_portal_screen.dart';
import 'kitchen/kitchen_profile_settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentScreen = 'opening';

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 500;

        Widget content = Scaffold(
          key: _scaffoldKey,
          backgroundColor: TreatColors.background,
          drawer: DinerDrawer(
            activeRoute: _currentScreen,
            onNavigate: (route) {
              Navigator.of(context).pop();
              if (route == 'kitchen_portal') {
                _navigateTo('kitchen_login');
              } else {
                _navigateTo(route);
              }
            },
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.02),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<String>(_currentScreen),
              child: _buildCurrentScreen(),
            ),
          ),
          bottomNavigationBar: _isDinerScreen() ? _buildDinerBottomNav() : null,
        );

        if (isDesktop) {
          final frameHeight = constraints.maxHeight > 920 ? 890.0 : (constraints.maxHeight * 0.96);
          // Centered mock device frame on desktop/browser
          return Container(
            color: const Color(0xFF1E1624),
            child: Center(
              child: Container(
                width: 420,
                height: frameHeight,
                margin: const EdgeInsets.symmetric(vertical: 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(224, 64, 160, 0.25),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    )
                  ],
                  border: Border.all(color: const Color(0xFF3B2A45), width: 8),
                ),
                child: content,
              ),
            ),
          );
        }

        return content;
      },
    );
  }

  bool _isDinerScreen() {
    return [
      'home',
      'explore',
      'food_bar',
      'favorites',
      'social',
      'budget',
      'platters',
      'location',
      'profile',
    ].contains(_currentScreen);
  }

  TreatNavTab _getCurrentNavTab() {
    switch (_currentScreen) {
      case 'home':
      case 'explore':
        return TreatNavTab.explore;
      case 'food_bar':
      case 'budget':
      case 'platters':
        return TreatNavTab.foodBar;
      case 'favorites':
        return TreatNavTab.favorites;
      case 'social':
        return TreatNavTab.social;
      case 'profile':
        return TreatNavTab.profile;
      default:
        return TreatNavTab.explore;
    }
  }

  Widget _buildDinerBottomNav() {
    return TreatBottomNavBar(
      currentTab: _getCurrentNavTab(),
      onTabSelected: (tab) {
        switch (tab) {
          case TreatNavTab.explore:
            _navigateTo('home');
            break;
          case TreatNavTab.foodBar:
            _navigateTo('food_bar');
            break;
          case TreatNavTab.favorites:
            _navigateTo('favorites');
            break;
          case TreatNavTab.social:
            _navigateTo('social');
            break;
          case TreatNavTab.profile:
            _navigateTo('profile');
            break;
        }
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 'opening':
        return TreatOpeningScreen(
          onContinue: () => _navigateTo('welcome'),
        );

      case 'welcome':
      case 'gateway':
        return GatewayExploreScreen(
          onExploreGuest: () => _navigateTo('home'),
          onFoodieSignInTap: () => _navigateTo('welcome_persona'),
        );

      case 'welcome_persona':
      case 'foodie_signin':
        return WelcomeAnonymousScreen(
          onBack: () => _navigateTo('welcome'),
          onEnterGuest: () => _navigateTo('home'),
          onKitchenPortalTap: () => _navigateTo('kitchen_login'),
        );

      case 'home':
      case 'explore':
        return HomePromotionsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onNavigateBudgetPlanner: () => _navigateTo('budget'),
        );

      case 'food_bar':
        return CommunityFoodBarScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onExploreTreats: () => _navigateTo('home'),
          onSelectDeal: (_) => _navigateTo('platters'),
        );

      case 'favorites':
        return FavoritesScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onExploreMore: () => _navigateTo('home'),
        );

      case 'social':
        return TreatSocialScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onExploreTreats: () => _navigateTo('home'),
        );

      case 'budget':
        return ChooseTreatBudgetScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
        );

      case 'platters':
        return PlatterPackagesScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectPlatter: (_) => _navigateTo('booking_hold'),
          onEditBudget: () => _navigateTo('budget'),
        );

      case 'booking_hold':
        return PlatterBookingConfirmationScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onConfirmed: () => _navigateTo('reservation_slip'),
          onBack: () => _navigateTo('platters'),
        );

      case 'reservation_slip':
        return ReservationConfirmedSlipScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onViewReceipt: () => _navigateTo('receipt'),
          onDone: () => _navigateTo('home'),
        );

      case 'receipt':
        return ScannedVoucherReceiptScreen(
          onBack: () => _navigateTo('reservation_slip'),
          onHome: () => _navigateTo('home'),
        );

      case 'location':
        return LocationSharingScreen(
          onEnableLocation: () => _navigateTo('home'),
          onSkip: () => _navigateTo('home'),
        );

      case 'profile':
        return FoodieProfileSettingsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );

      case 'kitchen_login':
        return KitchenLoginPortalScreen(
          onLoginSuccess: () => _navigateTo('kitchen_dashboard'),
          onReturnDiner: () => _navigateTo('welcome'),
        );

      case 'kitchen_dashboard':
        return KitchenDashboardScreen(
          onOpenFloorManager: () => _navigateTo('kitchen_floor'),
          onOpenSettings: () => _navigateTo('kitchen_settings'),
          onLogOut: () => _navigateTo('kitchen_login'),
        );

      case 'kitchen_floor':
        return FloorTableAvailabilityScreen(
          onBack: () => _navigateTo('kitchen_dashboard'),
        );

      case 'kitchen_settings':
        return KitchenProfileSettingsScreen(
          onBack: () => _navigateTo('kitchen_dashboard'),
          onLogOut: () => _navigateTo('kitchen_login'),
        );

      default:
        return HomePromotionsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onNavigateBudgetPlanner: () => _navigateTo('budget'),
        );
    }
  }
}
