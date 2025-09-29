import 'package:geolocator/geolocator.dart';

/// مدير للتعامل مع أذونات التطبيق بطريقة منظمة
class PermissionManager {
  /// التحقق من إذن الموقع وطلبه إذا لزم الأمر
  static Future<PermissionResult> handleLocationPermission() async {
    // التحقق من تفعيل خدمة الموقع
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return PermissionResult(
        granted: false,
        message: 'يرجى تفعيل خدمة الموقع',
        englishMessage: 'Please enable location services',
      );
    }

    // التحقق من الإذن
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return PermissionResult(
          granted: false,
          message: 'تم رفض إذن الموقع',
          englishMessage: 'Location permission denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return PermissionResult(
        granted: false,
        message: 'يرجى منح إذن الموقع من الإعدادات',
        englishMessage: 'Please enable location permission from settings',
        isPermanentlyDenied: true,
      );
    }

    return PermissionResult(granted: true);
  }

  /// فتح إعدادات التطبيق
  static Future<void> openAppSettings() async {
    await Geolocator.openLocationSettings();
  }
}

/// نتيجة طلب الإذن
class PermissionResult {
  final bool granted;
  final String? message;
  final String? englishMessage;
  final bool isPermanentlyDenied;

  PermissionResult({
    required this.granted,
    this.message,
    this.englishMessage,
    this.isPermanentlyDenied = false,
  });
}
