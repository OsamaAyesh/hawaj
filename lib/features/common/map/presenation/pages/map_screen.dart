import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../controller/drawer_controller.dart';
import '../controller/map_controller.dart';
import '../controller/map_sections_controller.dart';
import '../managers/marker_icon_manager.dart';
import '../managers/permission_manager.dart';
import '../widgets/improved_drawer_widget.dart';
import '../widgets/map_top_bar_widget.dart';
import '../widgets/map_view_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapC = Get.find<MapController>();
  final sectionsC = Get.find<MapSectionsController>();
  final drawerC = Get.find<MapDrawerController>();

  final GlobalKey<SliderDrawerState> _sliderKey =
      GlobalKey<SliderDrawerState>();
  final MarkerIconManager _iconManager = MarkerIconManager();

  GoogleMapController? _mapController;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _initializeMap();
  }

  /// Make status & navigation bars transparent
  void _setupSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  Future<void> _initializeMap() async {
    await _iconManager.initialize();
    final permission = await PermissionManager.handleLocationPermission();

    if (permission.granted) {
      await mapC.loadCurrentLocation();
      setState(() => _isMapReady = true);
    } else if (mounted && permission.message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(permission.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: SliderDrawer(
            key: _sliderKey,
            appBar: AppBar(),
            sliderOpenSize: 280,
            slideDirection: SlideDirection.rightToLeft,
            isDraggable: false,
            slider: Obx(() {
              final userData = drawerC.userData.value;
              return AppDrawer(
                sliderKey: _sliderKey,
                userName: userData?.name ?? 'مستخدم',
                role: userData?.role ?? 'جديد',
                phone: userData?.phone ?? '',
                avatar: userData?.avatar ?? "",
              );
            }),
            child: Obx(() {
              if (mapC.isLoading.value && mapC.currentLocation.value == null) {
                return const Center(child: LoadingWidget());
              }

              final location = mapC.currentLocation.value;
              if (location == null) return _buildLocationError();

              return Stack(
                children: [
                  // ===== Google Map =====
                  MapViewWidget(
                    location: location,
                    onMapCreated: (controller) async {
                      _mapController = controller;
                      final style = await rootBundle
                          .loadString('assets/json/style_map.json');
                      controller.setMapStyle(style);
                    },
                    markers: _buildMarkers(location),
                  ),

                  // ===== Custom Top Bar =====
                  Positioned(
                    top: ManagerHeight.h48,
                    left: ManagerWidth.w16,
                    right: ManagerWidth.w16,
                    child: MapTopBar(
                      onMenuPressed: () => _sliderKey.currentState?.toggle(),
                      onNotificationPressed: () {},
                      hasNotifications: true,
                    ),
                  ),

                  // ===== Loading Overlay for sections =====
                  if (sectionsC.isCurrentSectionLoading)
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            }),
          ),
        ).withHawaj(
          screen: HawajScreens.map,
          section: HawajSections.dailyOffers,
        ),
      ),
    );
  }

  /// Build markers dynamically
  Set<Marker> _buildMarkers(dynamic location) {
    final markers = <Marker>{};
    final data = sectionsC.currentSectionData;

    for (int i = 0; i < data.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('item_$i'),
          position: LatLng(
            location.latitude + (i * 0.001),
            location.longitude + (i * 0.001),
          ),
          icon: _iconManager.defaultIcon,
        ),
      );
    }
    return markers;
  }

  /// Location error widget
  Widget _buildLocationError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'فشل في تحديد الموقع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى التحقق من إعدادات الموقع',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initializeMap,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ManagerColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_width.dart';
