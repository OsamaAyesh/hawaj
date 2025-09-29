import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../controller/map_ticker_controller.dart';
import '../widgets/custom_google_map_widget.dart';

class MapTickerScreen extends StatefulWidget {
  const MapTickerScreen({super.key});

  @override
  State<MapTickerScreen> createState() => _MapTickerScreenState();
}

class _MapTickerScreenState extends State<MapTickerScreen> {
  late MapTickerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MapTickerController>();
    controller.loadCurrentLocation();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          ManagerStrings.errorTitle.tr,
          ManagerStrings.locationPermissionDenied.tr,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Get.snackbar(
      //   ManagerStrings.errorTitle.tr,
      //   ManagerStrings.locationPermissionDeniedForever.tr,
      // );
      return;
    }

    // إذا الأمور تمام → جلب الموقع
    controller.loadCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: ScaffoldWithBackButton(
        title: ManagerStrings.setLocationTitle.tr,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget();
          }

          final location = controller.currentLocation.value;
          if (location == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ManagerStrings.setLocationError.tr,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _checkLocationPermission,
                    icon: const Icon(Icons.location_on,
                        color: ManagerColors.primaryColor),
                    label: Text(
                      ManagerStrings.retryLocation.tr,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final LatLng latLng = LatLng(location.latitude, location.longitude);

          return Stack(
            children: [
              CustomGoogleMapWidget(
                initialPosition: CameraPosition(target: latLng, zoom: 15),
                markerPosition: latLng,
                onTap: (pos) {
                  controller.updateSelectedLocation(
                      pos.latitude, pos.longitude);
                },
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle,
                      color: ManagerColors.primaryColor),
                  label: Text(
                    ManagerStrings.setLocationConfirm.tr,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                  onPressed: () {
                    if (kDebugMode) {
                      print(location.latitude);
                      print(location.longitude);
                    }
                    Navigator.pop(context, controller.currentLocation.value);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
