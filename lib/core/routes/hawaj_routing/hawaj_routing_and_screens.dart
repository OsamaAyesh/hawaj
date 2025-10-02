import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ═══════════════════════════════════════════════════════════
/// 🎯 Main Sections In Hawaj
/// ═══════════════════════════════════════════════════════════
class HawajSections {
  static const String dailyOffers = "1";
  static const String offers = "2";
  static const String restaurants = "3";
  static const String orders = "4";
  static const String profile = "5";
}

/// ═══════════════════════════════════════════════════════════
/// 📱 Screens In Main Sections In Hawaj
/// ═══════════════════════════════════════════════════════════
class HawajScreens {
  // Daily Offers Section (1)
  static const String map = "1";
  static const String dailyOffersList = "2";
  static const String dailyOfferDetails = "3";

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

/// ═══════════════════════════════════════════════════════════
/// 🎨 Transition Types
/// ═══════════════════════════════════════════════════════════
enum HawajTransition {
  fade,
  slide,
  scale,
  fadeSlide,
  slideUp,
  zoom,
  rotation,
}

/// ═══════════════════════════════════════════════════════════
/// 📦 Route Configuration
/// ═══════════════════════════════════════════════════════════
class HawajRouteConfig {
  final String section;
  final String screen;
  final Widget Function(Map<String, dynamic>? params) builder;
  final String name;
  final HawajTransition transition;
  final Duration duration;

  const HawajRouteConfig({
    required this.section,
    required this.screen,
    required this.builder,
    required this.name,
    this.transition = HawajTransition.fadeSlide,
    this.duration = const Duration(milliseconds: 400),
  });

  String get key => '$section-$screen';
}

/// ═══════════════════════════════════════════════════════════
/// 🗺️ Routes Registry - تسجيل كل الشاشات
/// ═══════════════════════════════════════════════════════════
class HawajRoutes {
  static final List<HawajRouteConfig> _routes = [
    // ═══════════════════════════════════════════════════════
    // 📍 DAILY OFFERS SECTION (1)
    // ═══════════════════════════════════════════════════════
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.map,
      name: 'Map Screen',
      builder: (params) => const MapScreen(),
      transition: HawajTransition.fade,
    ),

    // HawajRouteConfig(
    //   section: HawajSections.dailyOffers,
    //   screen: HawajScreens.dailyOffersList,
    //   name: 'Daily Offers List',
    //   builder: (params) => DailyOffersListScreen(params: params),
    //   transition: HawajTransition.slideUp,
    // ),
    //
    // HawajRouteConfig(
    //   section: HawajSections.dailyOffers,
    //   screen: HawajScreens.dailyOfferDetails,
    //   name: 'Daily Offer Details',
    //   builder: (params) => DailyOfferDetailsScreen(params: params),
    //   transition: HawajTransition.scale,
    // ),

    // ═══════════════════════════════════════════════════════
    // 🎁 OFFERS SECTION (2)
    // ═══════════════════════════════════════════════════════
    // HawajRouteConfig(
    //   section: HawajSections.offers,
    //   screen: HawajScreens.offersDaily,
    //   name: 'Daily Offers',
    //   builder: (params) => DailyOffersScreen(params: params),
    //   transition: HawajTransition.fadeSlide,
    // ),

    // ═══════════════════════════════════════════════════════
    // 🍽️ RESTAURANTS SECTION (3)
    // ═══════════════════════════════════════════════════════
    // HawajRouteConfig(
    //   section: HawajSections.restaurants,
    //   screen: HawajScreens.restaurantsList,
    //   name: 'Restaurants List',
    //   builder: (params) => RestaurantsListScreen(params: params),
    //   transition: HawajTransition.slideUp,
    // ),

    // ═══════════════════════════════════════════════════════
    // 📦 ORDERS SECTION (4)
    // ═══════════════════════════════════════════════════════
    // HawajRouteConfig(
    //   section: HawajSections.orders,
    //   screen: HawajScreens.ordersActive,
    //   name: 'Active Orders',
    //   builder: (params) => const ActiveOrdersScreen(),
    //   transition: HawajTransition.fade,
    // ),

    // ═══════════════════════════════════════════════════════
    // 👤 PROFILE SECTION (5)
    // ═══════════════════════════════════════════════════════
    // HawajRouteConfig(
    //   section: HawajSections.profile,
    //   screen: HawajScreens.profileMain,
    //   name: 'Profile',
    //   builder: (params) => const ProfileMainScreen(),
    //   transition: HawajTransition.fadeSlide,
    // ),
  ];

  /// ═══════════════════════════════════════════════════════
  /// 🔍 Find Route by Section & Screen
  /// ═══════════════════════════════════════════════════════
  static HawajRouteConfig? findRoute(String section, String screen) {
    try {
      return _routes.firstWhere(
        (route) => route.section == section && route.screen == screen,
      );
    } catch (e) {
      debugPrint('❌ Route not found: Section=$section, Screen=$screen');
      return null;
    }
  }

  /// ═══════════════════════════════════════════════════════
  /// ✅ Check if Route Exists
  /// ═══════════════════════════════════════════════════════
  static bool routeExists(String section, String screen) {
    return findRoute(section, screen) != null;
  }

  /// ═══════════════════════════════════════════════════════
  /// 🚀 Navigate with Animation
  /// ═══════════════════════════════════════════════════════
  static Future<void> navigateTo({
    required String section,
    required String screen,
    Map<String, dynamic>? parameters,
    bool replace = false,
  }) async {
    final route = findRoute(section, screen);

    if (route == null) {
      debugPrint('❌ Cannot navigate: Route not found ($section-$screen)');
      return;
    }

    debugPrint('🚀 Navigating to: ${route.name} ($section-$screen)');
    debugPrint('📦 Parameters: $parameters');

    final page = route.builder(parameters);
    final transition = _getTransition(route.transition);

    if (replace) {
      Get.off(
        () => page,
        transition: transition,
        duration: route.duration,
      );
    } else {
      Get.to(
        () => page,
        transition: transition,
        duration: route.duration,
      );
    }
  }

  /// ═══════════════════════════════════════════════════════
  /// 🎨 Get GetX Transition from HawajTransition
  /// ═══════════════════════════════════════════════════════
  static Transition _getTransition(HawajTransition type) {
    switch (type) {
      case HawajTransition.fade:
        return Transition.fade;
      case HawajTransition.slide:
        return Transition.rightToLeft;
      case HawajTransition.scale:
        return Transition.zoom;
      case HawajTransition.fadeSlide:
        return Transition.fadeIn;
      case HawajTransition.slideUp:
        return Transition.downToUp;
      case HawajTransition.zoom:
        return Transition.zoom;
      case HawajTransition.rotation:
        return Transition.size;
    }
  }

  /// ═══════════════════════════════════════════════════════
  /// 📋 Get All Routes
  /// ═══════════════════════════════════════════════════════
  static List<HawajRouteConfig> getAllRoutes() => _routes;

  /// ═══════════════════════════════════════════════════════
  /// 🖨️ Print All Routes (Debug)
  /// ═══════════════════════════════════════════════════════
  static void printAllRoutes() {
    debugPrint('═══════════════════════════════════════════════');
    debugPrint('📍 All Hawaj Routes (${_routes.length} total):');
    debugPrint('═══════════════════════════════════════════════');
    for (var route in _routes) {
      debugPrint('${route.key} → ${route.name}');
    }
    debugPrint('═══════════════════════════════════════════════');
  }
}
