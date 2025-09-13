import 'package:get/get.dart';
import '../storage/local/app_settings_prefs.dart';

class AppLanguage {
  /// Singleton instance
  static final AppLanguage _instance = AppLanguage._internal();

  factory AppLanguage() => _instance;

  AppLanguage._internal();

  /// Get current app language
  ///
  /// - First: return language from GetX if available
  /// - Fallback: return from SharedPreferences
  String getCurrentLocale() {
    if (Get.locale != null) {
      return Get.locale!.languageCode;
    }
    return AppSettingsPrefs(Get.find()).getLocale();
  }
}
