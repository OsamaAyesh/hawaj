import 'package:get/get.dart';

import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_strings.dart';
import '../../../../common/profile/domain/di/di.dart';
import '../../../../common/profile/presentation/pages/profile_screen.dart';
import '../../../../providers/offers_provider/manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
import 'drawer_widget.dart';

/// مفاتيح الأقسام المتاحة
class DrawerFeatures {
  // ===== أقسام المستخدم =====
  static const userProfile = 'user_profile';
  static const userDailyOffers = 'user_daily_offers';
  static const userContracts = 'user_contracts';
  static const userRealEstate = 'user_real_estate';
  static const userDelivery = 'user_delivery';
  static const userJobs = 'user_jobs';

  // ===== أقسام مزود الخدمة =====
  static const providerManageOffers = 'provider_manage_offers';
  static const providerManageContracts = 'provider_manage_contracts';
  static const providerRealEstateManage = 'provider_real_estate_manage';
  static const providerDeliveryDashboard = 'provider_delivery_dashboard';
  static const providerManageJobs = 'provider_manage_jobs';

  /// مجموعات الأقسام
  static const Set<String> userGroup = {
    userProfile,
    userDailyOffers,
    userContracts,
    userRealEstate,
    userDelivery,
    userJobs,
  };

  static const Set<String> providerGroup = {
    providerManageOffers,
    providerManageContracts,
    providerRealEstateManage,
    providerDeliveryDashboard,
    providerManageJobs,
  };
}

/// نظام التنقلات - أضف روابط الصفحات هنا
class DrawerNavigationRoutes {
  // ===== User Routes =====
  static void navigateToProfile() {
    initGetProfile();
    Get.to(() => ProfileScreen());
  }

  static void navigateToDailyOffers() {
    // TODO: أضف التنقل لصفحة العروض اليومية
    // initDailyOffers();
    // Get.to(() => DailyOffersScreen());
  }

  static void navigateToContracts() {
    // TODO: أضف التنقل لصفحة العقود
    // initContracts();
    // Get.to(() => ContractsScreen());
    Get.snackbar('قيد التطوير', 'صفحة العقود');
  }

  static void navigateToRealEstate() {
    // TODO: أضف التنقل لصفحة العقارات
    // initRealEstate();
    // Get.to(() => RealEstateScreen());
    Get.snackbar('قيد التطوير', 'صفحة العقارات');
  }

  static void navigateToDelivery() {
    // TODO: أضف التنقل لصفحة التوصيل
    // initDelivery();
    // Get.to(() => DeliveryScreen());
    Get.snackbar('قيد التطوير', 'صفحة التوصيل');
  }

  static void navigateToJobs() {
    // TODO: أضف التنقل لصفحة الوظائف
    // initJobs();
    // Get.to(() => JobsScreen());
    Get.snackbar('قيد التطوير', 'صفحة الوظائف');
  }

  // ===== Provider Routes =====
  static void navigateToManageOffers() {
    // TODO: أضف التنقل لإدارة العروض
    // initManageOffers();
    Get.offAll(() => ManagerProductsOfferProviderScreen());
  }

  static void navigateToManageContracts() {
    // TODO: أضف التنقل لإدارة العقود
    // initManageContracts();
    // Get.to(() => ManageContractsScreen());
    // Get.snackbar('قيد التطوير', 'إدارة العقود');
  }

  static void navigateToManageRealEstate() {
    // TODO: أضف التنقل لإدارة العقارات
    // initManageRealEstate();
    // Get.offAll(() => DashboardRealEstateManagerScreen());
    // Get.to(() => ManageRealEstateScreen());
    // Get.snackbar('قيد التطوير', 'إدارة العقارات');
  }

  static void navigateToDeliveryDashboard() {
    // TODO: أضف التنقل للوحة التوصيل
    // initDeliveryDashboard();
    // Get.to(() => DeliveryDashboardScreen());
    // Get.snackbar('قيد التطوير', 'لوحة التوصيل');
  }

  static void navigateToManageJobs() {
    // TODO: أضف التنقل لإدارة الوظائف
    // initManageJobs();
    // Get.offAll(() => ManageCompanyJobsProviderScreen());
    // Get.to(() => ManageJobsScreen());
    // Get.snackbar('قيد التطوير', 'إدارة الوظائف');
  }
}

/// مدير رؤية الأقسام والتنقلات
class DrawerVisibilityManager {
  final Set<String> _enabled;

  DrawerVisibilityManager({Set<String>? enabled})
      : _enabled = {...(enabled ?? const <String>{})};

