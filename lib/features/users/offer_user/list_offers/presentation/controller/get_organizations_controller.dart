import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/model/orgnization_company_daily_offer_item_model.dart';
import '../../../../../common/map/domain/entities/location_entity.dart';
import '../../../../../common/map/presenation/managers/marker_icon_manager.dart';
import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
import '../../domain/use_cases/get_organizations_use_case.dart';

/// Controller لإدارة المنظمات والعروض على الخريطة
class OffersController extends GetxController {
  final GetOrganizationsUseCase _getOrganizationsUseCase;
  final MarkerIconManager _markerIconManager;

  OffersController(
    this._getOrganizationsUseCase,
    this._markerIconManager,
  );

  // ===== Observable States =====
  /// قائمة المنظمات (مرتبة من الـ API حسب القرب)
  final RxList<OrganizationCompanyDailyOfferItemModel> organizations =
      <OrganizationCompanyDailyOfferItemModel>[].obs;

  /// الماركرز على الخريطة
  final RxMap<int, Marker> markers = <int, Marker>{}.obs;

  /// حالة التحميل
  final RxBool isLoading = false.obs;

  /// رسالة الخطأ
  final RxString errorMessage = ''.obs;

  /// موقع المستخدم الحالي
  final Rxn<LocationEntity> currentLocation = Rxn<LocationEntity>();

  /// المنظمة المختارة
  final Rxn<OrganizationCompanyDailyOfferItemModel> selectedOrganization =
      Rxn<OrganizationCompanyDailyOfferItemModel>();

  @override
  void onInit() {
    super.onInit();
    _initializeMarkerManager();
  }

  /// تهيئة مدير الأيقونات
  Future<void> _initializeMarkerManager() async {
    await _markerIconManager.initialize();
  }

  /// جلب المنظمات القريبة من موقع المستخدم
  Future<void> fetchOffers(LocationEntity location) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentLocation.value = location;

      if (kDebugMode) {
        print('[OffersController] 🔄 جاري جلب المنظمات...');
        print(
            '[OffersController] 📍 الموقع: ${location.latitude}, ${location.longitude}');
      }

      // إنشاء الطلب مع موقع المستخدم
      final request = GetOrganizationsRequest(
        lat: location.latitude.toString(),
        lng: location.longitude.toString(),
        language: Get.locale?.languageCode ?? 'ar',
      );

