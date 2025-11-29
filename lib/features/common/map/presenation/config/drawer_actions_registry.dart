// lib/features/common/drawer_menu/presentation/config/drawer_actions_registry.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/util/snack_bar.dart';
import '../../../../common/profile/domain/di/di.dart';
import '../../../../common/profile/presentation/pages/profile_screen.dart';
import '../../../../providers/job_provider_app/manage_company_jobs_provider/presentation/pages/manage_company_jobs_provider_screen.dart';
import '../../../../providers/offers_provider/manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
import '../../../../providers/real_estate_provider/dashboard_real_estate_manager/presentation/pages/dashboard_real_estate_manager_screen.dart';

class DrawerActionsRegistry {
  // ═══════════════════════════════════════════════════════════
  // 🎯 Map للدوال
  // ═══════════════════════════════════════════════════════════
  static final Map<String, VoidCallback> _actions = {
    // User Actions
    'profile': () {
      initGetProfile();
      Get.to(() => ProfileScreen());
    },

    'daily_offers': () => _sendToHawaj('daily_offers'),
    'realestate': () => _sendToHawaj('realestate'),
    'jobs': () => _sendToHawaj('jobs'),
    // 'contracts': () => AppSnackbar.info('قريباً - خدمة العقود'),
    // 'delivery': () => AppSnackbar.info('قريباً - خدمة التوصيل'),

    // Provider Actions
    'manage_offers': () =>
        Get.offAll(() => ManagerProductsOfferProviderScreen()),
    'manage_realestate': () =>
        Get.offAll(() => DashboardRealEstateManagerScreen()),
    'manage_jobs': () => Get.offAll(() => ManageCompanyJobsProviderScreen()),
    // 'manage_contracts': () => AppSnackbar.info('قريباً - إدارة العقود'),
    // 'delivery_dashboard': () => AppSnackbar.info('قريباً - لوحة التوصيل'),

    // System Actions
    'logout': _handleLogout,
    // 'settings': () => AppSnackbar.info('قريباً - الإعدادات'),
  };

  // ═══════════════════════════════════════════════════════════
  // 🎨 Map للأيقونات
  // ═══════════════════════════════════════════════════════════
  static final Map<String, String> _icons = {
    // User Icons
    'profile': ManagerIcons.userProfileIcon,
    'daily_offers': ManagerIcons.userDailyOffersIcon,
    'realestate': ManagerIcons.userRealEstateIcon,
    'jobs': ManagerIcons.userJobsIcon,
    'contracts': ManagerIcons.userContractsIcon,
    'delivery': ManagerIcons.userDeliveryIcon,

    // Provider Icons
    'manage_offers': ManagerIcons.providerOffersIcon,
    'manage_realestate': ManagerIcons.providerRealEstateIcon,
    'manage_jobs': ManagerIcons.providerJobsIcon,
    'manage_contracts': ManagerIcons.providerContractsIcon,
    'delivery_dashboard': ManagerIcons.providerDeliveryIcon,

    // System Icons
    'logout': ManagerIcons.userProfileIcon,
    'settings': ManagerIcons.userProfileIcon,
  };

  // ═══════════════════════════════════════════════════════════
  // ✅ Methods
  // ═══════════════════════════════════════════════════════════
  static bool hasAction(String actionId) => _actions.containsKey(actionId);

  static VoidCallback? getAction(String actionId) => _actions[actionId];

  static String? getIcon(String actionId) => _icons[actionId];

  // ═══════════════════════════════════════════════════════════
  // 🔧 Helper Methods
  // ═══════════════════════════════════════════════════════════
  static void _sendToHawaj(String searchText) {
    try {
      // final hawajC = Get.find<HawajController>();
      // Get.back();
      // hawajC.sendData(searchText);
      // AppSnackbar.info('🎙️ جارٍ البحث...');
    } catch (e) {
      AppSnackbar.error('تعذر الاتصال بحواج');
    }
  }

  static void _handleLogout() {
    Get.defaultDialog(
      title: 'تسجيل الخروج',
      middleText: 'هل أنت متأكد من تسجيل الخروج؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        AppSnackbar.success('تم تسجيل الخروج بنجاح');
        // TODO: Implement actual logout
      },
    );
  }
}