  /// التحقق من تفعيل قسم
  bool isEnabled(String featureKey) => _enabled.contains(featureKey);

  /// تفعيل قسم
  void enable(String featureKey) => _enabled.add(featureKey);

  /// تعطيل قسم
  void disable(String featureKey) => _enabled.remove(featureKey);

  /// عكس حالة القسم
  void toggle(String featureKey) =>
      isEnabled(featureKey) ? disable(featureKey) : enable(featureKey);

  /// بناء عنصر واحد من الـ Drawer
  DrawerItemModel? _buildItem(String featureKey) {
    switch (featureKey) {
      // ===== أقسام المستخدم =====
      case DrawerFeatures.userProfile:
        return DrawerItemModel(
          iconPath: ManagerIcons.userProfileIcon,
          title: ManagerStrings.userProfile,
          onTap: DrawerNavigationRoutes.navigateToProfile,
        );

      case DrawerFeatures.userDailyOffers:
        return DrawerItemModel(
          iconPath: ManagerIcons.userDailyOffersIcon,
          title: ManagerStrings.userDailyOffers,
          onTap: DrawerNavigationRoutes.navigateToDailyOffers,
        );

      case DrawerFeatures.userContracts:
        return DrawerItemModel(
          iconPath: ManagerIcons.userContractsIcon,
          title: ManagerStrings.userContracts,
          onTap: DrawerNavigationRoutes.navigateToContracts,
        );

      case DrawerFeatures.userRealEstate:
        return DrawerItemModel(
          iconPath: ManagerIcons.userRealEstateIcon,
          title: ManagerStrings.userRealEstate,
          onTap: DrawerNavigationRoutes.navigateToRealEstate,
        );

      case DrawerFeatures.userDelivery:
        return DrawerItemModel(
          iconPath: ManagerIcons.userDeliveryIcon,
          title: ManagerStrings.userDelivery,
          onTap: DrawerNavigationRoutes.navigateToDelivery,
        );

      case DrawerFeatures.userJobs:
        return DrawerItemModel(
          iconPath: ManagerIcons.userJobsIcon,
          title: ManagerStrings.userJobs,
          onTap: DrawerNavigationRoutes.navigateToJobs,
        );

      // ===== أقسام مزود الخدمة =====
      case DrawerFeatures.providerManageOffers:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerOffersIcon,
          title: ManagerStrings.providerManageOffers,
          onTap: DrawerNavigationRoutes.navigateToManageOffers,
        );

      case DrawerFeatures.providerManageContracts:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerContractsIcon,
          title: ManagerStrings.providerManageContracts,
          onTap: DrawerNavigationRoutes.navigateToManageContracts,
        );

      case DrawerFeatures.providerRealEstateManage:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerRealEstateIcon,
          title: ManagerStrings.providerRealEstateManage,
          onTap: DrawerNavigationRoutes.navigateToManageRealEstate,
        );

      case DrawerFeatures.providerDeliveryDashboard:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerDeliveryIcon,
          title: ManagerStrings.providerDeliveryDashboard,
          onTap: DrawerNavigationRoutes.navigateToDeliveryDashboard,
        );

      case DrawerFeatures.providerManageJobs:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerJobsIcon,
          title: ManagerStrings.providerManageJobs,
          onTap: DrawerNavigationRoutes.navigateToManageJobs,
        );

      default:
        return null;
    }
  }

  /// بناء أقسام المستخدم المرئية
  List<DrawerItemModel> buildUserItems() {
    final visibleKeys =
        DrawerFeatures.userGroup.where((k) => _enabled.contains(k));
    return visibleKeys
        .map(_buildItem)
        .whereType<DrawerItemModel>()
        .toList(growable: false);
  }

  /// بناء أقسام مزود الخدمة المرئية
  List<DrawerItemModel> buildProviderItems() {
    final visibleKeys =
        DrawerFeatures.providerGroup.where((k) => _enabled.contains(k));
    return visibleKeys
        .map(_buildItem)
        .whereType<DrawerItemModel>()
        .toList(growable: false);
  }

  /// بناء جميع الأقسام
  List<DrawerItemModel> buildAllItems() {
    final allKeys = {
      ...DrawerFeatures.userGroup,
      ...DrawerFeatures.providerGroup,
    }.where((k) => _enabled.contains(k));
    return allKeys.map(_buildItem).whereType<DrawerItemModel>().toList();
  }

  /// الحصول على الأقسام المفعّلة
  Set<String> get enabledKeys => {..._enabled};
}
