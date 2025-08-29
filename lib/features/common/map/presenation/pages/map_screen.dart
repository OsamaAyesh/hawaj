import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../controller/map_controller.dart';
import '../widgets/location_error_widget.dart';
import '../widgets/menu_icon_button.dart';
import '../widgets/notfication_icon_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final controller = Get.find<MapController>();
  Set<Marker> customMarkers = {};

  @override
  void initState() {
    super.initState();
    _checkAndLoadLocation();
  }

  /// ====== Check permissions and request them if necessary
  Future<void> _checkAndLoadLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      await controller.loadCurrentLocation();
      _initMarkers();
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// ====== Make sure GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackbar.warning("رجاءً قم بتفعيل خدمة الموقع من الإعدادات.",
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
              "Please enable location permission manually from the phone settings.");
      return false;
    }

    return true;
  }

  Future<void> _initMarkers() async {
    final location = controller.currentLocation.value;
    if (location == null) return;

    final restaurantIcon =
        await _createCustomMarker(Icons.restaurant, Colors.deepPurple);
    final cafeIcon =
        await _createCustomMarker(Icons.local_cafe, Colors.deepPurple);
    final storeIcon = await _createCustomMarker(Icons.store, Colors.deepPurple);

    setState(() {
      customMarkers = {
        Marker(
          markerId: const MarkerId("restaurant"),
          position:
              LatLng(location.latitude + 0.001, location.longitude + 0.001),
          icon: restaurantIcon,
          infoWindow: const InfoWindow(title: "مطعم شرقي"),
        ),
        Marker(
          markerId: const MarkerId("cafe"),
          position:
              LatLng(location.latitude - 0.001, location.longitude - 0.001),
          icon: cafeIcon,
          infoWindow: const InfoWindow(title: "مقهى"),
        ),
        Marker(
          markerId: const MarkerId("store"),
          position:
              LatLng(location.latitude + 0.002, location.longitude - 0.001),
          icon: storeIcon,
          infoWindow: const InfoWindow(title: "سوبر ماركت"),
        ),
      };
    });
  }

 /// Create a custom marker
  Future<BitmapDescriptor> _createCustomMarker(
      IconData icon, Color background) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 120;

    final Paint paint = Paint()..color = background;
    final Path path = Path();
    path.moveTo(size / 2, size);
    path.quadraticBezierTo(size, size * 0.6, size / 2, 0);
    path.quadraticBezierTo(0, size * 0.6, size / 2, size);
    canvas.drawPath(path, paint);

    final Paint whiteCircle = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size / 2, size * 0.45), size * 0.18, whiteCircle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size * 0.25,
          fontFamily: icon.fontFamily,
          color: background,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((size - textPainter.width) / 2,
            (size * 0.45 - textPainter.height / 2)));

    final img =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final location = controller.currentLocation.value;
        if (location == null) {
          return LocationErrorWidget(
            onRetry: _checkAndLoadLocation,
          );
        }

        final LatLng currentLatLng =
            LatLng(location.latitude, location.longitude);

        return SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLatLng,
                  zoom: 14,
                ),
                myLocationEnabled: true,
                markers: customMarkers,
                trafficEnabled: false,
                compassEnabled: false,
                buildingsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController mapController) async {
                  String style = await DefaultAssetBundle.of(context)
                      .loadString('assets/json/style_map.json');
                  mapController.setMapStyle(style);
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ManagerWidth.w16,
                  right: ManagerWidth.w16,
                  top: ManagerHeight.h24,
                ),
                child: Row(
                  children: [
                    MenuIconButton(onPressed: () {}),
                    const Spacer(),
                    NotificationIconButton(
                      onPressed: () {},
                      showDot: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _openVoiceAssistant(context),
                    child: const SiriMicButton(),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _openVoiceAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ManagerColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.close, color: Colors.white),
                  Icon(Icons.open_in_full, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "تمام، خليني أضبطلك الأطيب.. بس قبل هيك بتحب تختار من الجري والسلطات، ولا نفسك بالأكل الشرقي المشبع؟",
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Center(child: SiriMicButton(size: 60)),
            ],
          ),
        );
      },
    );
  }
}

class SiriMicButton extends StatefulWidget {
  final double size;

  const SiriMicButton({super.key, this.size = 80});

  @override
  State<SiriMicButton> createState() => _SiriMicButtonState();
}

class _SiriMicButtonState extends State<SiriMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// ===== Waves (animated circles like Siri)
              ...List.generate(3, (index) {
                double progress =
                    (_controller.value + (index * 0.3)) % 1.0; // waves offset
                double scale = 1 + (progress * 1.5);
                double opacity = (1 - progress).clamp(0.0, 1.0);

                return Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size * scale,
                    height: widget.size * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ManagerColors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                );
              }),

              /// ============ Main microphone button
              Container(
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ManagerColors.primaryColor,
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 36),
              ),
            ],
          ),
        );
      },
    );
  }
}
