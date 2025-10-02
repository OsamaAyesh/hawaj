import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:flutter/material.dart';

/// This Main Sections In Hawaj
class HawajSections {
  static const String dailyOffers = "1";
  static const String offers = "2";
  static const String restaurants = "3";
  static const String orders = "4";
  static const String profile = "5";
}

/// Screens In Main Sections In Hawaj
class HawajScreens {
  // Home Section (1)
  static const String map = "1";
  static const String homeSearch = "2";
  static const String homeCategories = "3";

  // Offers Section (2)
  static const String offersDaily = "1";
  static const String offersWeekly = "2";
  static const String offersNearby = "3";

  // Restaurants Section (3)
  static const String restaurantsList = "1";
  static const String restaurantDetails = "2";
  static const String restaurantMenu = "3";
  static const String restaurantReviews = "4";

  // Orders Section (4)
  static const String ordersActive = "1";
  static const String ordersHistory = "2";
  static const String orderDetails = "3";

  // Profile Section (5)
  static const String profileMain = "1";
  static const String profileEdit = "2";
  static const String profileSettings = "3";
}

// Route Configuration
class HawajRouteConfig {
  final String section;
  final String screen;
  final Widget Function(Map<String, dynamic>? params) builder;
  final String name;

  const HawajRouteConfig({
    required this.section,
    required this.screen,
    required this.builder,
    required this.name,
  });

  String get key => '$section-$screen';
}

// تسجيل كل الـ Routes
class HawajRoutes {
  static final List<HawajRouteConfig> _routes = [
    // HOME SECTION (1)
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.map,
      name: 'Home Main',
      builder: (params) => const MapScreen(),
    ),
    // HawajRouteConfig(
    //   section: HawajSections.home,
    //   screen: HawajScreens.homeSearch,
    //   name: 'Home Search',
    //   builder: (params) => HomeSearchScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.home,
    //   screen: HawajScreens.homeCategories,
    //   name: 'Home Categories',
    //   builder: (params) => const HomeCategoriesScreen(),
    // ),
    //
    // // OFFERS SECTION (2)
    // HawajRouteConfig(
    //   section: HawajSections.offers,
    //   screen: HawajScreens.offersDaily,
    //   name: 'Daily Offers',
    //   builder: (params) => DailyOffersScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.offers,
    //   screen: HawajScreens.offersWeekly,
    //   name: 'Weekly Offers',
    //   builder: (params) => WeeklyOffersScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.offers,
    //   screen: HawajScreens.offersNearby,
    //   name: 'Nearby Offers',
    //   builder: (params) => NearbyOffersScreen(params: params),
    // ),
    //
    // // RESTAURANTS SECTION (3)
    // HawajRouteConfig(
    //   section: HawajSections.restaurants,
    //   screen: HawajScreens.restaurantsList,
    //   name: 'Restaurants List',
    //   builder: (params) => RestaurantsListScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.restaurants,
    //   screen: HawajScreens.restaurantDetails,
    //   name: 'Restaurant Details',
    //   builder: (params) => RestaurantDetailsScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.restaurants,
    //   screen: HawajScreens.restaurantMenu,
    //   name: 'Restaurant Menu',
    //   builder: (params) => RestaurantMenuScreen(params: params),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.restaurants,
    //   screen: HawajScreens.restaurantReviews,
    //   name: 'Restaurant Reviews',
    //   builder: (params) => RestaurantReviewsScreen(params: params),
    // ),
    //
    // // ORDERS SECTION (4)
    // HawajRouteConfig(
    //   section: HawajSections.orders,
    //   screen: HawajScreens.ordersActive,
    //   name: 'Active Orders',
    //   builder: (params) => const ActiveOrdersScreen(),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.orders,
    //   screen: HawajScreens.ordersHistory,
    //   name: 'Orders History',
    //   builder: (params) => const OrdersHistoryScreen(),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.orders,
    //   screen: HawajScreens.orderDetails,
    //   name: 'Order Details',
    //   builder: (params) => OrderDetailsScreen(params: params),
    // ),
    //
    // // PROFILE SECTION (5)
    // HawajRouteConfig(
    //   section: HawajSections.profile,
    //   screen: HawajScreens.profileMain,
    //   name: 'Profile',
    //   builder: (params) => const ProfileMainScreen(),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.profile,
    //   screen: HawajScreens.profileEdit,
    //   name: 'Edit Profile',
    //   builder: (params) => const ProfileEditScreen(),
    // ),
    // HawajRouteConfig(
    //   section: HawajSections.profile,
    //   screen: HawajScreens.profileSettings,
    //   name: 'Settings',
    //   builder: (params) => const ProfileSettingsScreen(),
    // ),
  ];

  static HawajRouteConfig? findRoute(String section, String screen) {
    try {
      return _routes.firstWhere(
        (route) => route.section == section && route.screen == screen,
      );
    } catch (e) {
      debugPrint('Route not found: $section-$screen');
      return null;
    }
  }

  static bool routeExists(String section, String screen) {
    return findRoute(section, screen) != null;
  }

  static List<HawajRouteConfig> getAllRoutes() => _routes;

  static void printAllRoutes() {
    debugPrint('════════════════════════════════════');
    debugPrint('All Hawaj Routes:');
    for (var route in _routes) {
      debugPrint('${route.key} -> ${route.name}');
    }
    debugPrint('════════════════════════════════════');
  }
}
