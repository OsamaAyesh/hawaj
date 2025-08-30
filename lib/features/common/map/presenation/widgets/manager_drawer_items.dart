import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/profile_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../profile/domain/di/di.dart';
import 'drawer_widget.dart';

/// Constant keys for features (must match the JSON keys used in localization).
class DrawerFeatures {
  // User
  static const userProfile = 'user_profile';
  static const userDailyOffers = 'user_daily_offers';
  static const userContracts = 'user_contracts';
  static const userRealEstate = 'user_real_estate';
  static const userDelivery = 'user_delivery';
  static const userJobs = 'user_jobs';

  // Provider
  static const providerManageOffers = 'provider_manage_offers';
  static const providerManageContracts = 'provider_manage_contracts';
  static const providerRealEstateManage = 'provider_real_estate_manage';
  static const providerDeliveryDashboard = 'provider_delivery_dashboard';
  static const providerManageJobs = 'provider_manage_jobs';

  /// Helper groups
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

/// Drawer manager that handles visibility of items based on enabled features.
class DrawerVisibilityManager {
  /// Set of enabled feature keys (based on user subscription or permissions).
  final Set<String> _enabled;

  DrawerVisibilityManager({Set<String>? enabled})
      : _enabled = {...(enabled ?? const <String>{})};

  /// Check if a feature is enabled
  bool isEnabled(String featureKey) => _enabled.contains(featureKey);

  /// Enable a feature
  void enable(String featureKey) => _enabled.add(featureKey);

  /// Disable a feature
  void disable(String featureKey) => _enabled.remove(featureKey);

  /// Toggle a feature
  void toggle(String featureKey) =>
      isEnabled(featureKey) ? disable(featureKey) : enable(featureKey);

  /// Build a single Drawer item by its feature key
  DrawerItemModel? _buildItem(String featureKey) {
    switch (featureKey) {
    // ===== User =====
      case DrawerFeatures.userProfile:
        return DrawerItemModel(
          iconPath: ManagerIcons.userProfileIcon,
          title: ManagerStrings.userProfile,
          onTap: () {
            initGetProfile();
            Get.to(ProfileScreen());
          },
        );
      case DrawerFeatures.userDailyOffers:
        return DrawerItemModel(
          iconPath: ManagerIcons.userDailyOffersIcon,
          title: ManagerStrings.userDailyOffers,
          onTap: () => print("Open daily offers"),
        );
      case DrawerFeatures.userContracts:
        return DrawerItemModel(
          iconPath: ManagerIcons.userContractsIcon,
          title: ManagerStrings.userContracts,
          onTap: () => print("Open contracts"),
        );
      case DrawerFeatures.userRealEstate:
        return DrawerItemModel(
          iconPath: ManagerIcons.userRealEstateIcon,
          title: ManagerStrings.userRealEstate,
          onTap: () => print("Open real estate"),
        );
      case DrawerFeatures.userDelivery:
        return DrawerItemModel(
          iconPath: ManagerIcons.userDeliveryIcon,
          title: ManagerStrings.userDelivery,
          onTap: () => print("Open delivery"),
        );
      case DrawerFeatures.userJobs:
        return DrawerItemModel(
          iconPath: ManagerIcons.userJobsIcon,
          title: ManagerStrings.userJobs,
          onTap: () => print("Open jobs"),
        );

    // ===== Provider =====
      case DrawerFeatures.providerManageOffers:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerOffersIcon,
          title: ManagerStrings.providerManageOffers,
          onTap: () => print("Open manage offers"),
        );
      case DrawerFeatures.providerManageContracts:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerContractsIcon,
          title: ManagerStrings.providerManageContracts,
          onTap: () => print("Open manage contracts"),
        );
      case DrawerFeatures.providerRealEstateManage:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerRealEstateIcon,
          title: ManagerStrings.providerRealEstateManage,
          onTap: () => print("Open manage real estate"),
        );
      case DrawerFeatures.providerDeliveryDashboard:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerDeliveryIcon,
          title: ManagerStrings.providerDeliveryDashboard,
          onTap: () => print("Open delivery dashboard"),
        );
      case DrawerFeatures.providerManageJobs:
        return DrawerItemModel(
          iconPath: ManagerIcons.providerJobsIcon,
          title: ManagerStrings.providerManageJobs,
          onTap: () => print("Open manage jobs"),
        );
    }
    return null;
  }

  /// Build visible user items based on enabled keys
  List<DrawerItemModel> buildUserItems() {
    final visibleKeys =
    DrawerFeatures.userGroup.where((k) => _enabled.contains(k));
    return visibleKeys
        .map(_buildItem)
        .whereType<DrawerItemModel>()
        .toList(growable: false);
  }

  /// Build visible provider items based on enabled keys
  List<DrawerItemModel> buildProviderItems() {
    final visibleKeys =
    DrawerFeatures.providerGroup.where((k) => _enabled.contains(k));
    return visibleKeys
        .map(_buildItem)
        .whereType<DrawerItemModel>()
        .toList(growable: false);
  }

  /// Build all items (user + provider) based on enabled keys
  List<DrawerItemModel> buildAllItems() {
    final allKeys = {
      ...DrawerFeatures.userGroup,
      ...DrawerFeatures.providerGroup,
    }.where((k) => _enabled.contains(k));
    return allKeys.map(_buildItem).whereType<DrawerItemModel>().toList();
  }

  /// Get all enabled keys (useful for saving/restoring state)
  Set<String> get enabledKeys => {..._enabled};
}
