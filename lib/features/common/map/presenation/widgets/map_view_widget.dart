import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Widget للخريطة مع تحسينات الأداء
class MapViewWidget extends StatelessWidget {
  final dynamic location;
  final Function(GoogleMapController) onMapCreated;
  final Set<Marker> markers;
  final Function(LatLng)? onTap;

  const MapViewWidget({
    super.key,
    required this.location,
    required this.onMapCreated,
    required this.markers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng center = LatLng(
      location.latitude,
      location.longitude,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 14.5,
      ),
      onMapCreated: onMapCreated,
      onTap: onTap,
      markers: markers,

      // ===== تحسينات الأداء =====
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      // نستخدم زر مخصص
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      trafficEnabled: false,
      buildingsEnabled: true,
      // إظهار المباني للواقعية
      indoorViewEnabled: false,

      // ===== تحسين السلاسة =====
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,

      // ===== الحد الأدنى والأقصى للـ Zoom =====
      minMaxZoomPreference: const MinMaxZoomPreference(10, 20),

      // ===== Padding لتجنب تداخل العناصر =====
      padding: const EdgeInsets.only(
        top: 100,
        bottom: 80,
      ),
    );
  }
}
