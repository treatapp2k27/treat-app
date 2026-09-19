import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/treat_colors.dart';
import '../state/diner_state.dart';
import '../widgets/diner_drawer.dart';
import '../widgets/treat_bottom_nav_bar.dart';
import '../widgets/guest_auth_overlay.dart';
import 'diner/choose_treat_budget_screen.dart';
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
import 'diner/login_page.dart';
import 'diner/notifications_screen.dart';
import 'diner/treat_ludo_game_screen.dart';
import 'diner/treat_ludo_leaderboard_screen.dart';
import 'diner/viral_trending_screen.dart';
import 'diner/top_reviewed_feasts_screen.dart';
import '../models/ludo_match_result.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentScreen = 'opening';
  List<LudoPlayerStanding>? _lastLudoStandings;
  LudoMatchResult? _lastLudoMatchResult;
  bool _showGuestActionModal = false;
  String _guestActionModalType = 'feed';

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
      _showGuestActionModal = false;
    });
  }

  void _dismissGuestModal() {
    if (_showGuestActionModal) {
      setState(() {
        _showGuestActionModal = false;
      });
    }
  }

  void _showGuestModalFor(String type) {
    setState(() {
      _showGuestActionModal = true;
      _guestActionModalType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isFoodieLoggedIn = context.watch<DinerState>().isFoodieLoggedIn;
        final isDiner = _isDinerScreen();
        final isScreenRestricted = !isFoodieLoggedIn &&
            (_currentScreen == 'social' ||
                _currentScreen == 'groups' ||
                _currentScreen == 'profile');
        final showGuestAuthOverlay =
            isScreenRestricted || (!isFoodieLoggedIn && _showGuestActionModal);
        final effectivePanelType = isScreenRestricted
            ? (_currentScreen == 'profile' ? 'profile' : 'feed')
            : _guestActionModalType;

        // Responsive Panel Design:
        // Full width on mobile (<960), centered with generous 960px panel on desktop/tablet
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: TreatColors.background,
          drawer: isFoodieLoggedIn
              ? DinerDrawer(
                  activeRoute: _currentScreen,
                  onNavigate: (route) {
                    Navigator.of(context).pop();
                    _navigateTo(route);
                  },
                  onPlayLudo: () {
                    Navigator.of(context).pop();
                    _navigateTo('ludo_game');
                  },
                  onLogOut: () {
                    context.read<DinerState>().setFoodieLoggedIn(false);
                    Navigator.of(context).pop();
                    _navigateTo('welcome');
                  },
                )
              : null,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildCurrentScreenWithSwitcher(),
                  if (showGuestAuthOverlay)
                    Positioned.fill(
                      child: GuestAuthOverlay(
                        panelType: effectivePanelType,
                        onSignIn: () => _navigateTo('welcome_persona'),
                        onBackToExplore: () {
                          if (isScreenRestricted) {
                            _navigateTo('home');
                          } else {
                            _dismissGuestModal();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isDiner ? _buildDinerBottomNav() : null,
        );
      },
    );
  }

  Widget _buildCurrentScreenWithSwitcher() {
    return AnimatedSwitcher(
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
    );
  }

  bool _isDinerScreen() {
    return [
      'home',
      'explore',
      'trending',
      'food_bar',
      'favorites',
      'social',
      'groups',
      'budget',
      'platters',
      'profile',
      'notifications',
    ].contains(_currentScreen);
  }

  TreatNavTab _getCurrentNavTab() {
    switch (_currentScreen) {
      case 'home':
      case 'explore':
      case 'trending':
        return TreatNavTab.explore;
      case 'food_bar':
      case 'budget':
      case 'platters':
        return TreatNavTab.foodBar;
      case 'favorites':
        return TreatNavTab.favorites;
      case 'social':
      case 'groups':
        return TreatNavTab.social;
      case 'profile':
        return TreatNavTab.profile;
      default:
        return TreatNavTab.explore;
    }
  }

  Widget _buildDinerBottomNav() {
    final dinerState = context.watch<DinerState>();
    return Center(
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: TreatBottomNavBar(
          currentTab: _getCurrentNavTab(),
          isGuest: !dinerState.isFoodieLoggedIn,
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
        ),
      ),
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
          onExploreGuest: () {
            context.read<DinerState>().setFoodieLoggedIn(false);
            _navigateTo('home');
          },
          onFoodieSignInTap: () => _navigateTo('welcome_persona'),
        );

      case 'welcome_persona':
      case 'foodie_signin':
        return LoginPage(
          onBack: () => _navigateTo('welcome'),
          onEnterGuest: () => _navigateTo('location'),
        );

      case 'home':
      case 'explore':
        return HomePromotionsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onBackToLogin: () => _navigateTo('welcome'),
          onNavigateLogin: () => _navigateTo('welcome_persona'),
          onLovedItGuest: () => _showGuestModalFor('favorites'),
          onSelectDeal: (_) {
            final isFoodie = context.read<DinerState>().isFoodieLoggedIn;
            if (!isFoodie) {
              _showGuestModalFor('view_details');
            } else {
              _navigateTo('platters');
            }
          },
          onNavigateBudgetPlanner: () => _navigateTo('budget'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          onNavigateFavorites: () => _navigateTo('favorites'),
        );

      case 'trending':
        return ViralTrendingScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          onNavigateProfile: () => _navigateTo('profile'),
          onExploreMore: () => _navigateTo('home'),
        );

      case 'reviews':
        return TopReviewedFeastsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
        );

      case 'food_bar':
        final isFoodie = context.watch<DinerState>().isFoodieLoggedIn;
        return ChooseTreatBudgetScreen(
          onOpenDrawer: () {
            if (isFoodie) {
              _scaffoldKey.currentState?.openDrawer();
            } else {
              _navigateTo('welcome');
            }
          },
          onSelectDeal: (_) {
            if (!isFoodie) {
              _showGuestModalFor('select_platter');
            } else {
              _navigateTo('platters');
            }
          },
          onLovedIt: () => _showGuestModalFor('favorites'),
          onFindWithinBudget: () => _navigateTo('platters'),
          onBackToFoodBar: () => _navigateTo(isFoodie ? 'home' : 'welcome'),
          onBack: () => _navigateTo(isFoodie ? 'home' : 'welcome'),
        );

      case 'favorites':
        return FavoritesScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onExploreMore: () => _navigateTo('home'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
        );

      case 'groups':
        return TreatSocialScreen(
          key: const ValueKey('groups_screen'),
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onExploreTreats: () => _navigateTo('home'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          initialTab: 2,
          showSwitcher: false,
        );

      case 'social':
        return TreatSocialScreen(
          key: const ValueKey('social_screen'),
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onExploreTreats: () => _navigateTo('home'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          initialTab: 0,
          showSwitcher: true,
        );

      case 'budget':
        return ChooseTreatBudgetScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onFindWithinBudget: () => _navigateTo('platters'),
          onBackToFoodBar: () => _navigateTo('food_bar'),
        );

      case 'platters':
        final isFoodie = context.watch<DinerState>().isFoodieLoggedIn;
        return PlatterPackagesScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onBackToLogin: () => _navigateTo(isFoodie ? 'welcome' : 'food_bar'),
          onSelectPlatter: (_) {
            if (!isFoodie) {
              _showGuestModalFor('select_platter');
            } else {
              _navigateTo('booking_hold');
            }
          },
          onEditBudget: () => _navigateTo('food_bar'),
          onNavigateNotifications: () => _navigateTo('notifications'),
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
          onEnableLocation: () {
            final state = context.read<DinerState>();
            state.setFoodieLoggedIn(true);
            state.setUserLocation('Soho Quarter');
            _navigateTo('home');
          },
          onSkip: () {
            final state = context.read<DinerState>();
            state.setFoodieLoggedIn(true);
            _navigateTo('home');
          },
          onLocationSelected: (location) {
            final state = context.read<DinerState>();
            state.setFoodieLoggedIn(true);
            if (location.trim().isNotEmpty) {
              state.setUserLocation(location.trim());
            }
            _navigateTo('home');
          },
        );

      case 'profile':
        return FoodieProfileSettingsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onNavigateHome: () => _navigateTo('home'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          onPlayLudo: () => _navigateTo('ludo_game'),
          onLogOut: () {
            context.read<DinerState>().setFoodieLoggedIn(false);
            _navigateTo('welcome');
          },
        );

      case 'notifications':
        return NotificationsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onNavigateExplore: () => _navigateTo('home'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateSlip: () => _navigateTo('reservation_slip'),
          onNavigateLudo: () => _navigateTo('ludo_game'),
          onNavigatePlatters: () => _navigateTo('platters'),
          onNavigateReceipt: () => _navigateTo('receipt'),
          onNavigateSocial: () => _navigateTo('social'),
        );

      case 'ludo_game':
        return TreatLudoGameScreen(
          onBack: () => _navigateTo('profile'),
          onShowLeaderboard: () => _navigateTo('ludo_leaderboard'),
          onMatchResultFinished: (result) {
            setState(() {
              _lastLudoMatchResult = result;
              _lastLudoStandings = result.standings;
            });
            _navigateTo('ludo_leaderboard');
          },
          onMatchFinished: (standings) {
            setState(() {
              _lastLudoStandings = standings;
            });
            _navigateTo('ludo_leaderboard');
          },
          onOpenProfile: () => _navigateTo('profile'),
        );

      case 'ludo_leaderboard':
        return TreatLudoLeaderboardScreen(
          matchResult: _lastLudoMatchResult,
          standings: _lastLudoStandings,
          roundsPlayed: 4,
          onBack: () => _navigateTo('ludo_game'),
          onRematch: () {
            setState(() {
              _lastLudoMatchResult = null;
              _lastLudoStandings = null;
            });
            _navigateTo('ludo_game');
          },
          onBackToProfile: () => _navigateTo('profile'),
          onNavigateTab: (tab) {
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

      default:
        return HomePromotionsScreen(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
          onSelectDeal: (_) => _navigateTo('platters'),
          onNavigateBudgetPlanner: () => _navigateTo('budget'),
          onNavigateProfile: () => _navigateTo('profile'),
          onNavigateNotifications: () => _navigateTo('notifications'),
        );
    }
  }
}

