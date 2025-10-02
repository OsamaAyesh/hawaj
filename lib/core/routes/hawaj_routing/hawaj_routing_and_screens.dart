import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/profile_screen.dart';
import 'package:app_mobile/features/providers/commercial_contracts/manager_my_services_commercial_contracts/presentation/pages/manager_my_services_commercial_contracts_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/presentation/pages/add_offer_provider_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/presentation/pages/details_my_company_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/presentation/pages/register_company_offer_provider_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/presentation/pages/success_subscription_offer_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/common/profile/domain/di/di.dart';
import '../../../features/common/profile/presentation/pages/contact_us_screen.dart';
import '../../../features/common/profile/presentation/pages/manager_services_screen.dart';
import '../../../features/common/under_development/presentation/pages/under_development_screen.dart';
import '../../../features/providers/offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';

/// ═══════════════════════════════════════════════════════════
/// Main Sections In Hawaj
/// ═══════════════════════════════════════════════════════════
class HawajSections {
  static const String dailyOffers = "1";
  static const String commercialContracts = "2";
  static const String restaurants = "3";
  static const String orders = "4";
  static const String profile = "5";
}

/// ═══════════════════════════════════════════════════════════
/// Screens In Main Sections In Hawaj
/// ═══════════════════════════════════════════════════════════
class HawajScreens {
  // Daily Offers Section (1)
  ///======>User
  static const String map = "1";
  static const String detailsCompanyUser = "2";
  static const String chatScreen = "3";
  static const String profileScreen = "4";
  static const String editProfile = "5";
  static const String sendReport = "6";
  static const String mangerFavorite = "7";
  static const String favoriteScreenProducts = "8";

  ///=======>Provider
  static const String subscriptionOfferProvider = "9";
  static const String successSubscriptionOfferProviderScreen = "10";
  static const String registerCompanyOfferProviderScreen = "11";
  static const String addOfferProviderScreen = "12";
  static const String managerProductsOfferProviderScreen = "13";
  static const String manageListOfferProviderScreen = "14";
  static const String detailsMyCompanyDailyOfferScreen = "15";

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
/// Transition Types
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
///  Route Configuration
/// ═══════════════════════════════════════════════════════════
class HawajRouteConfig {
  final String section;
  final String screen;
  final Widget Function(Map<String, dynamic>? params) builder;
  final String name;
  final HawajTransition transition;
  final Duration duration;
  final void Function(Map<String, dynamic>? params)? init;

  const HawajRouteConfig({
    required this.section,
    required this.screen,
    required this.builder,
    required this.name,
    this.transition = HawajTransition.fadeSlide,
    this.duration = const Duration(milliseconds: 400),
    this.init,
  });

  String get key => '$section-$screen';
}

/// ═══════════════════════════════════════════════════════════
///  Routes Registry
/// ═══════════════════════════════════════════════════════════
class HawajRoutes {
  static final List<HawajRouteConfig> _routes = [
    // ═══════════════════════════════════════════════════════
    //  DAILY OFFERS SECTION (1)
    // ═══════════════════════════════════════════════════════
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.map,
      name: 'Map Screen With Offer',
      builder: (params) => const MapScreen(),
      transition: HawajTransition.fade,
      init: (params) {
        // initOffersController(); // ✅ هذا السطر فقط

        // مثال: تحميل بيانات الموقع أو العروض
      },
    ),

    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.detailsCompanyUser,
      name: 'Details Company With Offer Screen',
      builder: (params) => ManagerMyServicesCommercialContractsScreen(),
      transition: HawajTransition.slideUp,
    ),

