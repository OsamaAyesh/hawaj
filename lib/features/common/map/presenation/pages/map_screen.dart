import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../../users/offer_user/common_widgets_offer_user/organization_sheet_details.dart';
import '../../../../users/offer_user/company_with_offer/domain/di/di.dart';
import '../../../../users/offer_user/company_with_offer/presentation/pages/company_with_offer_screen.dart';
import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
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
  final offersC = Get.find<OffersController>();

  final GlobalKey<SliderDrawerState> _sliderKey =
      GlobalKey<SliderDrawerState>();
  final MarkerIconManager _iconManager = MarkerIconManager();

  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _isCameraMoving = false;

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _initializeMap();
    _setupListeners();

    // 👇 تنفيذ تلقائي بعد بناء الشاشة لو جاي من Hawaj مع autoRefresh=true
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = Get.arguments;
      final autoRefresh = args is Map &&
          (args['autoRefresh'] == true || args['autoRefresh'] == 'true');

      if (autoRefresh) {
        if (mapC.currentLocation.value == null) {
          await mapC.loadCurrentLocation();
        }
        final loc = mapC.currentLocation.value;
        if (loc != null) {
          offersC.isFirstLoad.value =
              true; // يخلي ever(...) تعمل _animateToBounds
          await offersC.fetchOffers(loc); // طلب جديد
        }
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _setupSystemUI();
  //   _initializeMap();
  //   _setupListeners();
  // }

  /// إعداد Status Bar
  void _setupSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  /// تهيئة الخريطة
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

  /// إعداد Listeners
  void _setupListeners() {
    // 1️⃣ عند تحديث الموقع - جلب بيانات القسم الحالي
    ever(mapC.currentLocation, (location) {
      if (location != null) {
        sectionsC.updateLocation(location);
        sectionsC.fetchSectionData(sectionsC.currentSection.value, location);
      }
    });

    // 2️⃣ عند اختيار منظمة - فتح التفاصيل
    ever(offersC.selectedOrganization, (org) {
      if (org != null && mounted) {
        _showOrganizationDetails(org);
      }
    });

    // 3️⃣ عند تغيير القسم - جلب البيانات إذا لزم الأمر
    ever(sectionsC.currentSection, (section) {
      if (sectionsC.currentLocation.value != null) {
        sectionsC.fetchSectionData(section, sectionsC.currentLocation.value!);
      }
    });
    ever(offersC.goToResultsTrigger, (_) {
      if (_mapController != null && offersC.hasData) {
        // تأخير بسيط حتى تُرسم الماركرز
        Future.delayed(const Duration(milliseconds: 300), () {
          _animateToBounds();
        });
      }
    });

    // 4️⃣ 🎯 عند جلب المنظمات - تحريك الكاميرا لإظهار كل النتائج
    ever(offersC.organizations, (orgs) {
      if (orgs.isNotEmpty &&
          _mapController != null &&
          offersC.isFirstLoad.value) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _animateToBounds();
          offersC.isFirstLoad.value = false;
        });
      }
    });
  }

  /// 🎯 تحريك الكاميرا لإظهار جميع الماركرز
  Future<void> _animateToBounds() async {
    if (_mapController == null || _isCameraMoving) return;

    final bounds = offersC.calculateBounds();
    if (bounds == null) {
      debugPrint('[MapScreen] ⚠️ لا يمكن حساب الـ Bounds');
      return;
    }

    _isCameraMoving = true;

    try {
      debugPrint(
          '[MapScreen] 📹 تحريك الكاميرا لإظهار ${offersC.organizationsCount} منظمة');

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          80, // padding
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('[MapScreen] ❌ خطأ في تحريك الكاميرا: $e');

      // Fallback: الذهاب للمنظمة الأولى
      if (offersC.organizations.isNotEmpty) {
        final firstOrg = offersC.organizations.first;
        final lat = offersC.parseDouble(firstOrg.lat);
        final lng = offersC.parseDouble(firstOrg.lng);

        if (lat != null && lng != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(lat, lng),
              14,
            ),
          );
        }
      }
    } finally {
      _isCameraMoving = false;
    }
  }

  /// 🎯 الانتقال لموقع المستخدم
  Future<void> _goToUserLocation() async {
    if (_mapController == null || mapC.currentLocation.value == null) return;

    _isCameraMoving = true;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            mapC.currentLocation.value!.latitude,
            mapC.currentLocation.value!.longitude,
          ),
          15,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📍 موقعك الحالي'),
            duration: Duration(seconds: 1),
            backgroundColor: ManagerColors.primaryColor,
          ),
        );
      }
    } finally {
      _isCameraMoving = false;
    }
  }

  /// عرض تفاصيل المنظمة
  void _showOrganizationDetails(dynamic organization) {
    OrganizationDetailsSheet.show(
      context,
      organization,
      () {
        initGetCompany();
        Get.to(() => CompanyWithOfferScreen(idOrganization: organization.id));
      },
    );
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
              // حالة التحميل الأولي للموقع
              if (mapC.isLoading.value && mapC.currentLocation.value == null) {
                return const Center(child: LoadingWidget());
              }

              final location = mapC.currentLocation.value;
              if (location == null) return _buildLocationError();

              return Stack(
                children: [
                  // ===== Google Map with reactive markers =====
                  Obx(() {
                    final markersSet = _buildMarkers();

                    return MapViewWidget(
                      key: ValueKey('map_${offersC.markers.length}'),
                      location: location,
                      onMapCreated: (controller) async {
                        _mapController = controller;
                        final style = await rootBundle
                            .loadString('assets/json/style_map.json');
                        controller.setMapStyle(style);
                        debugPrint('[MapScreen] ✅ Map ready');

                        // ✅ لو النتائج كانت جاهزة قبل تكوين الخريطة، حرّك فورًا
                        if (offersC.hasData) {
                          Future.delayed(const Duration(milliseconds: 300),
                              _animateToBounds);
                        }
                      },
                      // onMapCreated: (controller) async {
                      //   _mapController = controller;
                      //   final style = await rootBundle
                      //       .loadString('assets/json/style_map.json');
                      //   controller.setMapStyle(style);
                      //   debugPrint('[MapScreen] ✅ Map ready');
                      // },
                      markers: markersSet,
                    );
                  }),

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

                  // ===== Action Buttons (يمين) =====
                  Positioned(
                    bottom: ManagerHeight.h120,
                    right: ManagerWidth.w16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر: الذهاب للنتائج
                        if (offersC.hasData)
                          _buildActionButton(
                            icon: Icons.location_searching,
                            label: 'النتائج',
                            onPressed: _animateToBounds,
                            color: ManagerColors.primaryColor,
                          ),

                        SizedBox(height: ManagerHeight.h12),

                        // زر: موقعي
                        _buildActionButton(
                          icon: Icons.my_location,
                          label: 'موقعي',
                          onPressed: _goToUserLocation,
                          color: Colors.blue,
                        ),

                        SizedBox(height: ManagerHeight.h12),

                        // زر: تحديث
                        _buildActionButton(
                          icon: Icons.refresh,
                          label: 'تحديث',
                          onPressed: () {
                            debugPrint('[MapScreen] 🔄 Manual refresh');
                            offersC.refresh();
                          },
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),

                  // ===== Loading Overlay =====
                  _buildLoadingOverlay(),

                  // // ===== Results Counter =====
                  // if (offersC.hasData)
                  //   Positioned(
                  //     bottom: ManagerHeight.h40,
                  //     left: 0,
                  //     right: 0,
                  //     child: Center(
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: ManagerWidth.w16,
                  //           vertical: ManagerHeight.h8,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: ManagerColors.primaryColor,
                  //           borderRadius:
                  //               BorderRadius.circular(ManagerHeight.h20),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.black.withOpacity(0.2),
                  //               blurRadius: 8,
                  //               offset: const Offset(0, 2),
                  //             ),
                  //           ],
                  //         ),
                  //         child: Text(
                  //           '${offersC.organizationsCount} منظمة قريبة',
                  //           style: getBoldTextStyle(
                  //             fontSize: ManagerFontSize.s12,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              );
            }),
          ),
        ).withHawaj(
          screen: HawajScreens.map,
          section: HawajSections.dailyOffers,
          // 🔊 Callback عند طلب حواج "offers"
          onHawajCommand: (command) async {
            final lower = command.toLowerCase();
            if (lower.contains('عرض') ||
                lower.contains('offers') ||
                lower.contains('خريطة')) {
              debugPrint(
                  '[MapScreen] 🎯 Hawaj command detected -> refresh & animate');

              // 1️⃣ تحميل الموقع الحالي مجددًا
              if (mapC.currentLocation.value != null) {
                await offersC.fetchOffers(mapC.currentLocation.value!);
              } else {
                await mapC.loadCurrentLocation();
                if (mapC.currentLocation.value != null) {
                  await offersC.fetchOffers(mapC.currentLocation.value!);
                }
              }

              // 2️⃣ انتظار بسيط لحين اكتمال التحميل
              Future.delayed(const Duration(milliseconds: 1500), () {
                _animateToBounds();
              });
            }
          },
        ),
      ),
    );
  }

  /// بناء Markers حسب القسم الحالي
  Set<Marker> _buildMarkers() {
    final currentSection = sectionsC.currentSection.value;

    switch (currentSection) {
      case MapSectionType.dailyOffers:
        final markersCount = offersC.markers.length;
        debugPrint('[MapScreen] 🏗️ Building $markersCount markers');

        if (markersCount == 0) {
          debugPrint('[MapScreen] ⚠️ No markers!');
        }

        return offersC.markers.values.toSet();

      case MapSectionType.contracts:
      case MapSectionType.realEstate:
      case MapSectionType.delivery:
      case MapSectionType.jobs:
        return <Marker>{};
    }
  }

  /// بناء زر action
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }

  /// Loading Overlay
  Widget _buildLoadingOverlay() {
    return Obx(() {
      final isLoading =
          offersC.isLoading.value || sectionsC.isCurrentSectionLoading;

      if (!isLoading) return const SizedBox.shrink();

      return Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Card(
            margin: EdgeInsets.all(ManagerWidth.w20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(ManagerWidth.w20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ManagerColors.primaryColor),
                  ),
                  SizedBox(height: ManagerHeight.h16),
                  Obx(() => Text(
                        'جاري تحميل ${sectionsC.currentSectionName}...',
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.black,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    });
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

  /// 🔄 دالة عامة لتحريك الكاميرا بعد التحديث (يمكن استدعاؤها من أي مكان)
  Future<void> animateToResults() async {
    if (_mapController == null) return;

    final bounds = offersC.calculateBounds();
    if (bounds == null) {
      debugPrint('[MapScreen] ⚠️ لا يمكن حساب الـ Bounds');
      return;
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );

    debugPrint('[MapScreen] ✅ الكاميرا تحركت لعرض النتائج الجديدة');
  }
}