      // استدعاء UseCase
      final result = await _getOrganizationsUseCase.execute(request);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          if (kDebugMode) {
            print('[OffersController] ❌ خطأ: ${failure.message}');
          }
        },
        (response) async {
          if (response.error) {
            errorMessage.value = response.message;
            if (kDebugMode) {
              print('[OffersController] ⚠️ ${response.message}');
            }
            return;
          }

          // حفظ البيانات (مرتبة من الـ API)
          await _processOrganizations(response.data);

          if (kDebugMode) {
            print('[OffersController] ✅ تم جلب ${organizations.length} منظمة');
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      if (kDebugMode) {
        print('[OffersController] 💥 Exception: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// معالجة البيانات وإنشاء الماركرز
  Future<void> _processOrganizations(
    List<OrganizationCompanyDailyOfferItemModel> data,
  ) async {
    // تصفية المنظمات التي لديها إحداثيات صالحة
    final validOrgs = data.where((org) {
      final lat = _parseDouble(org.lat);
      final lng = _parseDouble(org.lng);
      return lat != null && lng != null && lat != 0 && lng != 0;
    }).toList();

    if (validOrgs.isEmpty) {
      if (kDebugMode) {
        print('[OffersController] ⚠️ لا توجد منظمات بإحداثيات صالحة');
      }
      return;
    }

    // حفظ البيانات (الـ API يرجعها مرتبة)
    organizations.value = validOrgs;

    // إنشاء الماركرز
    await _createMarkers(validOrgs);

    if (kDebugMode) {
      print('[OffersController] 📊 المنظمات المرتبة من الـ API:');
      for (var i = 0; i < validOrgs.length && i < 5; i++) {
        final org = validOrgs[i];
        print('  ${i + 1}. ${org.organization}');
      }
    }
  }

  /// إنشاء Markers للمنظمات
  Future<void> _createMarkers(
    List<OrganizationCompanyDailyOfferItemModel> orgs,
  ) async {
    markers.clear();

    for (var i = 0; i < orgs.length; i++) {
      final org = orgs[i];
      final lat = _parseDouble(org.lat);
      final lng = _parseDouble(org.lng);

      if (lat == null || lng == null) continue;

      // لون الماركر حسب الترتيب (الأقرب أخضر)
      final color = _getMarkerColorByIndex(i, orgs.length);

      // إنشاء أيقونة مخصصة
      final icon = await _markerIconManager.getIcon(
        key: 'org_${org.id}',
        color: color,
        imageUrl: org.organizationLogo,
      );

      final marker = Marker(
        markerId: MarkerId('org_${org.id}'),
        position: LatLng(lat, lng),
        icon: icon,
        anchor: const Offset(0.5, 1.0),
        infoWindow: InfoWindow(
          title: org.organization,
          snippet: 'اضغط لعرض التفاصيل',
        ),
        onTap: () => _onMarkerTapped(org),
      );

      markers[org.id] = marker;
    }

    if (kDebugMode) {
      print('[OffersController] 📍 تم إنشاء ${markers.length} ماركر');
    }
  }

  /// اختيار لون الماركر حسب الترتيب
  /// الأوائل بألوان دافئة، والبقية بألوان باردة
  Color _getMarkerColorByIndex(int index, int total) {
    if (index < 3) {
      // أول 3 منظمات: أخضر
      return Colors.green;
    } else if (index < 10) {
      // من 4 إلى 10: أزرق
      return Colors.blue;
    } else if (index < 20) {
      // من 11 إلى 20: برتقالي
      return Colors.orange;
    } else {
      // الباقي: رمادي
      return Colors.grey;
    }
  }

  /// عند الضغط على الماركر
  void _onMarkerTapped(OrganizationCompanyDailyOfferItemModel org) {
    selectedOrganization.value = org;

    if (kDebugMode) {
      print('[OffersController] 👆 تم اختيار: ${org.organization}');
    }
  }

  /// الانتقال لتفاصيل المنظمة
  void navigateToOrganizationDetails(int organizationId) {
    if (kDebugMode) {
      print('[OffersController] 🚀 الانتقال لتفاصيل المنظمة: $organizationId');
    }

    // TODO: أضف التنقل لصفحة التفاصيل
    // initGetCompany();
    // Get.to(() => CompanyWithOfferScreen(idOrganization: organizationId));
  }

  /// إعادة جلب البيانات
  Future<void> refresh() async {
    if (currentLocation.value != null) {
      await fetchOffers(currentLocation.value!);
    }
  }

  /// البحث عن منظمة بالاسم
  List<OrganizationCompanyDailyOfferItemModel> searchOrganizations(
    String query,
  ) {
    if (query.isEmpty) return organizations;

    return organizations.where((org) {
      return org.organization.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// الحصول على أول N منظمة
  List<OrganizationCompanyDailyOfferItemModel> getTopOrganizations({
    int limit = 5,
  }) {
    return organizations.take(limit).toList();
  }

  /// تحويل String/int/double إلى double
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // ===== Getters =====

  /// الحصول على Set الماركرز للخريطة
  Set<Marker> get markerSet => markers.values.toSet();

  /// هل توجد بيانات
  bool get hasData => organizations.isNotEmpty;

  /// عدد المنظمات
  int get organizationsCount => organizations.length;

  @override
  void onClose() {
    _markerIconManager.clearCache();
    super.onClose();
  }
}