    HawajRouteConfig(
        section: HawajSections.dailyOffers,
        screen: HawajScreens.profileScreen,
        name: 'Profile User Screen',
        builder: (params) => ProfileScreen(),
        transition: HawajTransition.slideUp,
        init: (params) {
          initGetProfile();
        }),

    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.editProfile,
      name: 'Profile User Screen',
      builder: (params) => EditProfileScreen(),
      transition: HawajTransition.slideUp,
    ),

    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.sendReport,
      name: 'Contact Us Send Report',
      builder: (params) => ContactUsScreen(),
      transition: HawajTransition.slideUp,
    ),

    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.mangerFavorite,
      name: 'ManagerFavorite',
      builder: (params) => ManagerServicesScreen(),
      transition: HawajTransition.slideUp,
    ),

    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.subscriptionOfferProvider,
      name: 'Subscription Offer Provider',
      builder: (params) => ContactUsScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.successSubscriptionOfferProviderScreen,
      name: 'Success Subscription Offer Provider Screen',
      builder: (params) => SuccessSubscriptionOfferProviderScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.registerCompanyOfferProviderScreen,
      name: 'Register Company Offer Provider Screen',
      builder: (params) => RegisterCompanyOfferProviderScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.addOfferProviderScreen,
      name: 'Add Offer Provider Screen',
      builder: (params) => AddOfferProviderScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.managerProductsOfferProviderScreen,
      name: 'Manager Products Offer Provider Screen',
      builder: (params) => ManagerProductsOfferProviderScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.manageListOfferProviderScreen,
      name: 'Manage List Offer Provider Screen',
      builder: (params) => ManageListOfferProviderScreen(),
      transition: HawajTransition.slideUp,
    ),
    HawajRouteConfig(
      section: HawajSections.dailyOffers,
      screen: HawajScreens.detailsMyCompanyDailyOfferScreen,
      name: 'Details My Company Screen',
      builder: (params) => DetailsMyCompanyScreen(),
      transition: HawajTransition.slideUp,
    ),
  ];

  /// ═══════════════════════════════════════════════════════
  /// 🔍 Find Route by Section & Screen
  /// الآن ترجع route للشاشة Under Development إذا لم يجد
  /// ═══════════════════════════════════════════════════════
  static HawajRouteConfig? findRoute(String section, String screen) {
    try {
      return _routes.firstWhere(
        (route) => route.section == section && route.screen == screen,
      );
    } catch (e) {
      debugPrint('❌ Route not found: Section=$section, Screen=$screen');
      debugPrint('🚧 Redirecting to Under Development Screen...');

      // 👇 إرجاع route للشاشة Under Development
      return HawajRouteConfig(
        section: section,
        screen: screen,
        name: 'Under Development',
        builder: (params) => UnderDevelopmentScreen(
          sectionId: section,
          screenId: screen,
          message: params?['message'] as String?,
        ),
        transition: HawajTransition.fadeSlide,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  /// ═══════════════════════════════════════════════════════
  ///  Check if Route Exists
  /// ═══════════════════════════════════════════════════════
  static bool routeExists(String section, String screen) {
    try {
      _routes.firstWhere(
        (route) => route.section == section && route.screen == screen,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ═══════════════════════════════════════════════════════
  ///  Navigate with Animation
  /// الآن تعمل تلقائياً حتى لو لم يكن الـ route موجود
  /// ═══════════════════════════════════════════════════════
  static Future<void> navigateTo({
    required String section,
    required String screen,
    Map<String, dynamic>? parameters,
    bool replace = false,
  }) async {
    final route = findRoute(section, screen);

    // الآن findRoute دائماً ترجع route (إما الحقيقي أو Under Development)
    if (route == null) {
      debugPrint('❌ Critical Error: Cannot create route');
      return;
    }

    route.init?.call(parameters);

    final page = route.builder(parameters);
    final transition = _getTransition(route.transition);

    if (replace) {
      Get.off(() => page, transition: transition, duration: route.duration);
    } else {
      Get.to(() => page, transition: transition, duration: route.duration);
    }
  }

  /// ═══════════════════════════════════════════════════════
  /// 🎨 Navigate to Under Development Screen (استخدام مباشر)
  /// ═══════════════════════════════════════════════════════
  static Future<void> showUnderDevelopment({
    String? section,
    String? screen,
    String? message,
  }) async {
    Get.to(
      () => UnderDevelopmentScreen(
        sectionId: section,
        screenId: screen,
        message: message,
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  /// ═══════════════════════════════════════════════════════
  ///  Get GetX Transition from HawajTransition
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
  ///  Get All Routes
  /// ═══════════════════════════════════════════════════════
  static List<HawajRouteConfig> getAllRoutes() => _routes;

  /// ═══════════════════════════════════════════════════════
  /// 🖨 Print All Routes (Debug)
  /// ═══════════════════════════════════════════════════════
  static void printAllRoutes() {
    debugPrint('═══════════════════════════════════════════════');
    debugPrint('📱 All Hawaj Routes (${_routes.length} total):');
    debugPrint('═══════════════════════════════════════════════');
    for (var route in _routes) {
      debugPrint('✅ ${route.key} → ${route.name}');
    }
    debugPrint('═══════════════════════════════════════════════');
  }
}
// import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
// import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
// import 'package:app_mobile/features/common/profile/presentation/pages/profile_screen.dart';
// import 'package:app_mobile/features/providers/commercial_contracts/manager_my_services_commercial_contracts/presentation/pages/manager_my_services_commercial_contracts_screen.dart';
// import 'package:app_mobile/features/providers/offers_provider/add_offer/presentation/pages/add_offer_provider_screen.dart';
// import 'package:app_mobile/features/providers/offers_provider/details_my_company/presentation/pages/details_my_company_screen.dart';
// import 'package:app_mobile/features/providers/offers_provider/manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
// import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/presentation/pages/register_company_offer_provider_screen.dart';
// import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/presentation/pages/success_subscription_offer_provider_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../features/common/profile/presentation/pages/contact_us_screen.dart';
// import '../../../features/common/profile/presentation/pages/manager_services_screen.dart';
// import '../../../features/providers/offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';
//
// /// ═══════════════════════════════════════════════════════════
// /// Main Sections In Hawaj
// /// ═══════════════════════════════════════════════════════════
// class HawajSections {
//   static const String dailyOffers = "1";
//   static const String commercialContracts = "2";
//   static const String restaurants = "3";
//   static const String orders = "4";
//   static const String profile = "5";
// }
//
// /// ═══════════════════════════════════════════════════════════
// /// Screens In Main Sections In Hawaj
// /// ═══════════════════════════════════════════════════════════
// class HawajScreens {
//   // Daily Offers Section (1)
//   ///======>User
//   static const String map = "1";
//   static const String detailsCompanyUser = "2";
//   static const String chatScreen = "3";
//   static const String profileScreen = "4";
//   static const String editProfile = "5";
//   static const String sendReport = "6";
//   static const String mangerFavorite = "7";
//   static const String favoriteScreenProducts = "8";
//
//   ///=======>Provider
//   static const String subscriptionOfferProvider = "9";
//   static const String successSubscriptionOfferProviderScreen = "10";
//   static const String registerCompanyOfferProviderScreen = "11";
//   static const String addOfferProviderScreen = "12";
//   static const String managerProductsOfferProviderScreen = "13";
//   static const String manageListOfferProviderScreen = "14";
//   static const String detailsMyCompanyDailyOfferScreen = "15";
//
//   // Offers Section (2)
//   static const String offersDaily = "1";
//   static const String offersWeekly = "2";
//   static const String offersNearby = "3";
//
//   // Restaurants Section (3)
//   static const String restaurantsList = "1";
//   static const String restaurantDetails = "2";
//   static const String restaurantMenu = "3";
//   static const String restaurantReviews = "4";
//
//   // Orders Section (4)
//   static const String ordersActive = "1";
//   static const String ordersHistory = "2";
//   static const String orderDetails = "3";
//
//   // Profile Section (5)
//   static const String profileMain = "1";
//   static const String profileEdit = "2";
//   static const String profileSettings = "3";
// }
//
// /// ═══════════════════════════════════════════════════════════
// /// Transition Types
// /// ═══════════════════════════════════════════════════════════
// enum HawajTransition {
//   fade,
//   slide,
//   scale,
//   fadeSlide,
//   slideUp,
//   zoom,
//   rotation,
// }
//
// /// ═══════════════════════════════════════════════════════════
// /// 📦 Route Configuration
// /// ═══════════════════════════════════════════════════════════
// class HawajRouteConfig {
//   final String section;
//   final String screen;
//   final Widget Function(Map<String, dynamic>? params) builder;
//   final String name;
//   final HawajTransition transition;
//   final Duration duration;
//   final void Function(Map<String, dynamic>? params)? init; // 👈 init اختياري
//
//   const HawajRouteConfig({
//     required this.section,
//     required this.screen,
//     required this.builder,
//     required this.name,
//     this.transition = HawajTransition.fadeSlide,
//     this.duration = const Duration(milliseconds: 400),
//     this.init,
//   });
//
//   String get key => '$section-$screen';
// }
//
// /// ═══════════════════════════════════════════════════════════
// ///  Routes Registry
// /// ═══════════════════════════════════════════════════════════
// class HawajRoutes {
//   static final List<HawajRouteConfig> _routes = [
//     // ═══════════════════════════════════════════════════════
//     //  DAILY OFFERS SECTION (1)
//     // ═══════════════════════════════════════════════════════
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.map,
//       name: 'Map Screen With Offer',
//       builder: (params) => const MapScreen(),
//       transition: HawajTransition.fade,
//       init: (params) {
//         // مثال: تحميل بيانات الموقع أو العروض
//       },
//     ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.detailsCompanyUser,
//       name: 'Details Company With Offer Screen',
//       builder: (params) => ManagerMyServicesCommercialContractsScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//
//     ///===>Chat Screen
//     // HawajRouteConfig(
//     //   section: HawajSections.dailyOffers,
//     //   screen: HawajScreens.chatScreen,
//     //   name: 'Chat Screen',
//     //   builder: (params) => ManagerMyServicesCommercialContractsScreen(),
//     //   transition: HawajTransition.slideUp,
//     // ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.profileScreen,
//       name: 'Profile User Screen',
//       builder: (params) => ProfileScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.editProfile,
//       name: 'Profile User Screen',
//       builder: (params) => EditProfileScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.sendReport,
//       name: 'Contact Us Send Report',
//       builder: (params) => ContactUsScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.mangerFavorite,
//       name: 'ManagerFavorite',
//       builder: (params) => ManagerServicesScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//
//     // HawajRouteConfig(
//     //   section: HawajSections.dailyOffers,
//     //   screen: HawajScreens.favoriteScreenProducts,
//     //   name: 'ManagerFavorite',
//     //   builder: (params) => FavoriteScreenProducts(),
//     //   transition: HawajTransition.slideUp,
//     // ),
//
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.subscriptionOfferProvider,
//       name: 'Subscription Offer Provider',
//       builder: (params) => ContactUsScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.successSubscriptionOfferProviderScreen,
//       name: 'Success Subscription Offer Provider Screen',
//       builder: (params) => SuccessSubscriptionOfferProviderScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.registerCompanyOfferProviderScreen,
//       name: 'Register Company Offer Provider Screen',
//       builder: (params) => RegisterCompanyOfferProviderScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.addOfferProviderScreen,
//       name: 'Add Offer Provider Screen',
//       builder: (params) => AddOfferProviderScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.managerProductsOfferProviderScreen,
//       name: 'Manager Products Offer Provider Screen',
//       builder: (params) => ManagerProductsOfferProviderScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.manageListOfferProviderScreen,
//       name: 'Manage List Offer Provider Screen',
//       builder: (params) => ManageListOfferProviderScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//     HawajRouteConfig(
//       section: HawajSections.dailyOffers,
//       screen: HawajScreens.detailsMyCompanyDailyOfferScreen,
//       name: 'Details My Company Screen',
//       builder: (params) => DetailsMyCompanyScreen(),
//       transition: HawajTransition.slideUp,
//     ),
//   ];
//
//   /// ═══════════════════════════════════════════════════════
//   /// Find Route by Section & Screen
//   /// ═══════════════════════════════════════════════════════
//   static HawajRouteConfig? findRoute(String section, String screen) {
//     try {
//       return _routes.firstWhere(
//         (route) => route.section == section && route.screen == screen,
//       );
//     } catch (e) {
//       debugPrint('❌ Route not found: Section=$section, Screen=$screen');
//       return null;
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════
//   ///  Check if Route Exists
//   /// ═══════════════════════════════════════════════════════
//   static bool routeExists(String section, String screen) {
//     return findRoute(section, screen) != null;
//   }
//
//   /// ═══════════════════════════════════════════════════════
//   ///  Navigate with Animation
//   /// ═══════════════════════════════════════════════════════
//   static Future<void> navigateTo({
//     required String section,
//     required String screen,
//     Map<String, dynamic>? parameters,
//     bool replace = false,
//   }) async {
//     final route = findRoute(section, screen);
//
//     if (route == null) {
//       debugPrint('❌ Cannot navigate: Route not found ($section-$screen)');
//       return;
//     }
//
//     route.init?.call(parameters);
//
//     final page = route.builder(parameters);
//     final transition = _getTransition(route.transition);
//
//     if (replace) {
//       Get.off(() => page, transition: transition, duration: route.duration);
//     } else {
//       Get.to(() => page, transition: transition, duration: route.duration);
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════
//   ///  Get GetX Transition from HawajTransition
//   /// ═══════════════════════════════════════════════════════
//   static Transition _getTransition(HawajTransition type) {
//     switch (type) {
//       case HawajTransition.fade:
//         return Transition.fade;
//       case HawajTransition.slide:
//         return Transition.rightToLeft;
//       case HawajTransition.scale:
//         return Transition.zoom;
//       case HawajTransition.fadeSlide:
//         return Transition.fadeIn;
//       case HawajTransition.slideUp:
//         return Transition.downToUp;
//       case HawajTransition.zoom:
//         return Transition.zoom;
//       case HawajTransition.rotation:
//         return Transition.size;
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════
//   ///  Get All Routes
//   /// ═══════════════════════════════════════════════════════
//   static List<HawajRouteConfig> getAllRoutes() => _routes;
//
//   /// ═══════════════════════════════════════════════════════
//   /// 🖨 Print All Routes (Debug)
//   /// ═══════════════════════════════════════════════════════
//   static void printAllRoutes() {
//     debugPrint('═══════════════════════════════════════════════');
//     debugPrint(' All Hawaj Routes (${_routes.length} total):');
//     debugPrint('═══════════════════════════════════════════════');
//     for (var route in _routes) {
//       debugPrint('${route.key} → ${route.name}');
//     }
//     debugPrint('═══════════════════════════════════════════════');
//   }
// }