// import '../../../../../core/widgets/loading_widget.dart';
// import '../controller/drawer_controller.dart';
// import '../controller/map_ticker_controller.dart';
// import '../controller/map_sections_controller.dart';
// import '../managers/marker_icon_manager.dart';
// import '../managers/permission_manager.dart';
// import '../widgets/drawer_widget.dart';
// import '../widgets/map_top_bar_widget.dart';
// import '../widgets/map_view_widget.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final mapC = Get.find<MapController>();
//   final sectionsC = Get.find<MapSectionsController>();
//   final drawerC = Get.find<MapDrawerController>(); // ✅ تأكد من الاسم الصحيح
//
//   final GlobalKey<SliderDrawerState> _sliderKey =
//       GlobalKey<SliderDrawerState>();
//   final MarkerIconManager _iconManager = MarkerIconManager();
//
//   GoogleMapController? _mapController;
//   bool _isMapReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupUI();
//     _initializeMap();
//   }
//
//   void _setupUI() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//   }
//
//   Future<void> _initializeMap() async {
//     // تهيئة أيقونات الـ Markers
//     await _iconManager.initialize();
//
//     // طلب إذن الموقع
//     final permission = await PermissionManager.handleLocationPermission();
//
//     if (permission.granted) {
//       await mapC.loadCurrentLocation();
//       setState(() => _isMapReady = true);
//     } else {
//       // عرض رسالة خطأ
//       if (mounted && permission.message != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(permission.message!)),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final topInset = MediaQuery.of(context).padding.top;
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: SliderDrawer(
//         key: _sliderKey,
//         sliderOpenSize: 280,
//         slideDirection: SlideDirection.rightToLeft,
//         isDraggable: false,
//         slider: Obx(() {
//           final userData = drawerC.userData.value;
//           return AppDrawer(
//             sliderKey: _sliderKey,
//             userName: userData?.name ?? 'مستخدم',
//             role: userData?.role ?? 'جديد',
//             phone: userData?.phone ?? '',
//             // isLoading: drawerC.isLoading.value,
//           );
//         }),
//         child: Obx(() {
//           // حالة التحميل الأولي
//           if (mapC.isLoading.value && mapC.currentLocation.value == null) {
//             return const Center(child: LoadingWidget());
//           }
//
//           final location = mapC.currentLocation.value;
//
//           // حالة عدم وجود موقع
//           if (location == null) {
//             return _buildLocationError();
//           }
//
//           return Stack(
//             children: [
//               // ===== الخريطة =====
//               MapViewWidget(
//                 location: location,
//                 onMapCreated: (controller) async {
//                   _mapController = controller;
//                   final style = await rootBundle.loadString(
//                     'assets/json/style_map.json',
//                   );
//                   controller.setMapStyle(style);
//                 },
//                 markers: _buildMarkers(location),
//                 onTap: (position) {
//                   // يمكن إضافة منطق عند الضغط على الخريطة
//                 },
//               ),
//
//               // ===== شريط العلوي =====
//               Positioned(
//                 top: ManagerHeight.h20,
//                 left: ManagerWidth.w16,
//                 right: ManagerWidth.w16,
//                 child: MapTopBar(
//                   onMenuPressed: () => _sliderKey.currentState?.toggle(),
//                   onNotificationPressed: () {},
//                   hasNotifications: true,
//                 ),
//               ),
//
//               // ===== Loading Overlay للأقسام =====
//               if (sectionsC.isCurrentSectionLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.1),
//                   child: const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   /// بناء الـ Markers حسب القسم الحالي
//   Set<Marker> _buildMarkers(dynamic location) {
//     final markers = <Marker>{};
//     final data = sectionsC.currentSectionData;
//
//     // TODO: بناء الـ Markers حسب نوع البيانات
//     // مثال مؤقت:
//     for (int i = 0; i < data.length; i++) {
//       markers.add(
//         Marker(
//           markerId: MarkerId('item_$i'),
//           position: LatLng(
//             location.latitude + (i * 0.001),
//             location.longitude + (i * 0.001),
//           ),
//           icon: _iconManager.defaultIcon,
//           onTap: () {
//             // TODO: فتح تفاصيل العنصر
//           },
//         ),
//       );
//     }
//
//     return markers;
//   }
//
//   /// شاشة خطأ الموقع
//   Widget _buildLocationError() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.location_off,
//             size: 64,
//             color: Colors.red,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'فشل في تحديد الموقع',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'يرجى التحقق من إعدادات الموقع',
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _initializeMap,
//             icon: const Icon(Icons.refresh),
//             label: const Text('إعادة المحاولة'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ManagerColors.primaryColor,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }
// }
//
// // import 'dart:typed_data';
// // import 'dart:ui' as ui;
// // import 'package:app_mobile/core/resources/manager_height.dart';
// // import 'package:app_mobile/core/resources/manager_radius.dart';
// // import 'package:app_mobile/core/resources/manager_width.dart';
// // import 'package:app_mobile/core/util/snack_bar.dart';
// // import 'package:app_mobile/features/users/offer_user/company_with_offer/presentation/pages/company_with_offer_screen.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// // import 'package:speech_to_text/speech_to_text.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:confetti/confetti.dart';
// //
// // import '../../../../../constants/constants/constants.dart';
// // import '../../../../../core/resources/manager_colors.dart';
// // import '../../../../../core/resources/manager_font_size.dart';
// // import '../../../../../core/resources/manager_styles.dart';
// // import '../../../../../core/widgets/loading_widget.dart';
// // import '../../../../users/offer_user/company_with_offer/domain/di/di.dart';
// // import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
// // import '../controller/map_ticker_controller.dart';
// // import '../widgets/drawer_widget.dart';
// // import '../widgets/handel_permission_function.dart';
// // import '../widgets/location_error_widget.dart';
// // import '../widgets/manager_drawer_items.dart';
// // import '../widgets/menu_icon_button.dart';
// // import '../widgets/notfication_icon_button.dart';
// //
// // // 👇 import كونترولر العروض (عدّل المسار حسب مشروعك)
// // import 'package:app_mobile/features/users/offer_user/list_offers/domain/model/offer_user_item_model.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   const MapScreen({super.key});
// //
// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
// //   final mapC = Get.find<MapController>();
// //   final offersC = Get.find<OffersController>();
// //
// //   final GlobalKey<SliderDrawerState> _sliderKey =
// //       GlobalKey<SliderDrawerState>();
// //   final SpeechToText _speechToText = SpeechToText();
// //   final ConfettiController _confettiController =
// //       ConfettiController(duration: const Duration(seconds: 2));
// //
// //   GoogleMapController? _gmc;
// //
// //   bool _isListening = false;
// //   bool _speechEnabled = false;
// //   bool _permissionGranted = false;
// //   String _recognizedText = "";
// //   List<double> _audioLevels = List.generate(20, (index) => 0.0);
// //   late AnimationController _waveController;
// //
// //   // ====== Marker icons cache (per-offer) ======
// //   final Map<int, BitmapDescriptor> _offerIconCache = {};
// //   BitmapDescriptor? _defaultOfferIcon;
// //
// //   // لإخفاء زر المايك وقت ظهور التفاصيل
// //   bool _detailsOpen = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
// //     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
// //       statusBarColor: Colors.transparent,
// //       systemNavigationBarColor: Colors.transparent,
// //       statusBarIconBrightness: Brightness.dark,
// //       statusBarBrightness: Brightness.light,
// //     ));
// //
// //     _waveController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 800),
// //     )..repeat();
// //
// //     _initDefaultMarkerIcon(); // default icon (primary)
// //     _checkAndLoadLocation();
// //     _initSpeech();
// //
// //     // جلب العروض الأولية
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       offersC.fetchOffers();
// //     });
// //   }
// //
// //   Future<void> _initDefaultMarkerIcon() async {
// //     _defaultOfferIcon =
// //         await _createPrimaryPinMarker(iconData: Icons.local_offer);
// //     if (mounted) setState(() {});
// //   }
// //
// //   Future<void> _checkAndLoadLocation() async {
// //     final hasPermission = await handleLocationPermission();
// //     if (hasPermission) {
// //       await mapC.loadCurrentLocation();
// //       setState(() {});
// //     }
// //   }
// //
// //   /// ====== Speech
// //   Future<void> _initSpeech() async {
// //     final status = await Permission.microphone.request();
// //     if (status.isGranted) {
// //       setState(() => _permissionGranted = true);
// //       _speechEnabled = await _speechToText.initialize(
// //         onStatus: (status) {
// //           if (status == 'notListening' && _isListening) {
// //             setState(() {
// //               _isListening = false;
// //               if (_recognizedText.isNotEmpty) {
// //                 _confettiController.play();
// //               }
// //             });
// //           }
// //         },
// //         onError: (error) => debugPrint('Speech error: $error'),
// //       );
// //       setState(() {});
// //     } else {
// //       debugPrint('Microphone permission denied');
// //     }
// //   }
// //
// //   Future<void> _startListening() async {
// //     if (!_permissionGranted) {
// //       final status = await Permission.microphone.request();
// //       if (!status.isGranted) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('يجب منح إذن الميكروفون')),
// //           );
// //         }
// //         return;
// //       } else {
// //         setState(() => _permissionGranted = true);
// //         await _initSpeech();
// //       }
// //     }
// //
// //     setState(() => _recognizedText = "");
// //
// //     if (_speechEnabled) {
// //       await _speechToText.listen(
// //         onResult: (r) => setState(() => _recognizedText = r.recognizedWords),
// //         localeId: "ar-SA",
// //         onSoundLevelChange: (level) {
// //           setState(() {
// //             _audioLevels.removeAt(0);
// //             _audioLevels.add(level);
// //           });
// //         },
// //       );
// //       setState(() => _isListening = true);
// //     } else {
// //       await _initSpeech();
// //       if (_speechEnabled) await _startListening();
// //     }
// //   }
// //
// //   void _stopListening() async {
// //     await _speechToText.stop();
// //     setState(() {
// //       _isListening = false;
// //       if (_recognizedText.isNotEmpty) _confettiController.play();
// //     });
// //   }
// //
// //   // ====== Markers ======
// //
// //   // بما أنه لسا ما في إحداثيات للعرض من API، نوزّعها قرب المستخدم (Placeholder)
// //   LatLng _fakePositionForIndex(LatLng base, int i) {
// //     final double d = 0.00035 * ((i % 4) + 1);
// //     switch (i % 6) {
// //       case 0:
// //         return LatLng(base.latitude + d, base.longitude + d);
// //       case 1:
// //         return LatLng(base.latitude - d, base.longitude + d);
// //       case 2:
// //         return LatLng(base.latitude + d, base.longitude - d);
// //       case 3:
// //         return LatLng(base.latitude - d, base.longitude - d);
// //       case 4:
// //         return LatLng(base.latitude, base.longitude + d);
// //       default:
// //         return LatLng(base.latitude + d, base.longitude);
// //     }
// //   }
// //
// //   Future<void> _ensureOfferMarkerIcon(OfferUserItemModel o) async {
// //     // لو موجودة جاهزة خلاص
// //     if (_offerIconCache.containsKey(o.id)) return;
// //
// //     // 1) حطّ Placeholder فوري (بدون صورة)
// //     _offerIconCache[o.id] =
// //         await _createPrimaryPinMarker(iconData: Icons.local_offer);
// //     if (mounted) setState(() {}); // حتى تظهر الماركر فورًا
// //
// //     // 2) لو في صورة — حمّلها بالخلفية وحسّن الأيقونة بعدين
// //     final hasImage = o.productImages.isNotEmpty;
// //     if (!hasImage) return;
// //
// //     // خذ أول صورة من القائمة
// //     final String firstImage = o.productImages;
// //
// //     // ابنِ الرابط الصحيح
// //     final String url = "${Constants.baseUrlAttachments}/$firstImage";
// //
// //     try {
// //       final iconWithImage = await _createPrimaryPinMarker(imageUrl: url);
// //       // نجح التحميل: حدث الكاش وحرّك UI
// //       _offerIconCache[o.id] = iconWithImage;
// //       if (mounted) setState(() {});
// //     } catch (_) {
// //       // فشل التحميل: خليك على الـ placeholder (ولا تعمل شيء)
// //     }
// //   }
// //
// //   Set<Marker> _buildOfferMarkers(LatLng center) {
// //     final set = <Marker>{};
// //     final list = offersC.offers;
// //
// //     for (int i = 0; i < list.length; i++) {
// //       final o = list[i];
// //       _ensureOfferMarkerIcon(o); // async (يحدّث لما تجهز)
// //
// //       final icon = _offerIconCache[o.id] ?? _defaultOfferIcon;
// //
// //       set.add(
// //         Marker(
// //           markerId: MarkerId('offer_${o.id}'),
// //           position: _fakePositionForIndex(center, i),
// //           icon: icon ?? _defaultOfferIcon ?? BitmapDescriptor.defaultMarker,
// //           anchor: const Offset(0.5, 1.0),
// //           // رأس الـpin على الإحداثي
// //           onTap: () => _openOfferDetails(o),
// //         ),
// //       );
// //     }
// //     return set;
// //   }
// //
// //   // ====== Offer Details Popup ======
// //   Future<void> _openOfferDetails(OfferUserItemModel o) async {
// //     setState(() => _detailsOpen = true);
// //
// //     await showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       barrierColor: Colors.black54,
// //       builder: (_) {
// //         return _OfferDetailsSheet(
// //           offer: o,
// //           onOrgPressed: () {
// //             Navigator.pop(context);
// //             AppSnackbar.success("سيتم فتح تفاصيل المنظمة لاحقاً");
// //             initGetCompany();
// //             Get.to(CompanyWithOfferScreen(idOrganization: o.id,));
// //           },
// //           onClose: () => Navigator.pop(context),
// //         );
// //       },
// //     );
// //
// //     if (mounted) setState(() => _detailsOpen = false);
// //   }
// //
// //   // ====== Marker Drawing (Primary pin + optional image) ======
// //   Future<BitmapDescriptor> _createPrimaryPinMarker({
// //     String? imageUrl,
// //     IconData? iconData,
// //     double size = 110, // أصغر قليلاً لتقليل الزحمة
// //   }) async {
// //     final recorder = ui.PictureRecorder();
// //     final canvas = Canvas(recorder);
// //     final Color primary = ManagerColors.primaryColor;
// //
// //     // ===== شكل الـ Pin مع تدرّج خفيف =====
// //     final Path pinPath = Path()
// //       ..moveTo(size / 2, size)
// //       ..quadraticBezierTo(size, size * 0.55, size / 2, 0)
// //       ..quadraticBezierTo(0, size * 0.55, size / 2, size);
// //
// //     // ظل ناعم حول الـPin
// //     canvas.drawShadow(pinPath, Colors.black45, 6, false);
// //
// //     // تدرّج رأسي للّون الأساسي
// //     final rect = Rect.fromLTWH(0, 0, size, size);
// //     final gradient = ui.Gradient.linear(
// //       Offset(0, 0),
// //       Offset(0, size),
// //       [primary.withOpacity(.95), primary],
// //     );
// //     canvas.drawPath(pinPath, Paint()..shader = gradient);
// //
// //     // ظل بيضاوي صغير أسفل الرأس يعطي عمق بسيط
// //     final dropShadowOval = Rect.fromCenter(
// //       center: Offset(size / 2, size * 0.965),
// //       width: size * 0.28,
// //       height: size * 0.08,
// //     );
// //     canvas.drawOval(
// //       dropShadowOval,
// //       Paint()..color = Colors.black.withOpacity(0.08),
// //     );
// //
// //     // ===== الدائرة الداخلية =====
// //     final double r = size * 0.22;
// //     final Offset c = Offset(size / 2, size * 0.42);
// //
// //     // قرص أبيض + حافة (Stroke) لتحديدها
// //     canvas.drawCircle(c, r, Paint()..color = Colors.white);
// //     canvas.drawCircle(
// //       c,
// //       r,
// //       Paint()
// //         ..style = PaintingStyle.stroke
// //         ..strokeWidth = 2
// //         ..color = Colors.white.withOpacity(.9),
// //     );
// //
// //     // محتوى الدائرة: صورة شبكة أو أيقونة
// //     if (imageUrl != null && imageUrl.isNotEmpty) {
// //       try {
// //         final bytes =
// //             await _loadNetworkBytes(imageUrl); // تأكد أنها تستدعي .load(url)
// //         final codec = await ui.instantiateImageCodec(
// //           bytes,
// //           targetWidth: (r * 2).toInt(),
// //           targetHeight: (r * 2).toInt(),
// //         );
// //         final frame = await codec.getNextFrame();
// //         final img = frame.image;
// //
// //         final clipRect = Rect.fromCircle(center: c, radius: r - 2);
// //         canvas.save();
// //         canvas.clipPath(Path()..addOval(clipRect));
// //         canvas.drawImageRect(
// //           img,
// //           Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
// //           clipRect,
// //           Paint(),
// //         );
// //         canvas.restore();
// //       } catch (_) {
// //         // فشل تحميل الصورة -> fallback على أيقونة باللون الأبيض
// //         _drawCenterIcon(
// //             canvas, c, r, iconData ?? Icons.local_offer, Colors.white);
// //       }
// //     } else {
// //       _drawCenterIcon(
// //           canvas, c, r, iconData ?? Icons.local_offer, Colors.white);
// //     }
// //
// //     // لمعة خفيفة (gloss) من الأعلى
// //     final gloss = Path()
// //       ..addOval(Rect.fromCircle(
// //           center: Offset(size / 2, size * 0.18), radius: size * 0.16));
// //     canvas.drawPath(gloss, Paint()..color = Colors.white.withOpacity(.08));
// //
// //     // ===== إخراج الصورة =====
// //     final img =
// //         await recorder.endRecording().toImage(size.toInt(), size.toInt());
// //     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
// //     return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
// //   }
// //
// //   void _drawCenterIcon(
// //       Canvas canvas, Offset center, double radius, IconData icon, Color color) {
// //     final tp = TextPainter(
// //       text: TextSpan(
// //         text: String.fromCharCode(icon.codePoint),
// //         style: TextStyle(
// //           fontSize: radius * 1.4,
// //           fontFamily: icon.fontFamily,
// //           color: color, // استخدم اللون المُمرَّر
// //           package: icon.fontPackage,
// //         ),
// //       ),
// //       textDirection: TextDirection.ltr,
// //     )..layout();
// //     tp.paint(
// //         canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
// //   }
// //
// //   Future<Uint8List> _loadNetworkBytes(String url) async {
// //     final bd = await NetworkAssetBundle(Uri.parse(url)).load("");
// //     return bd.buffer.asUint8List();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _waveController.dispose();
// //     _confettiController.dispose();
// //     _speechToText.stop();
// //     super.dispose();
// //   }
// //
// //   final visibilityManager = DrawerVisibilityManager(enabled: {
// //     DrawerFeatures.userProfile,
// //     DrawerFeatures.userDailyOffers,
// //     DrawerFeatures.userDelivery,
// //     DrawerFeatures.providerManageOffers,
// //     DrawerFeatures.providerManageContracts,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final userItems = visibilityManager.buildUserItems();
// //     final providerItems = visibilityManager.buildProviderItems();
// //     final topInset = MediaQuery.of(context).padding.top;
// //     final bottomInset = MediaQuery.of(context).padding.bottom; // ✅ هذا الصح
// //
// //     return MediaQuery.removePadding(
// //       context: context,
// //       removeTop: true,
// //       removeBottom: true,
// //       child: AnnotatedRegion<SystemUiOverlayStyle>(
// //         value: const SystemUiOverlayStyle(
// //           statusBarColor: Colors.transparent,
// //           statusBarIconBrightness: Brightness.dark,
// //           statusBarBrightness: Brightness.light,
// //         ),
// //         child: Scaffold(
// //           extendBodyBehindAppBar: true,
// //           body: SliderDrawer(
// //             key: _sliderKey,
// //             sliderOpenSize: 250,
// //             appBar: AppBar(
// //               backgroundColor: Colors.transparent,
// //               automaticallyImplyLeading: false,
// //             ),
// //             backgroundColor: Colors.transparent,
// //             slideDirection: SlideDirection.rightToLeft,
// //             slider: AppDrawer(
// //               sliderKey: _sliderKey,
// //               userName: "عبدالله الدحو/اني",
// //               role: "مستخدم جديد",
// //               phone: "0599999999",
// //               userItems: userItems,
// //               providerItems: providerItems,
// //             ),
// //             child: Obx(() {
// //               if (mapC.isLoading.value && mapC.currentLocation.value == null) {
// //                 return const Center(child: LoadingWidget());
// //               }
// //
// //               final location = mapC.currentLocation.value;
// //               if (location == null) {
// //                 return LocationErrorWidget(onRetry: _checkAndLoadLocation);
// //               }
// //
// //               final LatLng currentLatLng =
// //                   LatLng(location.latitude, location.longitude);
// //
// //               final markers = _buildOfferMarkers(currentLatLng);
// //
// //               return Stack(
// //                 children: [
// //                   // الخريطة Fullscreen
// //                   Positioned.fill(
// //                     child: GoogleMap(
// //                       initialCameraPosition:
// //                           CameraPosition(target: currentLatLng, zoom: 14),
// //                       onMapCreated: (mc) async {
// //                         _gmc = mc;
// //                         final style = await DefaultAssetBundle.of(context)
// //                             .loadString('assets/json/style_map.json');
// //                         mc.setMapStyle(style);
// //                       },
// //                       myLocationEnabled: true,
// //                       myLocationButtonEnabled: false,
// //                       trafficEnabled: false,
// //                       compassEnabled: false,
// //                       buildingsEnabled: false,
// //                       mapToolbarEnabled: false,
// //                       markers: markers,
// //                       onTap: (_) {
// //                         // اغلق أي تفاصيل مفتوحة
// //                         if (_detailsOpen) Navigator.maybePop(context);
// //                       },
// //                     ),
// //                   ),
// //
// //                   // شريط علوي (منيو + إشعارات)
// //                   Positioned(
// //                     left: ManagerWidth.w16,
// //                     right: ManagerWidth.w16,
// //                     top: topInset + ManagerHeight.h12,
// //                     child: Row(
// //                       children: [
// //                         MenuIconButton(
// //                             onPressed: () => _sliderKey.currentState?.toggle()),
// //                         const Spacer(),
// //                         NotificationIconButton(onPressed: () {}, showDot: true),
// //                       ],
// //                     ),
// //                   ),
// //
// //                   // Loading Overlay للعروض (عند جلبها)
// //                   Obx(() {
// //                     return AnimatedSwitcher(
// //                       duration: const Duration(milliseconds: 250),
// //                       child: offersC.isLoading.value
// //                           ? Container(
// //                               key: const ValueKey('loading'),
// //                               color: Colors.black.withOpacity(0.12),
// //                               child: const Center(
// //                                   child: CircularProgressIndicator()),
// //                             )
// //                           : const SizedBox.shrink(key: ValueKey('idle')),
// //                     );
// //                   }),
// //
// //                   // الكونفيتي
// //                   Align(
// //                     alignment: Alignment.topCenter,
// //                     child: ConfettiWidget(
// //                       confettiController: _confettiController,
// //                       blastDirectionality: BlastDirectionality.explosive,
// //                       shouldLoop: false,
// //                       colors: const [
// //                         Colors.green,
// //                         Colors.blue,
// //                         Colors.pink,
// //                         Colors.orange,
// //                         Colors.purple,
// //                       ],
// //                     ),
// //                   ),
// //
// //                   // زر المساعد الصوتي (يختفي أثناء فتح التفاصيل لتفادي أي تداخل/Overflow)
// //                   if (!_detailsOpen)
// //                     Positioned(
// //                       bottom: (bottomInset > 0 ? bottomInset : 16) + 8,
// //                       left: 0,
// //                       right: 0,
// //                       child: Center(
// //                         child: GestureDetector(
// //                           onTap: _startListening,
// //                           child: VoiceAssistantButton(
// //                             isListening: _isListening,
// //                             audioLevels: _audioLevels,
// //                             waveController: _waveController,
// //                             onTap: _startListening,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                 ],
// //               );
// //             }),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // /// ====== Offer Details Bottom Sheet (Popup) ======
// // class _OfferDetailsSheet extends StatefulWidget {
// //   final OfferUserItemModel offer;
// //   final VoidCallback onOrgPressed;
// //   final VoidCallback onClose;
// //
// //   const _OfferDetailsSheet({
// //     required this.offer,
// //     required this.onOrgPressed,
// //     required this.onClose,
// //   });
// //
// //   @override
// //   State<_OfferDetailsSheet> createState() => _OfferDetailsSheetState();
// // }
// //
// // class _OfferDetailsSheetState extends State<_OfferDetailsSheet>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _anim = AnimationController(
// //     vsync: this,
// //     duration: const Duration(milliseconds: 280),
// //   )..forward();
// //   late final Animation<double> _scale =
// //       CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
// //
// //   @override
// //   void dispose() {
// //     _anim.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final o = widget.offer;
// //
// //     return SafeArea(
// //       top: false,
// //       child: ScaleTransition(
// //         scale: _scale,
// //         child: Container(
// //           margin: const EdgeInsets.symmetric(horizontal: 12),
// //           padding: const EdgeInsets.only(bottom: 12),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //             boxShadow: [
// //               BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 20)
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Handle + Close
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 10, bottom: 6),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Container(
// //                         width: 42,
// //                         height: 5,
// //                         decoration: BoxDecoration(
// //                           color: Colors.black12,
// //                           borderRadius: BorderRadius.circular(6),
// //                         )),
// //                     const Spacer(),
// //                     IconButton(
// //                         onPressed: widget.onClose,
// //                         icon: const Icon(Icons.close)),
// //                   ],
// //                 ),
// //               ),
// //
// //               if (o.productImages.isNotEmpty)
// //                 AspectRatio(
// //                   aspectRatio: 16 / 9,
// //                   child: Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(ManagerRadius.r4),
// //                       child: CachedNetworkImage(
// //                         imageUrl:
// //                             "${Constants.baseUrlAttachments}/${o.productImages}",
// //                         fit: BoxFit.cover,
// //                         placeholder: (context, url) => const Center(
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         ),
// //                         errorWidget: (context, url, error) => Container(
// //                           color: Colors.grey.shade200,
// //                           child: const Icon(Icons.broken_image,
// //                               size: 48, color: Colors.grey),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               else
// //                 Container(
// //                   height: 160,
// //                   margin: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(14),
// //                     color: Colors.grey.shade200,
// //                   ),
// //                   child: const Center(child: Icon(Icons.local_offer, size: 48)),
// //                 ),
// //
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: Text(
// //                         o.productName,
// //                         style: getBoldTextStyle(
// //                             fontSize: ManagerFontSize.s18, color: Colors.black),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: ManagerColors.primaryColor.withOpacity(.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Text(
// //                         "${o.offerPrice}",
// //                         style: getBoldTextStyle(
// //                             fontSize: ManagerFontSize.s14,
// //                             color: ManagerColors.primaryColor),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Align(
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     o.offerDescription,
// //                     style: getRegularTextStyle(
// //                         fontSize: ManagerFontSize.s14, color: Colors.black87),
// //                     textAlign: TextAlign.start,
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 8),
// //
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.calendar_today, size: 16),
// //                     const SizedBox(width: 6),
// //                     Expanded(
// //                       child: Text(
// //                         "${o.offerStartDate}  →  ${o.offerEndDate}",
// //                         style: getRegularTextStyle(
// //                             fontSize: ManagerFontSize.s12,
// //                             color: Colors.black54),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 12),
// //
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: ManagerColors.primaryColor,
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(ManagerRadius.r4)),
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                     ),
// //                     onPressed: widget.onOrgPressed,
// //                     icon: const Icon(Icons.business_outlined),
// //                     label: Text(
// //                       "تفاصيل المنظمة",
// //                       style: getBoldTextStyle(
// //                         fontSize: ManagerFontSize.s12,
// //                         color: ManagerColors.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class VoiceAssistantButton extends StatelessWidget {
// //   final bool isListening;
// //   final List<double> audioLevels;
// //   final AnimationController waveController;
// //   final VoidCallback onTap;
// //
// //   const VoiceAssistantButton({
// //     super.key,
// //     required this.isListening,
// //     required this.audioLevels,
// //     required this.waveController,
// //     required this.onTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: waveController,
// //       builder: (context, child) {
// //         return GestureDetector(
// //           onTap: onTap,
// //           child: Container(
// //             width: 80,
// //             height: 80,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: ManagerColors.primaryColor,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: ManagerColors.primaryColor.withOpacity(0.4),
// //                   blurRadius: 10,
// //                   spreadRadius: isListening ? 5 : 0,
// //                 ),
// //               ],
// //             ),
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 ...List.generate(3, (index) {
// //                   final progress =
// //                       ((waveController.value + (index * 0.3)) % 1.0);
// //                   final waveSize = 80 +
// //                       (progress * 40) +
// //                       (isListening
// //                           ? (audioLevels.isNotEmpty
// //                               ? audioLevels.last * 0.5
// //                               : 0)
// //                           : 0);
// //
// //                   return Container(
// //                     width: waveSize,
// //                     height: waveSize,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(
// //                         color: ManagerColors.primaryColor
// //                             .withOpacity((1 - progress) * 0.3),
// //                         width: 2,
// //                       ),
// //                     ),
// //                   );
// //                 }),
// //                 Icon(
// //                   isListening ? Icons.mic : Icons.mic_none,
// //                   color: Colors.white,
// //                   size: 36,
// //                 ),
// //                 if (isListening)
// //                   Container(
// //                     width: 80,
// //                     height: 80,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: ManagerColors.primaryColor.withOpacity(0.2),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class VoiceAssistantPanel extends StatefulWidget {
// //   final bool isListening;
// //   final String recognizedText;
// //   final List<double> audioLevels;
// //   final AnimationController waveController;
// //   final VoidCallback onStartListening;
// //   final VoidCallback onStopListening;
// //   final VoidCallback onClose;
// //   final ScrollController scrollController;
// //
// //   const VoiceAssistantPanel({
// //     super.key,
// //     required this.isListening,
// //     required this.recognizedText,
// //     required this.audioLevels,
// //     required this.waveController,
// //     required this.onStartListening,
// //     required this.onStopListening,
// //     required this.onClose,
// //     required this.scrollController,
// //   });
// //
// //   @override
// //   State<VoiceAssistantPanel> createState() => _VoiceAssistantPanelState();
// // }
// //
// // class _VoiceAssistantPanelState extends State<VoiceAssistantPanel> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         color: ManagerColors.primaryColor,
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Center(
// //             child: Container(
// //               width: 40,
// //               height: 5,
// //               margin: const EdgeInsets.only(bottom: 16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.5),
// //                 borderRadius: BorderRadius.circular(3),
// //               ),
// //             ),
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.close, color: Colors.white),
// //                 onPressed: widget.onClose,
// //               ),
// //               Text(
// //                 "المساعد الصوتي",
// //                 style: getBoldTextStyle(
// //                   fontSize: ManagerFontSize.s18,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.open_in_full, color: Colors.white),
// //                 onPressed: () {},
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: Container(
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               child: Column(
// //                 children: [
// //                   if (widget.recognizedText.isNotEmpty)
// //                     Expanded(
// //                       child: SingleChildScrollView(
// //                         controller: widget.scrollController,
// //                         child: Text(
// //                           widget.recognizedText,
// //                           style: getRegularTextStyle(
// //                             fontSize: ManagerFontSize.s16,
// //                             color: Colors.white,
// //                           ),
// //                           textAlign: TextAlign.center,
// //                         ),
// //                       ),
// //                     )
// //                   else
// //                     Expanded(
// //                       child: SingleChildScrollView(
// //                         controller: widget.scrollController,
// //                         child: Text(
// //                           "تمام، خليني أضبطلك الأطيب.. بس قبل هيك بتحب تختار من الجري والسلطات، ولا نفسك بالأكل الشرقي المشبع؟",
// //                           style: getRegularTextStyle(
// //                             fontSize: ManagerFontSize.s14,
// //                             color: Colors.white,
// //                           ),
// //                           textAlign: TextAlign.center,
// //                         ),
// //                       ),
// //                     ),
// //                   const SizedBox(height: 20),
// //                   if (widget.isListening)
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: List.generate(10, (index) {
// //                         final level = widget.audioLevels.isNotEmpty
// //                             ? widget.audioLevels[widget.audioLevels.length -
// //                                 1 -
// //                                 (index % widget.audioLevels.length)]
// //                             : 0.0;
// //                         final height = 10 + (level * 0.5);
// //                         return Container(
// //                           width: 4,
// //                           height: height,
// //                           margin: const EdgeInsets.symmetric(horizontal: 2),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(2),
// //                           ),
// //                         );
// //                       }),
// //                     ),
// //                   const SizedBox(height: 20),
// //                   GestureDetector(
// //                     onTap: widget.isListening
// //                         ? widget.onStopListening
// //                         : widget.onStartListening,
// //                     child: AnimatedBuilder(
// //                       animation: widget.waveController,
// //                       builder: (context, child) {
// //                         return Container(
// //                           width: 80,
// //                           height: 80,
// //                           decoration: BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             color: Colors.white,
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.white.withOpacity(0.4),
// //                                 blurRadius: 10,
// //                                 spreadRadius: widget.isListening ? 8 : 0,
// //                               ),
// //                             ],
// //                           ),
// //                           child: Stack(
// //                             alignment: Alignment.center,
// //                             children: [
// //                               if (widget.isListening)
// //                                 ...List.generate(3, (index) {
// //                                   final progress =
// //                                       ((widget.waveController.value +
// //                                               (index * 0.3)) %
// //                                           1.0);
// //                                   final waveSize = 80 +
// //                                       (progress * 60) +
// //                                       (widget.audioLevels.isNotEmpty
// //                                           ? widget.audioLevels.last * 0.8
// //                                           : 0);
// //                                   return Container(
// //                                     width: waveSize,
// //                                     height: waveSize,
// //                                     decoration: BoxDecoration(
// //                                       shape: BoxShape.circle,
// //                                       border: Border.all(
// //                                         color: Colors.white
// //                                             .withOpacity((1 - progress) * 0.2),
// //                                         width: 2,
// //                                       ),
// //                                     ),
// //                                   );
// //                                 }),
// //                               Icon(
// //                                 widget.isListening ? Icons.mic : Icons.mic_none,
// //                                 color: ManagerColors.primaryColor,
// //                                 size: 36,
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   Text(
// //                     widget.isListening ? "جاري الاستماع..." : "انقر للتحدث",
// //                     style: getRegularTextStyle(
// //                       fontSize: ManagerFontSize.s14,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
