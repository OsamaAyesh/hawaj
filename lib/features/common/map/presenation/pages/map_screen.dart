import 'dart:math' as math;

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
import '../../../hawaj_voice/domain/models/job_item_hawaj_details_model.dart';
import '../../../hawaj_voice/domain/models/property_item_hawaj_details_model.dart';
import '../../../hawaj_voice/presentation/controller/hawaj_ai_controller.dart';
import '../controller/drawer_controller.dart';
import '../controller/hawaj_map_data_controller.dart';
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

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final mapC = Get.find<MapController>();
  final sectionsC = Get.find<MapSectionsController>();
  final drawerC = Get.find<MapDrawerController>();
  final offersC = Get.find<OffersController>();
  final hawajC = Get.find<HawajController>();

  final GlobalKey<SliderDrawerState> _sliderKey =
      GlobalKey<SliderDrawerState>();
  final MarkerIconManager _iconManager = MarkerIconManager();

  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _isCameraMoving = false;

  final _hawajMarkers = <String, Marker>{}.obs;
  final _selectedItem = Rxn<dynamic>();
  final _selectedItemType = Rxn<String>();

  // 🎨 Animation Controllers
  late AnimationController _markerAnimationController;
  late AnimationController _floatingCardController;

  // 📍 مركز الرياض - للوظائف بدون مواقع
  static const _riyadhCenter = LatLng(24.7136, 46.6753);
  static const _riyadhRadius = 0.1; // ~10km
  final _isRefreshing = false.obs;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setupSystemUI();
    _initializeMap();
    _setupListeners();
    _handleHawajAutoRefresh();
    _isRefreshing.value = false;

    final hawajC = Get.find<HawajController>();

    hawajC.onDataClear = _onHawajDataClear;
    hawajC.onDataReady = _onHawajDataReady;
    hawajC.onAnimateCamera = _onHawajAnimateCamera;
  }

  void _onHawajDataClear() {
    debugPrint('🧹 Map: Clearing old markers');
    _isRefreshing.value = true;
    _hawajMarkers.clear();
    offersC.markers.clear();
    _selectedItem.value = null;
    _selectedItemType.value = null;
  }

  void _onHawajDataReady() {
    debugPrint('🏗️ Map: Building new markers');
    _buildHawajMarkers();
  }

  void _onHawajAnimateCamera() {
    debugPrint('🎥 Map: Animating camera');
    _animateToHawajResults();
    Future.delayed(const Duration(milliseconds: 500), () {
      _isRefreshing.value = false;
    });
  }

  void _initAnimations() {
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingCardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(permission.message!)),
      );
    }
  }

  void _handleHawajAutoRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args['fromHawaj'] == true) {
        debugPrint('🎯 [MapScreen] جئنا من Hawaj - معالجة مباشرة...');
        Future.delayed(const Duration(milliseconds: 300), () {
          _processHawajData();
        });
      }
    });
  }

  void _setupListeners() {
    // 1️⃣ عند تحديث الموقع
    ever(mapC.currentLocation, (location) {
      if (location != null) {
        sectionsC.updateLocation(location);
      }
    });

    // 2️⃣ عند اختيار منظمة
    ever(offersC.selectedOrganization, (org) {
      if (org != null && mounted) {
        _showOrganizationDetails(org);
      }
    });

    // 3️⃣ عند تغيير القسم
    ever(sectionsC.currentSection, (section) {
      if (sectionsC.currentLocation.value != null) {
        sectionsC.fetchSectionData(section, sectionsC.currentLocation.value!);
      }
    });

    // 4️⃣ عند جلب المنظمات العادية
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

    final hawajController = Get.find<HawajMapDataController>();
    hawajController.onDataCleaned = () {
      if (mounted) {
        _isRefreshing.value = true;
        _hawajMarkers.clear();
        offersC.markers.clear();
        _selectedItem.value = null;
        _selectedItemType.value = null;
      }
    };

    hawajController.onMarkersReady = () {
      if (mounted) {
        _buildHawajMarkers();
        _isRefreshing.value = false; // إخفاء التأثير بعد انتهاء البناء
      }
    };
    // hawajController.onDataCleaned = () {
    //   if (mounted) {
    //     debugPrint('🧹 [MapScreen] Refresh - تنظيف كامل قبل عرض نتائج جديدة');
    //     _hawajMarkers.clear();
    //     offersC.markers.clear();
    //     _selectedItem.value = null;
    //     _selectedItemType.value = null;
    //   }
    // };
    //
    // hawajController.onMarkersReady = () {
    //   if (mounted) {
    //     debugPrint('🏗️ [MapScreen] Refresh - بناء ماركرات جديدة');
    //     _buildHawajMarkers();
    //
    //     // تشغيل animation خفيف عند ظهورها
    //     _markerAnimationController.forward(from: 0);
    //   }
    // };

    hawajController.onAnimateToMarkers = () {
      if (mounted && _mapController != null && _hawajMarkers.isNotEmpty) {
        debugPrint('📹 [MapScreen] Refresh - تحريك الكاميرا للنتائج الجديدة');
        _animateToHawajResults();
      }
    };

    ever<List<PropertyItemHawajDetailsModel>>(hawajController.properties.obs,
        (properties) {
      if (properties.isNotEmpty && mounted) {
        debugPrint('📊 [MapScreen] تحديث العقارات: ${properties.length}');
        if (_hawajMarkers.isEmpty) {
          _buildHawajMarkers();
        }
      }
    });

    ever<List<JobItemHawajDetailsModel>>(hawajController.jobs.obs, (jobs) {
      if (jobs.isNotEmpty && mounted) {
        debugPrint('📊 [MapScreen] تحديث الوظائف: ${jobs.length}');
        if (_hawajMarkers.isEmpty) {
          _buildHawajMarkers();
        }
      }
    });
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎯 معالجة بيانات Hawaj - تلقائي ومباشر مع تنظيف كامل
  /// ═══════════════════════════════════════════════════════════
  void _processHawajData() {
    debugPrint('🎯 [MapScreen] 🚀 بدء المعالجة التلقائية...');
    debugPrint('   📊 hasHawajData: ${hawajC.hasHawajData}');
    debugPrint('   🟠 عروض: ${hawajC.hawajOffers.length}');
    debugPrint('   🟢 عقارات: ${hawajC.hawajProperties.length}');
    debugPrint('   💼 وظائف: ${hawajC.hawajJobs.length}');

    if (!hawajC.hasHawajData) {
      debugPrint('⚠️ لا توجد بيانات');
      return;
    }

    // 1️⃣ 🧹 مسح كل شيء قديم - CRITICAL
    debugPrint('🧹 مسح جميع الماركرز القديمة...');
    _hawajMarkers.clear();
    offersC.markers.clear();
    _selectedItem.value = null;
    _selectedItemType.value = null;

    // 2️⃣ بناء الماركرز الجديدة
    _buildHawajMarkers();

    // 3️⃣ 🎯 التوجيه التلقائي للنتائج الجديدة
    if (_mapController != null && _hawajMarkers.isNotEmpty) {
      debugPrint('📹 التوجيه التلقائي للنتائج الجديدة...');
      Future.delayed(const Duration(milliseconds: 600), () {
        _animateToHawajResults();
        _markerAnimationController.forward(from: 0);
      });
    }

    debugPrint('✅ [MapScreen] اكتملت المعالجة - جاهز للعرض!');
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🏗️ بناء Markers بطريقة احترافية
  /// ═══════════════════════════════════════════════════════════
  void _buildHawajMarkers() {
    debugPrint('🏗️ [MapScreen] بناء الماركرز الاحترافية...');

    // 🟠 العروض
    if (hawajC.hawajOffers.isNotEmpty) {
      debugPrint('🟠 بناء ${hawajC.hawajOffers.length} عرض');
      _buildOfferMarkers();
    }

    // 🟢 العقارات
    if (hawajC.hawajProperties.isNotEmpty) {
      debugPrint('🟢 بناء ${hawajC.hawajProperties.length} عقار');
      _buildPropertyMarkers();
    }

    // 💼 الوظائف - توزيع ذكي في الرياض
    if (hawajC.hawajJobs.isNotEmpty) {
      debugPrint('💼 بناء ${hawajC.hawajJobs.length} وظيفة - توزيع ذكي');
      _buildJobMarkers();
    }

    debugPrint('✅ تم إنشاء ${_hawajMarkers.length} marker بنجاح');
  }

  /// 🟠 بناء markers للعروض
  void _buildOfferMarkers() {
    for (var offer in hawajC.hawajOffers) {
      final lat = double.tryParse(offer.organizationLocationLat);
      final lng = double.tryParse(offer.organizationLocationLng);

      if (lat != null && lng != null) {
        final markerId = 'hawaj_offer_${offer.id}';

        final marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lng),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _showItemDetails(offer, 'offer'),
        );

        _hawajMarkers[markerId] = marker;
        offersC.markers[markerId] = marker;
      }
    }
  }

  /// 🟢 بناء markers للعقارات
  void _buildPropertyMarkers() {
    for (var property in hawajC.hawajProperties) {
      final lat = double.tryParse(property.lat);
      final lng = double.tryParse(property.lng);

      if (lat != null && lng != null) {
        final markerId = 'hawaj_property_${property.id}';
        final marker = Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lng),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () => _showItemDetails(property, 'property'),
        );

        _hawajMarkers[markerId] = marker;
        offersC.markers[markerId] = marker;
      }
    }
  }

  /// 💼 بناء markers للوظائف - توزيع ذكي في الرياض
  void _buildJobMarkers() {
    final random = math.Random();

    for (int i = 0; i < hawajC.hawajJobs.length; i++) {
      final job = hawajC.hawajJobs[i];

      // 🎯 توليد موقع عشوائي في الرياض
      final location = _generateRandomLocationInRiyadh(i, random);

      final markerId = 'hawaj_job_${job.id}';
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _showItemDetails(job, 'job'),
      );

      _hawajMarkers[markerId] = marker;
      offersC.markers[markerId] = marker;
    }
  }

  /// 🎲 توليد موقع عشوائي في الرياض بطريقة ذكية
  LatLng _generateRandomLocationInRiyadh(int index, math.Random random) {
    // توزيع دائري حول مركز الرياض
    final angle = (index * 2 * math.pi / math.max(hawajC.hawajJobs.length, 1)) +
        (random.nextDouble() * 0.5);
    final distance = _riyadhRadius * (0.3 + random.nextDouble() * 0.7);

    final lat = _riyadhCenter.latitude + (distance * math.cos(angle));
    final lng = _riyadhCenter.longitude + (distance * math.sin(angle));

    return LatLng(lat, lng);
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎨 عرض Floating Card عند الضغط على marker
  /// ═══════════════════════════════════════════════════════════
  void _showItemDetails(dynamic item, String type) {
    _selectedItem.value = item;
    _selectedItemType.value = type;
    _floatingCardController.forward(from: 0);

    debugPrint('✨ عرض تفاصيل: $type');
  }

  /// 🎨 بناء Floating Card
  Widget _buildFloatingCard() {
    return Obx(() {
      final item = _selectedItem.value;
      final type = _selectedItemType.value;

      if (item == null || type == null) {
        return const SizedBox.shrink();
      }

      return AnimatedBuilder(
        animation: _floatingCardController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -50 * (1 - _floatingCardController.value)),
            child: Opacity(
              opacity: _floatingCardController.value,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w16,
                  vertical: ManagerHeight.h16,
                ),
                padding: EdgeInsets.all(ManagerWidth.w16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        _buildFloatingIcon(type),
                        SizedBox(width: ManagerWidth.w12),
                        Expanded(child: _buildFloatingTitle(item, type)),
                        IconButton(
                          onPressed: () {
                            _selectedItem.value = null;
                            _selectedItemType.value = null;
                          },
                          icon: const Icon(Icons.close, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    SizedBox(height: ManagerHeight.h12),

                    // Details
                    _buildFloatingDetails(item, type),

                    SizedBox(height: ManagerHeight.h12),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToDetails(item, type),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagerColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: ManagerHeight.h12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('عرض التفاصيل الكاملة'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFloatingIcon(String type) {
    IconData icon;
    Color color;

    if (type == 'offer') {
      icon = Icons.local_offer;
      color = Colors.orange;
    } else if (type == 'property') {
      icon = Icons.home;
      color = Colors.green;
    } else {
      icon = Icons.work;
      color = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.all(ManagerWidth.w8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildFloatingTitle(dynamic item, String type) {
    String title = '';
    String subtitle = '';

    if (type == 'offer') {
      title = item.organizationName ?? '';
      subtitle = (item.organizationServices != null &&
              item.organizationServices.isNotEmpty)
          ? (item.organizationServices.length > 30
              ? '${item.organizationServices.substring(0, 30)}...'
              : item.organizationServices)
          : 'عرض';
    } else if (type == 'property') {
      title = item.propertySubject ?? '';
      subtitle = '${item.price} ريال';
    } else if (type == 'job') {
      title = item.jobTitle ?? '';
      subtitle = item.jobType ?? 'وظيفة';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ManagerHeight.h4),
        Text(
          subtitle,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s11,
            color: Colors.grey[600]!,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFloatingDetails(dynamic item, String type) {
    if (type == 'offer') {
      return Column(
        children: [
          if (item.phoneNumber != null && item.phoneNumber.isNotEmpty)
            _buildFloatingRow(Icons.phone, item.phoneNumber),
          if (item.workingHours != null && item.workingHours.isNotEmpty)
            _buildFloatingRow(Icons.access_time, item.workingHours),
        ],
      );
    } else if (type == 'property') {
      return Column(
        children: [
          _buildFloatingRow(Icons.square_foot, '${item.areaSqm}م²'),
          if (item.propertyDetailedAddress != null &&
              item.propertyDetailedAddress.isNotEmpty)
            _buildFloatingRow(Icons.location_on, item.propertyDetailedAddress),
        ],
      );
    } else if (type == 'job') {
      return Column(
        children: [
          if (item.companyName != null && item.companyName.isNotEmpty)
            _buildFloatingRow(Icons.business, item.companyName),
          if (item.experienceYears != null && item.experienceYears.isNotEmpty)
            _buildFloatingRow(Icons.schedule, '${item.experienceYears} سنة'),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFloatingRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: ManagerWidth.w8),
          Expanded(
            child: Text(
              text,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s11,
                color: Colors.grey[700]!,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(dynamic item, String type) {
    if (type == 'offer') {
      initGetCompany();
      Get.to(() => CompanyWithOfferScreen(idOrganization: item.id));
    } else {
      // يمكنك إضافة navigation للعقارات والوظائف هنا
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('التفاصيل الكاملة لـ ${type}')),
      );
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 📹 تحريك الكاميرا - Animation احترافي
  /// ═══════════════════════════════════════════════════════════
  Future<void> _animateToHawajResults() async {
    debugPrint('📹 [MapScreen] 🎬 Animation بدأ...');

    if (_mapController == null || _isCameraMoving) return;

    final locations = _hawajMarkers.values.map((m) => m.position).toList();

    if (locations.isEmpty) {
      debugPrint('⚠️ لا توجد مواقع');
      return;
    }

    _isCameraMoving = true;

    try {
      if (locations.length == 1) {
        // موقع واحد - zoom مقرب
        debugPrint('   → موقع واحد - zoom=15');
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(locations.first, 15),
        );
      } else {
        // عدة مواقع - bounds ذكي
        debugPrint('   → ${locations.length} موقع - bounds ذكي');
        final bounds = _calculateSmartBounds(locations);

        await _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
      }

      debugPrint('✅ Animation اكتمل بنجاح!');

      // تأثير بصري
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 تم العثور على ${_hawajMarkers.length} نتيجة'),
            duration: const Duration(seconds: 2),
            backgroundColor: ManagerColors.primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ خطأ: $e');
    } finally {
      _isCameraMoving = false;
    }
  }

  /// 🧮 حساب Bounds ذكي
  LatLngBounds _calculateSmartBounds(List<LatLng> locations) {
    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;

    for (var loc in locations) {
      if (loc.latitude < minLat) minLat = loc.latitude;
      if (loc.latitude > maxLat) maxLat = loc.latitude;
      if (loc.longitude < minLng) minLng = loc.longitude;
      if (loc.longitude > maxLng) maxLng = loc.longitude;
    }

    // Padding ذكي
    final latPadding = math.max((maxLat - minLat) * 0.15, 0.01);
    final lngPadding = math.max((maxLng - minLng) * 0.15, 0.01);

    return LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
  }

  /// 🎯 تحريك الكاميرا للعروض العادية
  Future<void> _animateToBounds() async {
    if (_mapController == null || _isCameraMoving) return;

    final bounds = offersC.calculateBounds();
    if (bounds == null) return;

    _isCameraMoving = true;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('❌ خطأ: $e');
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
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _isCameraMoving = false;
    }
  }

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
              if (mapC.isLoading.value && mapC.currentLocation.value == null) {
                return const Center(child: LoadingWidget());
              }

              final location = mapC.currentLocation.value;
              if (location == null) return _buildLocationError();

              return Stack(
                children: [
                  // ===== Google Map =====
                  Obx(() {
                    final allMarkers = {
                      ...offersC.markers.values,
                      ..._hawajMarkers.values
                    };

                    return AnimatedBuilder(
                      animation: _markerAnimationController,
                      builder: (context, child) {
                        return MapViewWidget(
                          key: ValueKey('map_${allMarkers.length}'),
                          location: location,
                          onMapCreated: (controller) async {
                            _mapController = controller;
                            final style = await rootBundle
                                .loadString('assets/json/style_map.json');
                            controller.setMapStyle(style);
                            debugPrint('✅ Map ready');

                            // معالجة بيانات Hawaj إذا كانت موجودة
                            if (hawajC.hasHawajData) {
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                _processHawajData();
                              });
                            }
                          },
                          markers: allMarkers,
                        );
                      },
                    );
                  }),

                  // ===== Top Bar =====
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

                  // 🎨 Floating Card - في الأعلى
                  Positioned(
                    top: ManagerHeight.h90,
                    left: 0,
                    right: 0,
                    child: _buildFloatingCard(),
                  ),

                  // ===== Action Buttons =====
                  Positioned(
                    bottom: ManagerHeight.h30,
                    right: ManagerWidth.w16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر: الذهاب للنتائج
                        if (offersC.hasData || _hawajMarkers.isNotEmpty)
                          _buildActionButton(
                            icon: Icons.location_searching,
                            label: 'النتائج',
                            onPressed: () {
                              if (_hawajMarkers.isNotEmpty) {
                                _animateToHawajResults();
                              } else {
                                _animateToBounds();
                              }
                            },
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
                      ],
                    ),
                  ),

                  // ===== Loading Overlay =====
                  _buildLoadingOverlay(),

                  Obx(() {
                    if (!_isRefreshing.value) return const SizedBox.shrink();
                    return AnimatedOpacity(
                      opacity: 0.95,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        color: Colors.white.withOpacity(0.85),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                  color: Colors.blue),
                              const SizedBox(height: 12),
                              Text(
                                'جارٍ تحديث الخريطة...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ),
        ).withHawaj(
          screen: HawajScreens.map,
          section: _getDynamicSection(),
        ),
      ),
    );
  }

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
          child: Icon(icon, color: color, size: 28),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Obx(() {
      final isLoading = hawajC.isProcessing;

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
                  Text(
                    'جارٍ البحث عن أفضل النتائج...',
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

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

  /// 🎯 تحديد Section ديناميكياً حسب آخر نتائج
  String _getDynamicSection() {
    // تحديد حسب نوع البيانات الحالية
    if (hawajC.hawajOffers.isNotEmpty) {
      debugPrint('📍 Section: dailyOffers (1)');
      return HawajSections.dailyOffers; // "1"
    } else if (hawajC.hawajProperties.isNotEmpty) {
      debugPrint('📍 Section: realEstates (3)');
      return HawajSections.realEstates; // "3"
    } else if (hawajC.hawajJobs.isNotEmpty) {
      debugPrint('📍 Section: jobs (5)');
      return HawajSections.jobs; // "5"
    }

    // default - العروض اليومية
    debugPrint('📍 Section: default dailyOffers (1)');
    return HawajSections.dailyOffers; // "1"
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _markerAnimationController.dispose();
    _floatingCardController.dispose();
    super.dispose();
  }
}

// import 'dart:math' as math;
//
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
// import '../../../../users/offer_user/common_widgets_offer_user/organization_sheet_details.dart';
// import '../../../../users/offer_user/company_with_offer/domain/di/di.dart';
// import '../../../../users/offer_user/company_with_offer/presentation/pages/company_with_offer_screen.dart';
// import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
// import '../../../hawaj_voice/presentation/controller/hawaj_ai_controller.dart';
// import '../controller/drawer_controller.dart';
// import '../controller/map_controller.dart';
// import '../controller/map_sections_controller.dart';
// import '../managers/marker_icon_manager.dart';
// import '../managers/permission_manager.dart';
// import '../widgets/improved_drawer_widget.dart';
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
// class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
//   final mapC = Get.find<MapController>();
//   final sectionsC = Get.find<MapSectionsController>();
//   final drawerC = Get.find<MapDrawerController>();
//   final offersC = Get.find<OffersController>();
//   final hawajC = Get.find<HawajController>();
//
//   final GlobalKey<SliderDrawerState> _sliderKey =
//       GlobalKey<SliderDrawerState>();
//   final MarkerIconManager _iconManager = MarkerIconManager();
//
//   GoogleMapController? _mapController;
//   bool _isMapReady = false;
//   bool _isCameraMoving = false;
//
//   final _hawajMarkers = <String, Marker>{}.obs;
//   final _selectedItem = Rxn<dynamic>();
//   final _selectedItemType = Rxn<String>();
//
//   // 🎨 Animation Controllers
//   late AnimationController _markerAnimationController;
//   late AnimationController _floatingCardController;
//
//   // 📍 مركز الرياض - للوظائف بدون مواقع
//   static const _riyadhCenter = LatLng(24.7136, 46.6753);
//   static const _riyadhRadius = 0.1; // ~10km
//
//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _setupSystemUI();
//     _initializeMap();
//     _setupListeners();
//     _handleHawajAutoRefresh();
//   }
//
//   void _initAnimations() {
//     _markerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _floatingCardController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//   }
//
//   void _setupSystemUI() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.transparent,
//     ));
//   }
//
//   Future<void> _initializeMap() async {
//     await _iconManager.initialize();
//     final permission = await PermissionManager.handleLocationPermission();
//
//     if (permission.granted) {
//       await mapC.loadCurrentLocation();
//       setState(() => _isMapReady = true);
//     } else if (mounted && permission.message != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(permission.message!)),
//       );
//     }
//   }
//
//   void _handleHawajAutoRefresh() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = Get.arguments;
//       if (args != null && args['fromHawaj'] == true) {
//         debugPrint('🎯 [MapScreen] جئنا من Hawaj - معالجة مباشرة...');
//         Future.delayed(const Duration(milliseconds: 300), () {
//           _processHawajData();
//         });
//       }
//     });
//   }
//
//   void _setupListeners() {
//     // 1️⃣ عند تحديث الموقع
//     ever(mapC.currentLocation, (location) {
//       if (location != null) {
//         sectionsC.updateLocation(location);
//       }
//     });
//
//     // 2️⃣ عند اختيار منظمة
//     ever(offersC.selectedOrganization, (org) {
//       if (org != null && mounted) {
//         _showOrganizationDetails(org);
//       }
//     });
//
//     // 3️⃣ عند تغيير القسم
//     ever(sectionsC.currentSection, (section) {
//       if (sectionsC.currentLocation.value != null) {
//         sectionsC.fetchSectionData(section, sectionsC.currentLocation.value!);
//       }
//     });
//
//     // 4️⃣ عند جلب المنظمات العادية
//     ever(offersC.organizations, (orgs) {
//       if (orgs.isNotEmpty &&
//           _mapController != null &&
//           offersC.isFirstLoad.value) {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           _animateToBounds();
//           offersC.isFirstLoad.value = false;
//         });
//       }
//     });
//
//     // 5️⃣ 🎯 مراقبة بيانات Hawaj - يتفعل تلقائياً عند التحديث
//     ever(hawajC.hawajDataCount.obs, (count) {
//       if (count > 0) {
//         debugPrint('🎯 [MapScreen] تم تحديث بيانات Hawaj: $count نتيجة');
//         Future.delayed(const Duration(milliseconds: 200), () {
//           _processHawajData();
//         });
//       }
//     });
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎯 معالجة بيانات Hawaj - تلقائي ومباشر
//   /// ═══════════════════════════════════════════════════════════
//   void _processHawajData() {
//     debugPrint('🎯 [MapScreen] 🚀 بدء المعالجة التلقائية...');
//     debugPrint('   📊 hasHawajData: ${hawajC.hasHawajData}');
//     debugPrint('   🟠 عروض: ${hawajC.hawajOffers.length}');
//     debugPrint('   🟢 عقارات: ${hawajC.hawajProperties.length}');
//     debugPrint('   💼 وظائف: ${hawajC.hawajJobs.length}');
//
//     if (!hawajC.hasHawajData) {
//       debugPrint('⚠️ لا توجد بيانات');
//       return;
//     }
//
//     // 1️⃣ 🧹 مسح كل شيء قديم - CRITICAL
//     debugPrint('🧹 مسح جميع الماركرز القديمة...');
//     _hawajMarkers.clear();
//     offersC.markers.clear();
//     _selectedItem.value = null;
//     _selectedItemType.value = null;
//
//     // 2️⃣ بناء الماركرز الجديدة
//     _buildHawajMarkers();
//
//     // 3️⃣ 🎯 التوجيه التلقائي للنتائج الجديدة
//     if (_mapController != null && _hawajMarkers.isNotEmpty) {
//       debugPrint('📹 التوجيه التلقائي للنتائج الجديدة...');
//       Future.delayed(const Duration(milliseconds: 600), () {
//         _animateToHawajResults();
//         _markerAnimationController.forward(from: 0);
//       });
//     }
//
//     debugPrint('✅ [MapScreen] اكتملت المعالجة - جاهز للعرض!');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🏗️ بناء Markers بطريقة احترافية
//   /// ═══════════════════════════════════════════════════════════
//   void _buildHawajMarkers() {
//     debugPrint('🏗️ [MapScreen] بناء الماركرز الاحترافية...');
//
//     // 🟠 العروض
//     if (hawajC.hawajOffers.isNotEmpty) {
//       debugPrint('🟠 بناء ${hawajC.hawajOffers.length} عرض');
//       _buildOfferMarkers();
//     }
//
//     // 🟢 العقارات
//     if (hawajC.hawajProperties.isNotEmpty) {
//       debugPrint('🟢 بناء ${hawajC.hawajProperties.length} عقار');
//       _buildPropertyMarkers();
//     }
//
//     // 💼 الوظائف - توزيع ذكي في الرياض
//     if (hawajC.hawajJobs.isNotEmpty) {
//       debugPrint('💼 بناء ${hawajC.hawajJobs.length} وظيفة - توزيع ذكي');
//       _buildJobMarkers();
//     }
//
//     debugPrint('✅ تم إنشاء ${_hawajMarkers.length} marker بنجاح');
//   }
//
//   /// 🟠 بناء markers للعروض
//   void _buildOfferMarkers() {
//     for (var offer in hawajC.hawajOffers) {
//       final lat = double.tryParse(offer.organizationLocationLat);
//       final lng = double.tryParse(offer.organizationLocationLng);
//
//       if (lat != null && lng != null) {
//         final markerId = 'hawaj_offer_${offer.id}';
//
//         final marker = Marker(
//           markerId: MarkerId(markerId),
//           position: LatLng(lat, lng),
//           icon:
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//           // ❌ بدون InfoWindow - بس Floating Card
//           onTap: () => _showItemDetails(offer, 'offer'),
//         );
//
//         _hawajMarkers[markerId] = marker;
//         offersC.markers[markerId] = marker;
//       }
//     }
//   }
//
//   /// 🟢 بناء markers للعقارات
//   void _buildPropertyMarkers() {
//     for (var property in hawajC.hawajProperties) {
//       final lat = double.tryParse(property.lat);
//       final lng = double.tryParse(property.lng);
//
//       if (lat != null && lng != null) {
//         final markerId = 'hawaj_property_${property.id}';
//         final marker = Marker(
//           markerId: MarkerId(markerId),
//           position: LatLng(lat, lng),
//           icon:
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//           // ❌ بدون InfoWindow - بس Floating Card
//           onTap: () => _showItemDetails(property, 'property'),
//         );
//
//         _hawajMarkers[markerId] = marker;
//         offersC.markers[markerId] = marker;
//       }
//     }
//   }
//
//   /// 💼 بناء markers للوظائف - توزيع ذكي في الرياض
//   void _buildJobMarkers() {
//     final random = math.Random();
//
//     for (int i = 0; i < hawajC.hawajJobs.length; i++) {
//       final job = hawajC.hawajJobs[i];
//
//       // 🎯 توليد موقع عشوائي في الرياض
//       final location = _generateRandomLocationInRiyadh(i, random);
//
//       final markerId = 'hawaj_job_${job.id}';
//       final marker = Marker(
//         markerId: MarkerId(markerId),
//         position: location,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         // ❌ بدون InfoWindow - بس Floating Card
//         onTap: () => _showItemDetails(job, 'job'),
//       );
//
//       _hawajMarkers[markerId] = marker;
//       offersC.markers[markerId] = marker;
//     }
//   }
//
//   /// 🎲 توليد موقع عشوائي في الرياض بطريقة ذكية
//   LatLng _generateRandomLocationInRiyadh(int index, math.Random random) {
//     // توزيع دائري حول مركز الرياض
//     final angle = (index * 2 * math.pi / math.max(hawajC.hawajJobs.length, 1)) +
//         (random.nextDouble() * 0.5);
//     final distance = _riyadhRadius * (0.3 + random.nextDouble() * 0.7);
//
//     final lat = _riyadhCenter.latitude + (distance * math.cos(angle));
//     final lng = _riyadhCenter.longitude + (distance * math.sin(angle));
//
//     return LatLng(lat, lng);
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎨 عرض Floating Card عند الضغط على marker
//   /// ═══════════════════════════════════════════════════════════
//   void _showItemDetails(dynamic item, String type) {
//     _selectedItem.value = item;
//     _selectedItemType.value = type;
//     _floatingCardController.forward(from: 0);
//
//     debugPrint('✨ عرض تفاصيل: $type');
//   }
//
//   /// 🎨 بناء Floating Card
//   Widget _buildFloatingCard() {
//     return Obx(() {
//       final item = _selectedItem.value;
//       final type = _selectedItemType.value;
//
//       if (item == null || type == null) {
//         return const SizedBox.shrink();
//       }
//
//       return AnimatedBuilder(
//         animation: _floatingCardController,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: Offset(0, -50 * (1 - _floatingCardController.value)),
//             child: Opacity(
//               opacity: _floatingCardController.value,
//               child: Container(
//                 margin: EdgeInsets.symmetric(
//                   horizontal: ManagerWidth.w16,
//                   vertical: ManagerHeight.h16,
//                 ),
//                 padding: EdgeInsets.all(ManagerWidth.w16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Row(
//                       children: [
//                         _buildFloatingIcon(type),
//                         SizedBox(width: ManagerWidth.w12),
//                         Expanded(child: _buildFloatingTitle(item, type)),
//                         IconButton(
//                           onPressed: () {
//                             _selectedItem.value = null;
//                             _selectedItemType.value = null;
//                           },
//                           icon: const Icon(Icons.close, size: 20),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: ManagerHeight.h12),
//
//                     // Details
//                     _buildFloatingDetails(item, type),
//
//                     SizedBox(height: ManagerHeight.h12),
//
//                     // Action Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => _navigateToDetails(item, type),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ManagerColors.primaryColor,
//                           foregroundColor: Colors.white,
//                           padding:
//                               EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text('عرض التفاصيل الكاملة'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   Widget _buildFloatingIcon(String type) {
//     IconData icon;
//     Color color;
//
//     if (type == 'offer') {
//       icon = Icons.local_offer;
//       color = Colors.orange;
//     } else if (type == 'property') {
//       icon = Icons.home;
//       color = Colors.green;
//     } else {
//       icon = Icons.work;
//       color = Colors.blue;
//     }
//
//     return Container(
//       padding: EdgeInsets.all(ManagerWidth.w8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(icon, color: color, size: 24),
//     );
//   }
//
//   Widget _buildFloatingTitle(dynamic item, String type) {
//     String title = '';
//     String subtitle = '';
//
//     if (type == 'offer') {
//       title = item.organizationName ?? '';
//       // استخدام organizationServices بدلاً من organizationTypeLable
//       subtitle = (item.organizationServices != null &&
//               item.organizationServices.isNotEmpty)
//           ? (item.organizationServices.length > 30
//               ? '${item.organizationServices.substring(0, 30)}...'
//               : item.organizationServices)
//           : 'عرض';
//     } else if (type == 'property') {
//       title = item.propertySubject ?? '';
//       subtitle = '${item.price} ريال';
//     } else if (type == 'job') {
//       title = item.jobTitle ?? '';
//       subtitle = item.jobType ?? 'وظيفة';
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: getBoldTextStyle(
//             fontSize: ManagerFontSize.s14,
//             color: ManagerColors.black,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: ManagerHeight.h4),
//         Text(
//           subtitle,
//           style: getRegularTextStyle(
//             fontSize: ManagerFontSize.s11,
//             color: Colors.grey[600]!,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFloatingDetails(dynamic item, String type) {
//     if (type == 'offer') {
//       return Column(
//         children: [
//           if (item.phoneNumber != null && item.phoneNumber.isNotEmpty)
//             _buildFloatingRow(Icons.phone, item.phoneNumber),
//           if (item.workingHours != null && item.workingHours.isNotEmpty)
//             _buildFloatingRow(Icons.access_time, item.workingHours),
//         ],
//       );
//     } else if (type == 'property') {
//       return Column(
//         children: [
//           _buildFloatingRow(Icons.square_foot, '${item.areaSqm}م²'),
//           if (item.address != null && item.address.isNotEmpty)
//             _buildFloatingRow(Icons.location_on, item.address),
//         ],
//       );
//     } else if (type == 'job') {
//       return Column(
//         children: [
//           if (item.companyName != null && item.companyName.isNotEmpty)
//             _buildFloatingRow(Icons.business, item.companyName),
//           if (item.experienceRequired != null &&
//               item.experienceRequired.isNotEmpty)
//             _buildFloatingRow(Icons.schedule, item.experienceRequired),
//         ],
//       );
//     }
//
//     return const SizedBox.shrink();
//   }
//
//   Widget _buildFloatingRow(IconData icon, String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: ManagerHeight.h6),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           SizedBox(width: ManagerWidth.w8),
//           Expanded(
//             child: Text(
//               text,
//               style: getRegularTextStyle(
//                 fontSize: ManagerFontSize.s11,
//                 color: Colors.grey[700]!,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToDetails(dynamic item, String type) {
//     if (type == 'offer') {
//       initGetCompany();
//       Get.to(() => CompanyWithOfferScreen(idOrganization: item.id));
//     } else {
//       // يمكنك إضافة navigation للعقارات والوظائف هنا
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('التفاصيل الكاملة لـ ${type}')),
//       );
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 📹 تحريك الكاميرا - Animation احترافي
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _animateToHawajResults() async {
//     debugPrint('📹 [MapScreen] 🎬 Animation بدأ...');
//
//     if (_mapController == null || _isCameraMoving) return;
//
//     final locations = _hawajMarkers.values.map((m) => m.position).toList();
//
//     if (locations.isEmpty) {
//       debugPrint('⚠️ لا توجد مواقع');
//       return;
//     }
//
//     _isCameraMoving = true;
//
//     try {
//       if (locations.length == 1) {
//         // موقع واحد - zoom مقرب
//         debugPrint('   → موقع واحد - zoom=15');
//         await _mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(locations.first, 15),
//         );
//       } else {
//         // عدة مواقع - bounds ذكي
//         debugPrint('   → ${locations.length} موقع - bounds ذكي');
//         final bounds = _calculateSmartBounds(locations);
//
//         await _mapController!.animateCamera(
//           CameraUpdate.newLatLngBounds(bounds, 80),
//         );
//       }
//
//       debugPrint('✅ Animation اكتمل بنجاح!');
//
//       // تأثير بصري
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('📍 تم العثور على ${_hawajMarkers.length} نتيجة'),
//             duration: const Duration(seconds: 2),
//             backgroundColor: ManagerColors.primaryColor,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('❌ خطأ: $e');
//     } finally {
//       _isCameraMoving = false;
//     }
//   }
//
//   /// 🧮 حساب Bounds ذكي
//   LatLngBounds _calculateSmartBounds(List<LatLng> locations) {
//     double minLat = locations.first.latitude;
//     double maxLat = locations.first.latitude;
//     double minLng = locations.first.longitude;
//     double maxLng = locations.first.longitude;
//
//     for (var loc in locations) {
//       if (loc.latitude < minLat) minLat = loc.latitude;
//       if (loc.latitude > maxLat) maxLat = loc.latitude;
//       if (loc.longitude < minLng) minLng = loc.longitude;
//       if (loc.longitude > maxLng) maxLng = loc.longitude;
//     }
//
//     // Padding ذكي
//     final latPadding = math.max((maxLat - minLat) * 0.15, 0.01);
//     final lngPadding = math.max((maxLng - minLng) * 0.15, 0.01);
//
//     return LatLngBounds(
//       southwest: LatLng(minLat - latPadding, minLng - lngPadding),
//       northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
//     );
//   }
//
//   /// 🎯 تحريك الكاميرا للعروض العادية
//   Future<void> _animateToBounds() async {
//     if (_mapController == null || _isCameraMoving) return;
//
//     final bounds = offersC.calculateBounds();
//     if (bounds == null) return;
//
//     _isCameraMoving = true;
//
//     try {
//       await _mapController!.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 80),
//       );
//       await Future.delayed(const Duration(milliseconds: 800));
//     } catch (e) {
//       debugPrint('❌ خطأ: $e');
//     } finally {
//       _isCameraMoving = false;
//     }
//   }
//
//   /// 🎯 الانتقال لموقع المستخدم
//   Future<void> _goToUserLocation() async {
//     if (_mapController == null || mapC.currentLocation.value == null) return;
//
//     _isCameraMoving = true;
//
//     try {
//       await _mapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(
//           LatLng(
//             mapC.currentLocation.value!.latitude,
//             mapC.currentLocation.value!.longitude,
//           ),
//           15,
//         ),
//       );
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('📍 موقعك الحالي'),
//             duration: Duration(seconds: 1),
//             backgroundColor: Colors.blue,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       _isCameraMoving = false;
//     }
//   }
//
//   void _showOrganizationDetails(dynamic organization) {
//     OrganizationDetailsSheet.show(
//       context,
//       organization,
//       () {
//         initGetCompany();
//         Get.to(() => CompanyWithOfferScreen(idOrganization: organization.id));
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: SafeArea(
//         top: false,
//         bottom: true,
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: Colors.transparent,
//           body: SliderDrawer(
//             key: _sliderKey,
//             appBar: AppBar(),
//             sliderOpenSize: 280,
//             slideDirection: SlideDirection.rightToLeft,
//             isDraggable: false,
//             slider: Obx(() {
//               final userData = drawerC.userData.value;
//               return AppDrawer(
//                 sliderKey: _sliderKey,
//                 userName: userData?.name ?? 'مستخدم',
//                 role: userData?.role ?? 'جديد',
//                 phone: userData?.phone ?? '',
//                 avatar: userData?.avatar ?? "",
//               );
//             }),
//             child: Obx(() {
//               if (mapC.isLoading.value && mapC.currentLocation.value == null) {
//                 return const Center(child: LoadingWidget());
//               }
//
//               final location = mapC.currentLocation.value;
//               if (location == null) return _buildLocationError();
//
//               return Stack(
//                 children: [
//                   // ===== Google Map =====
//                   Obx(() {
//                     final allMarkers = {
//                       ...offersC.markers.values,
//                       ..._hawajMarkers.values
//                     };
//
//                     return AnimatedBuilder(
//                       animation: _markerAnimationController,
//                       builder: (context, child) {
//                         return MapViewWidget(
//                           key: ValueKey('map_${allMarkers.length}'),
//                           location: location,
//                           onMapCreated: (controller) async {
//                             _mapController = controller;
//                             final style = await rootBundle
//                                 .loadString('assets/json/style_map.json');
//                             controller.setMapStyle(style);
//                             debugPrint('✅ Map ready');
//
//                             // معالجة بيانات Hawaj إذا كانت موجودة
//                             if (hawajC.hasHawajData) {
//                               Future.delayed(const Duration(milliseconds: 400),
//                                   () {
//                                 _processHawajData();
//                               });
//                             }
//                           },
//                           markers: allMarkers,
//                         );
//                       },
//                     );
//                   }),
//
//                   // ===== Top Bar =====
//                   Positioned(
//                     top: ManagerHeight.h48,
//                     left: ManagerWidth.w16,
//                     right: ManagerWidth.w16,
//                     child: MapTopBar(
//                       onMenuPressed: () => _sliderKey.currentState?.toggle(),
//                       onNotificationPressed: () {},
//                       hasNotifications: true,
//                     ),
//                   ),
//
//                   // 🎨 Floating Card - في الأعلى
//                   Positioned(
//                     top: ManagerHeight.h90, // تعديل من h110 إلى h90
//                     left: 0,
//                     right: 0,
//                     child: _buildFloatingCard(),
//                   ),
//
//                   // ===== Action Buttons =====
//                   Positioned(
//                     bottom: ManagerHeight.h30,
//                     right: ManagerWidth.w16,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // زر: الذهاب للنتائج
//                         if (offersC.hasData || _hawajMarkers.isNotEmpty)
//                           _buildActionButton(
//                             icon: Icons.location_searching,
//                             label: 'النتائج',
//                             onPressed: () {
//                               if (_hawajMarkers.isNotEmpty) {
//                                 _animateToHawajResults();
//                               } else {
//                                 _animateToBounds();
//                               }
//                             },
//                             color: ManagerColors.primaryColor,
//                           ),
//
//                         SizedBox(height: ManagerHeight.h12),
//
//                         // زر: موقعي
//                         _buildActionButton(
//                           icon: Icons.my_location,
//                           label: 'موقعي',
//                           onPressed: _goToUserLocation,
//                           color: Colors.blue,
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // ===== Loading Overlay =====
//                   _buildLoadingOverlay(),
//                 ],
//               );
//             }),
//           ),
//         ).withHawaj(
//           screen: HawajScreens.map,
//           section: _getDynamicSection(), // استخدام section (الطريقة الصحيحة)
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//   }) {
//     return Material(
//       elevation: 4,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.3), width: 2),
//           ),
//           child: Icon(icon, color: color, size: 28),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingOverlay() {
//     return Obx(() {
//       final isLoading = hawajC.isProcessing;
//
//       if (!isLoading) return const SizedBox.shrink();
//
//       return Container(
//         color: Colors.black.withOpacity(0.3),
//         child: Center(
//           child: Card(
//             margin: EdgeInsets.all(ManagerWidth.w20),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(ManagerWidth.w20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         ManagerColors.primaryColor),
//                   ),
//                   SizedBox(height: ManagerHeight.h16),
//                   Text(
//                     'جارٍ البحث عن أفضل النتائج...',
//                     style: getRegularTextStyle(
//                       fontSize: ManagerFontSize.s12,
//                       color: ManagerColors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildLocationError() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.location_off, size: 64, color: Colors.red),
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
//   /// 🎯 تحديد Section ديناميكياً حسب آخر نتائج
//   String _getDynamicSection() {
//     // تحديد حسب نوع البيانات الحالية
//     if (hawajC.hawajOffers.isNotEmpty) {
//       debugPrint('📍 Section: dailyOffers (1)');
//       return HawajSections.dailyOffers; // "1"
//     } else if (hawajC.hawajProperties.isNotEmpty) {
//       debugPrint('📍 Section: realEstates (3)');
//       return HawajSections.realEstates; // "3"
//     } else if (hawajC.hawajJobs.isNotEmpty) {
//       debugPrint('📍 Section: jobs (5)');
//       return HawajSections.jobs; // "5"
//     }
//
//     // default - العروض اليومية
//     debugPrint('📍 Section: default dailyOffers (1)');
//     return HawajSections.dailyOffers; // "1"
//   }
//
//   @override
//   void dispose() {
//     _mapController?.dispose();
//     _markerAnimationController.dispose();
//     _floatingCardController.dispose();
//     super.dispose();
//   }
// }
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_font_size.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
// import '../../../../users/offer_user/common_widgets_offer_user/organization_sheet_details.dart';
// import '../../../../users/offer_user/company_with_offer/domain/di/di.dart';
// import '../../../../users/offer_user/company_with_offer/presentation/pages/company_with_offer_screen.dart';
// import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
// import '../controller/drawer_controller.dart';
// import '../controller/map_controller.dart';
// import '../controller/map_sections_controller.dart';
// import '../managers/marker_icon_manager.dart';
// import '../managers/permission_manager.dart';
// import '../widgets/improved_drawer_widget.dart';
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
//   final drawerC = Get.find<MapDrawerController>();
//   final offersC = Get.find<OffersController>();
//
//   final GlobalKey<SliderDrawerState> _sliderKey =
//       GlobalKey<SliderDrawerState>();
//   final MarkerIconManager _iconManager = MarkerIconManager();
//
//   GoogleMapController? _mapController;
//   bool _isMapReady = false;
//   bool _isCameraMoving = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupSystemUI();
//     _initializeMap();
//     _setupListeners();
//
//     // 👇 تنفيذ تلقائي بعد بناء الشاشة لو جاي من Hawaj مع autoRefresh=true
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final args = Get.arguments;
//       final autoRefresh = args is Map &&
//           (args['autoRefresh'] == true || args['autoRefresh'] == 'true');
//
//       if (autoRefresh) {
//         if (mapC.currentLocation.value == null) {
//           await mapC.loadCurrentLocation();
//         }
//         final loc = mapC.currentLocation.value;
//         if (loc != null) {
//           offersC.isFirstLoad.value =
//               true; // يخلي ever(...) تعمل _animateToBounds
//           await offersC.fetchOffers(loc); // طلب جديد
//         }
//       }
//     });
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _setupSystemUI();
//   //   _initializeMap();
//   //   _setupListeners();
//   // }
//
//   /// إعداد Status Bar
//   void _setupSystemUI() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.transparent,
//     ));
//   }
//
//   /// تهيئة الخريطة
//   Future<void> _initializeMap() async {
//     await _iconManager.initialize();
//     final permission = await PermissionManager.handleLocationPermission();
//
//     if (permission.granted) {
//       await mapC.loadCurrentLocation();
//       setState(() => _isMapReady = true);
//     } else if (mounted && permission.message != null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(permission.message!)));
//     }
//   }
//
//   /// إعداد Listeners
//   void _setupListeners() {
//     // 1️⃣ عند تحديث الموقع - جلب بيانات القسم الحالي
//     ever(mapC.currentLocation, (location) {
//       if (location != null) {
//         sectionsC.updateLocation(location);
//         sectionsC.fetchSectionData(sectionsC.currentSection.value, location);
//       }
//     });
//
//     // 2️⃣ عند اختيار منظمة - فتح التفاصيل
//     ever(offersC.selectedOrganization, (org) {
//       if (org != null && mounted) {
//         _showOrganizationDetails(org);
//       }
//     });
//
//     // 3️⃣ عند تغيير القسم - جلب البيانات إذا لزم الأمر
//     ever(sectionsC.currentSection, (section) {
//       if (sectionsC.currentLocation.value != null) {
//         sectionsC.fetchSectionData(section, sectionsC.currentLocation.value!);
//       }
//     });
//     ever(offersC.goToResultsTrigger, (_) {
//       if (_mapController != null && offersC.hasData) {
//         // تأخير بسيط حتى تُرسم الماركرز
//         Future.delayed(const Duration(milliseconds: 300), () {
//           _animateToBounds();
//         });
//       }
//     });
//
//     // 4️⃣ 🎯 عند جلب المنظمات - تحريك الكاميرا لإظهار كل النتائج
//     ever(offersC.organizations, (orgs) {
//       if (orgs.isNotEmpty &&
//           _mapController != null &&
//           offersC.isFirstLoad.value) {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           _animateToBounds();
//           offersC.isFirstLoad.value = false;
//         });
//       }
//     });
//   }
//
//   /// 🎯 تحريك الكاميرا لإظهار جميع الماركرز
//   Future<void> _animateToBounds() async {
//     if (_mapController == null || _isCameraMoving) return;
//
//     final bounds = offersC.calculateBounds();
//     if (bounds == null) {
//       debugPrint('[MapScreen] ⚠️ لا يمكن حساب الـ Bounds');
//       return;
//     }
//
//     _isCameraMoving = true;
//
//     try {
//       debugPrint(
//           '[MapScreen] 📹 تحريك الكاميرا لإظهار ${offersC.organizationsCount} منظمة');
//
//       await _mapController!.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           bounds,
//           80, // padding
//         ),
//       );
//
//       await Future.delayed(const Duration(milliseconds: 800));
//     } catch (e) {
//       debugPrint('[MapScreen] ❌ خطأ في تحريك الكاميرا: $e');
//
//       // Fallback: الذهاب للمنظمة الأولى
//       if (offersC.organizations.isNotEmpty) {
//         final firstOrg = offersC.organizations.first;
//         final lat = offersC.parseDouble(firstOrg.lat);
//         final lng = offersC.parseDouble(firstOrg.lng);
//
//         if (lat != null && lng != null) {
//           await _mapController!.animateCamera(
//             CameraUpdate.newLatLngZoom(
//               LatLng(lat, lng),
//               14,
//             ),
//           );
//         }
//       }
//     } finally {
//       _isCameraMoving = false;
//     }
//   }
//
//   /// 🎯 الانتقال لموقع المستخدم
//   Future<void> _goToUserLocation() async {
//     if (_mapController == null || mapC.currentLocation.value == null) return;
//
//     _isCameraMoving = true;
//
//     try {
//       await _mapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(
//           LatLng(
//             mapC.currentLocation.value!.latitude,
//             mapC.currentLocation.value!.longitude,
//           ),
//           15,
//         ),
//       );
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('📍 موقعك الحالي'),
//             duration: Duration(seconds: 1),
//             backgroundColor: ManagerColors.primaryColor,
//           ),
//         );
//       }
//     } finally {
//       _isCameraMoving = false;
//     }
//   }
//
//   /// عرض تفاصيل المنظمة
//   void _showOrganizationDetails(dynamic organization) {
//     OrganizationDetailsSheet.show(
//       context,
//       organization,
//       () {
//         initGetCompany();
//         Get.to(() => CompanyWithOfferScreen(idOrganization: organization.id));
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: SafeArea(
//         top: false,
//         bottom: true,
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: Colors.transparent,
//           body: SliderDrawer(
//             key: _sliderKey,
//             appBar: AppBar(),
//             sliderOpenSize: 280,
//             slideDirection: SlideDirection.rightToLeft,
//             isDraggable: false,
//             slider: Obx(() {
//               final userData = drawerC.userData.value;
//               return AppDrawer(
//                 sliderKey: _sliderKey,
//                 userName: userData?.name ?? 'مستخدم',
//                 role: userData?.role ?? 'جديد',
//                 phone: userData?.phone ?? '',
//                 avatar: userData?.avatar ?? "",
//               );
//             }),
//             child: Obx(() {
//               // حالة التحميل الأولي للموقع
//               if (mapC.isLoading.value && mapC.currentLocation.value == null) {
//                 return const Center(child: LoadingWidget());
//               }
//
//               final location = mapC.currentLocation.value;
//               if (location == null) return _buildLocationError();
//
//               return Stack(
//                 children: [
//                   // ===== Google Map with reactive markers =====
//                   Obx(() {
//                     final markersSet = _buildMarkers();
//
//                     return MapViewWidget(
//                       key: ValueKey('map_${offersC.markers.length}'),
//                       location: location,
//                       onMapCreated: (controller) async {
//                         _mapController = controller;
//                         final style = await rootBundle
//                             .loadString('assets/json/style_map.json');
//                         controller.setMapStyle(style);
//                         debugPrint('[MapScreen] ✅ Map ready');
//
//                         // ✅ لو النتائج كانت جاهزة قبل تكوين الخريطة، حرّك فورًا
//                         if (offersC.hasData) {
//                           Future.delayed(const Duration(milliseconds: 300),
//                               _animateToBounds);
//                         }
//                       },
//                       // onMapCreated: (controller) async {
//                       //   _mapController = controller;
//                       //   final style = await rootBundle
//                       //       .loadString('assets/json/style_map.json');
//                       //   controller.setMapStyle(style);
//                       //   debugPrint('[MapScreen] ✅ Map ready');
//                       // },
//                       markers: markersSet,
//                     );
//                   }),
//
//                   // ===== Custom Top Bar =====
//                   Positioned(
//                     top: ManagerHeight.h48,
//                     left: ManagerWidth.w16,
//                     right: ManagerWidth.w16,
//                     child: MapTopBar(
//                       onMenuPressed: () => _sliderKey.currentState?.toggle(),
//                       onNotificationPressed: () {},
//                       hasNotifications: true,
//                     ),
//                   ),
//
//                   // ===== Action Buttons (يمين) =====
//                   Positioned(
//                     bottom: ManagerHeight.h120,
//                     right: ManagerWidth.w16,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // زر: الذهاب للنتائج
//                         if (offersC.hasData)
//                           _buildActionButton(
//                             icon: Icons.location_searching,
//                             label: 'النتائج',
//                             onPressed: _animateToBounds,
//                             color: ManagerColors.primaryColor,
//                           ),
//
//                         SizedBox(height: ManagerHeight.h12),
//
//                         // زر: موقعي
//                         _buildActionButton(
//                           icon: Icons.my_location,
//                           label: 'موقعي',
//                           onPressed: _goToUserLocation,
//                           color: Colors.blue,
//                         ),
//
//                         SizedBox(height: ManagerHeight.h12),
//
//                         // زر: تحديث
//                         _buildActionButton(
//                           icon: Icons.refresh,
//                           label: 'تحديث',
//                           onPressed: () {
//                             debugPrint('[MapScreen] 🔄 Manual refresh');
//                             offersC.refresh();
//                           },
//                           color: Colors.grey.shade700,
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // ===== Loading Overlay =====
//                   _buildLoadingOverlay(),
//
//                   // // ===== Results Counter =====
//                   // if (offersC.hasData)
//                   //   Positioned(
//                   //     bottom: ManagerHeight.h40,
//                   //     left: 0,
//                   //     right: 0,
//                   //     child: Center(
//                   //       child: Container(
//                   //         padding: EdgeInsets.symmetric(
//                   //           horizontal: ManagerWidth.w16,
//                   //           vertical: ManagerHeight.h8,
//                   //         ),
//                   //         decoration: BoxDecoration(
//                   //           color: ManagerColors.primaryColor,
//                   //           borderRadius:
//                   //               BorderRadius.circular(ManagerHeight.h20),
//                   //           boxShadow: [
//                   //             BoxShadow(
//                   //               color: Colors.black.withOpacity(0.2),
//                   //               blurRadius: 8,
//                   //               offset: const Offset(0, 2),
//                   //             ),
//                   //           ],
//                   //         ),
//                   //         child: Text(
//                   //           '${offersC.organizationsCount} منظمة قريبة',
//                   //           style: getBoldTextStyle(
//                   //             fontSize: ManagerFontSize.s12,
//                   //             color: Colors.white,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                 ],
//               );
//             }),
//           ),
//         ).withHawaj(
//           screen: HawajScreens.map,
//           section: HawajSections.dailyOffers,
//           // 🔊 Callback عند طلب حواج "offers"
//           onHawajCommand: (command) async {
//             final lower = command.toLowerCase();
//             if (lower.contains('عرض') ||
//                 lower.contains('offers') ||
//                 lower.contains('خريطة')) {
//               debugPrint(
//                   '[MapScreen] 🎯 Hawaj command detected -> refresh & animate');
//
//               // 1️⃣ تحميل الموقع الحالي مجددًا
//               if (mapC.currentLocation.value != null) {
//                 await offersC.fetchOffers(mapC.currentLocation.value!);
//               } else {
//                 await mapC.loadCurrentLocation();
//                 if (mapC.currentLocation.value != null) {
//                   await offersC.fetchOffers(mapC.currentLocation.value!);
//                 }
//               }
//
//               // 2️⃣ انتظار بسيط لحين اكتمال التحميل
//               Future.delayed(const Duration(milliseconds: 1500), () {
//                 _animateToBounds();
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   /// بناء Markers حسب القسم الحالي
//   Set<Marker> _buildMarkers() {
//     final currentSection = sectionsC.currentSection.value;
//
//     switch (currentSection) {
//       case MapSectionType.dailyOffers:
//         final markersCount = offersC.markers.length;
//         debugPrint('[MapScreen] 🏗️ Building $markersCount markers');
//
//         if (markersCount == 0) {
//           debugPrint('[MapScreen] ⚠️ No markers!');
//         }
//
//         return offersC.markers.values.toSet();
//
//       case MapSectionType.contracts:
//       case MapSectionType.realEstate:
//       case MapSectionType.delivery:
//       case MapSectionType.jobs:
//         return <Marker>{};
//     }
//   }
//
//   /// بناء زر action
//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//   }) {
//     return Material(
//       elevation: 4,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.3), width: 2),
//           ),
//           child: Icon(
//             icon,
//             color: color,
//             size: 28,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Loading Overlay
//   Widget _buildLoadingOverlay() {
//     return Obx(() {
//       final isLoading =
//           offersC.isLoading.value || sectionsC.isCurrentSectionLoading;
//
//       if (!isLoading) return const SizedBox.shrink();
//
//       return Container(
//         color: Colors.black.withOpacity(0.3),
//         child: Center(
//           child: Card(
//             margin: EdgeInsets.all(ManagerWidth.w20),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(ManagerWidth.w20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         ManagerColors.primaryColor),
//                   ),
//                   SizedBox(height: ManagerHeight.h16),
//                   Obx(() => Text(
//                         'جاري تحميل ${sectionsC.currentSectionName}...',
//                         style: getRegularTextStyle(
//                           fontSize: ManagerFontSize.s12,
//                           color: ManagerColors.black,
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   /// Location error widget
//   Widget _buildLocationError() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.location_off, size: 64, color: Colors.red),
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
//
//   /// 🔄 دالة عامة لتحريك الكاميرا بعد التحديث (يمكن استدعاؤها من أي مكان)
//   Future<void> animateToResults() async {
//     if (_mapController == null) return;
//
//     final bounds = offersC.calculateBounds();
//     if (bounds == null) {
//       debugPrint('[MapScreen] ⚠️ لا يمكن حساب الـ Bounds');
//       return;
//     }
//
//     await _mapController!.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 80),
//     );
//
//     debugPrint('[MapScreen] ✅ الكاميرا تحركت لعرض النتائج الجديدة');
//   }
// }
