
import 'package:geolocator/geolocator.dart';

import '../../../../../core/util/snack_bar.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    AppSnackbar.warning("رجاءً فعّل خدمة الموقع من الإعدادات.",
        englishMessage: "Please enable location services from settings.");
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      AppSnackbar.error("لا يمكن استخدام الخريطة بدون إذن الموقع.",
          englishMessage:
          "The map cannot be used without location permission.");
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    AppSnackbar.error("رجاءً فعّل إذن الموقع يدويًا من إعدادات الهاتف.",
        englishMessage:
        "Please enable location permission manually from settings.");
    return false;
  }

  return true;
}
