import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/di/dependency_injection.dart';
import '../storage/local/app_settings_prefs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/di/dependency_injection.dart';
import '../storage/local/app_settings_prefs.dart';

class LocaleController extends GetxController {
  Locale? locale;
  final AppSettingsPrefs _appSettingsPrefs = instance<AppSettingsPrefs>();

  Future<void> changeLanguage(String langCode) async {
    final newLocale = Locale(langCode);
    await _appSettingsPrefs.setLocale(locale: langCode);

    // Use Get.key.currentContext to avoid context being null
    await EasyLocalization.of(Get.key.currentContext!)?.setLocale(newLocale);
    Get.updateLocale(newLocale);
  }

  @override
  void onInit() {
    super.onInit();
    final appLocale = _appSettingsPrefs.getLocale().pareWithDefaultLocale();
    locale = getLocaleFromString(appLocale);
  }

  Locale getLocaleFromString(String appLocale) {
    switch (appLocale) {
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      default:
        return Locale(Get.deviceLocale?.languageCode ?? 'en');
    }
  }
}

// class LocaleController extends GetxController {
//   Locale? locale;
//   final AppSettingsPrefs _appSettingsPrefs = instance<AppSettingsPrefs>();
//
//   BuildContext context = Get.context!;
//
//   // changeLanguage(String langCode) {
//   //   Locale locale = Locale(langCode);
//   //   _appSettingsPrefs.setLocale(
//   //     locale: langCode,
//   //   );
//   //   EasyLocalization.of(context)!.setLocale(Locale(langCode));
//   //   Get.updateLocale(locale);
//   // }
//   Future<void> changeLanguage(String langCode) async {
//     final newLocale = Locale(langCode);
//     await _appSettingsPrefs.setLocale(locale: langCode);
//
//     await EasyLocalization.of(Get.key.currentContext!)?.setLocale(newLocale);
//
//     Get.updateLocale(newLocale);
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     final appLocale = _appSettingsPrefs.getLocale().pareWithDefaultLocale();
//     locale = _getLocaleFromString(appLocale);
//   }
//
//   Locale _getLocaleFromString(String appLocale) {
//     switch (appLocale) {
//       case 'ar':
//         return const Locale('ar');
//       case 'en':
//         return const Locale('en');
//       default:
//         return Locale(Get.deviceLocale!.languageCode);
//     }
//   }
// }
