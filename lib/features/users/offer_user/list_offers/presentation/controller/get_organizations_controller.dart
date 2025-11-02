import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/model/orgnization_company_daily_offer_item_model.dart';
import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../common/map/domain/entities/location_entity.dart';
import '../../../../../common/map/presenation/managers/custom_marker_painter.dart';
import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
import '../../domain/use_cases/get_organizations_use_case.dart';

/// Controller محسّن لإدارة المنظمات على الخريطة
class OffersController extends GetxController {
  final GetOrganizationsUseCase _getOrganizationsUseCase;

  OffersController(this._getOrganizationsUseCase);

  // ===== Observable States =====
  final RxList<OrganizationCompanyDailyOfferItemModel> organizations =
      <OrganizationCompanyDailyOfferItemModel>[].obs;

  final RxMap<String, Marker> markers = <String, Marker>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<LocationEntity> currentLocation = Rxn<LocationEntity>();
  final Rxn<OrganizationCompanyDailyOfferItemModel> selectedOrganization =
      Rxn<OrganizationCompanyDailyOfferItemModel>();

  /// هل تم جلب البيانات للمرة الأولى
  final RxBool isFirstLoad = true.obs;

  /// ✅ تريغر لإبلاغ واجهة الخريطة بالانتقال التلقائي إلى النتائج
  /// ملاحظة: نبدّل القيمة (toggle) كل مرة لضمان إطلاق الحدث.
  final RxBool goToResultsTrigger = false.obs;

  void _notifyGoToResults() {
    goToResultsTrigger.value = !goToResultsTrigger.value;
  }

  /// الحد الأقصى للمسافة (كم) - للفلترة
  /// ⚠️ مُعطّل حالياً - سيتم تفعيله لاحقاً
  static const double maxDistanceKm = 100.0;

  /// جلب المنظمات القريبة
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

      final request = GetOrganizationsRequest(
        lat: location.latitude.toString(),
        lng: location.longitude.toString(),
        language: Get.locale?.languageCode ?? 'ar',
      );

      final result = await _getOrganizationsUseCase.execute(request);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          if (kDebugMode) {
            print('[OffersController] ❌ خطأ: ${failure.message}');
          }
        },
        (response) {
          if (response.error) {
            errorMessage.value = response.message;
            if (kDebugMode) {
              print('[OffersController] ⚠️ ${response.message}');
            }
            return;
          }

          _processOrganizations(response.data);

          if (kDebugMode) {
            print('[OffersController] ✅ تم جلب ${organizations.length} منظمة');
          }

          // ✅ بعد تجهيز النتائج بنجاح: أطلق تريغر "اذهب للنتائج"
          if (organizations.isNotEmpty) {
            _notifyGoToResults();
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

  /// معالجة البيانات وإنشاء الماركرز (محسّن + فلترة قوية)
  void _processOrganizations(
    List<OrganizationCompanyDailyOfferItemModel> data,
  ) {
    if (currentLocation.value == null) {
      if (kDebugMode) {
        print('[OffersController] ❌ موقع المستخدم غير متوفر');
      }
      return;
    }

    final userLat = currentLocation.value!.latitude;
    final userLng = currentLocation.value!.longitude;

    // تصفية المنظمات ذات الإحداثيات الصالحة والقريبة
    final validOrgs = data.where((org) {
      final lat = _parseDouble(org.lat);
      final lng = _parseDouble(org.lng);

      // ✅ التحقق من صحة القيم الأساسية
      if (lat == null || lng == null) {
        if (kDebugMode) {
          print('[OffersController] ❌ إحداثيات null: ${org.organization}');
        }
        return false;
      }

      // ✅ التحقق من أن القيم ضمن النطاق الجغرافي الصحيح
      if (lat == 0 || lng == 0 || lat.abs() > 90 || lng.abs() > 180) {
        if (kDebugMode) {
          print(
              '[OffersController] ❌ إحداثيات غير صالحة: ${org.organization} - ($lat, $lng)');
        }
        return false;
      }

      // ✅ فلترة القيم الثابتة المشبوهة (مثل 23.333, 23.333)
      final latStr = lat.toStringAsFixed(3);
      final lngStr = lng.toStringAsFixed(3);
      if (latStr == lngStr && latStr == '23.333') {
        if (kDebugMode) {
          print(
              '[OffersController] ❌ إحداثيات مشبوهة (23.333, 23.333): ${org.organization}');
        }
        return false;
      }

      // ✅ حساب المسافة من موقع المستخدم (معطّل مؤقتاً)
      // final distance = _calculateDistance(userLat, userLng, lat, lng);

      // ✅ فلترة المنظمات البعيدة جداً (معطّل مؤقتاً)
      // TODO: تفعيل الفلترة لاحقاً عندما تكون البيانات صحيحة
      // if (distance > maxDistanceKm) {
      //   if (kDebugMode) {
      //     print(
      //         '[OffersController] ⚠️ منظمة بعيدة جداً: ${org.organization} - ${distance.toStringAsFixed(1)} كم');
      //   }
      //   return false;
      // }

      return true;
    }).toList();

    if (validOrgs.isEmpty) {
      if (kDebugMode) {
        print('[OffersController] ⚠️ لا توجد منظمات قريبة صالحة');
      }
      organizations.value = [];
      markers.clear();
      return;
    }

    organizations.value = validOrgs;
    _createCustomMarkers(validOrgs);

    if (kDebugMode) {
      print('[OffersController] 📊 المنظمات الصالحة: ${validOrgs.length}');
      print('[OffersController] 📍 موقع المستخدم: $userLat, $userLng');

      // 🔍 طباعة كل المنظمات لإيجاد المشكلة
      print('[OffersController] 📋 قائمة كل المنظمات:');
      for (var i = 0; i < validOrgs.length; i++) {
        final org = validOrgs[i];
        final lat = _parseDouble(org.lat);
        final lng = _parseDouble(org.lng);

        if (lat != null && lng != null) {
          final distance = _calculateDistance(userLat, userLng, lat, lng);
          print(
              '  ${i + 1}. ${org.organization} -> ($lat, $lng) - ${distance.toStringAsFixed(1)} كم');
        } else {
          print('  ${i + 1}. ${org.organization} -> (NULL COORDINATES!) ❌');
        }
      }
    }
  }

  /// حساب المسافة بين نقطتين (Haversine formula) بالكيلومتر
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371.0; // نصف قطر الأرض بالكيلومتر

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// تحويل الدرجات إلى راديان
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  /// إنشاء Markers مخصصة بالـ Primary Color ⚡
  Future<void> _createCustomMarkers(
    List<OrganizationCompanyDailyOfferItemModel> orgs,
  ) async {
    markers.clear();

    for (var i = 0; i < orgs.length; i++) {
      final org = orgs[i];
      final lat = _parseDouble(org.lat);
      final lng = _parseDouble(org.lng);

      if (lat == null || lng == null) continue;

      // استخدام ألوان متدرجة بناءً على القرب
      final color = _getMarkerColor(i, orgs.length);

      // إنشاء marker مخصص
      final icon = await CustomMarkerPainter.createCustomMarker(
        color: color,
        label: '${i + 1}', // رقم الترتيب
      );

      final marker = Marker(
        markerId: MarkerId('org_${org.id}'),
        position: LatLng(lat, lng),
        icon: icon,
        infoWindow: InfoWindow(
          title: org.organization,
          snippet: '${org.offers?.length ?? 0} عرض متاح',
        ),
        onTap: () => _onMarkerTapped(org),
        visible: true,
        anchor: const Offset(0.5, 0.5), // مركز الـ marker
      );

      markers[org.id.toString()] = marker;
    }

    if (kDebugMode) {
      print('[OffersController] 📍 تم إنشاء ${markers.length} custom marker');
    }
  }

  /// اختيار لون الماركر حسب القرب (Primary Color + تدرجات)
  Color _getMarkerColor(int index, int total) {
    const primaryColor = ManagerColors.primaryColor; // 0xFF128C7E

    // الأقرب -> الأبعد: primary (أخضر غامق) -> أزرق -> برتقالي -> أحمر
    if (index < 3) {
      return primaryColor; // أول 3 - primary color
    } else if (index < 10) {
      return const Color(0xFF25D366); // 4-10 - أخضر فاتح
    } else if (index < 15) {
      return const Color(0xFF34B7F1); // 11-15 - أزرق
    } else {
      return const Color(0xFFFF6B6B); // الباقي - أحمر
    }
  }

  /// 🎯 حساب الـ Bounds (محسّن)
  LatLngBounds? calculateBounds() {
    if (kDebugMode) {
      print('[OffersController] 🔍 محاولة حساب Bounds...');
      print('[OffersController] - عدد المنظمات: ${organizations.length}');
      print(
          '[OffersController] - موقع المستخدم: ${currentLocation.value?.latitude}, ${currentLocation.value?.longitude}');

      // 🔍 طباعة أول 10 منظمات لتحليل المشكلة
      print('[OffersController] 📋 أول 10 منظمات:');
      for (var i = 0; i < organizations.length && i < 10; i++) {
        final org = organizations[i];
        final lat = _parseDouble(org.lat);
        final lng = _parseDouble(org.lng);
        if (lat != null && lng != null) {
          final distance = _calculateDistance(
            currentLocation.value!.latitude,
            currentLocation.value!.longitude,
            lat,
            lng,
          );
          print(
              '  ${i + 1}. ${org.organization}: ($lat, $lng) - ${distance.toStringAsFixed(1)} كم');
        }
      }
    }

    if (organizations.isEmpty) {
      if (kDebugMode) {
        print('[OffersController] ❌ لا توجد منظمات لحساب Bounds');
      }
      return null;
    }

    if (currentLocation.value == null) {
      if (kDebugMode) {
        print('[OffersController] ❌ موقع المستخدم غير متوفر');
      }
      return null;
    }

    // ✅ حساب الـ Bounds بناءً على المنظمات فقط (بدون موقع المستخدم)
    double? minLat;
    double? maxLat;
    double? minLng;
    double? maxLng;

    int validCoordinatesCount = 0;

    // إضافة مواقع المنظمات (مع فلترة القيم الغريبة)
    for (final org in organizations) {
      final lat = _parseDouble(org.lat);
      final lng = _parseDouble(org.lng);

      // ✅ فلترة القيم الغريبة في حساب الـ Bounds
      if (lat != null &&
          lng != null &&
          lat != 0 &&
          lng != 0 &&
          lat.abs() <= 90 &&
          lng.abs() <= 180) {
        // تجنب القيمة المشبوهة (23.333, 23.333)
        final latStr = lat.toStringAsFixed(3);
        final lngStr = lng.toStringAsFixed(3);
        if (latStr == '23.333' && lngStr == '23.333') {
          if (kDebugMode) {
            print(
                '[OffersController] ⚠️ تجاهل coordinates مشبوهة في Bounds: ${org.organization}');
          }
          continue;
        }

        // Initialize or update bounds
        if (minLat == null || lat < minLat) minLat = lat;
        if (maxLat == null || lat > maxLat) maxLat = lat;
        if (minLng == null || lng < minLng) minLng = lng;
        if (maxLng == null || lng > maxLng) maxLng = lng;
        validCoordinatesCount++;
      }
    }

    if (validCoordinatesCount == 0 ||
        minLat == null ||
        maxLat == null ||
        minLng == null ||
        maxLng == null) {
      if (kDebugMode) {
        print('[OffersController] ⚠️ لا توجد إحداثيات صالحة لحساب Bounds');
      }
      // استخدام موقع المستخدم فقط مع zoom قريب
      const delta = 0.05; // حوالي 5 كم
      minLat = currentLocation.value!.latitude - delta;
      maxLat = currentLocation.value!.latitude + delta;
      minLng = currentLocation.value!.longitude - delta;
      maxLng = currentLocation.value!.longitude + delta;
    }

    // حد أدنى للـ bounds (1km تقريباً)
    const minDelta = 0.015;
    if (maxLat - minLat < minDelta) {
      final center = (maxLat + minLat) / 2;
      minLat = center - minDelta / 2;
      maxLat = center + minDelta / 2;
    }
    if (maxLng - minLng < minDelta) {
      final center = (maxLng + minLng) / 2;
      minLng = center - minDelta / 2;
      maxLng = center + minDelta / 2;
    }

    if (kDebugMode) {
      print('[OffersController] ✅ Bounds محسوبة:');
      print('[OffersController] - إحداثيات صالحة: $validCoordinatesCount');
      print(
          '[OffersController] - SW: (${minLat.toStringAsFixed(6)}, ${minLng.toStringAsFixed(6)})');
      print(
          '[OffersController] - NE: (${maxLat.toStringAsFixed(6)}, ${maxLng.toStringAsFixed(6)})');
      print(
          '[OffersController] - Width: ${(maxLng - minLng).toStringAsFixed(3)}°');
      print(
          '[OffersController] - Height: ${(maxLat - minLat).toStringAsFixed(3)}°');

      // حساب المسافة التقريبية
      final widthKm =
          (maxLng - minLng) * 111.0; // 1° longitude ≈ 111 km at equator
      final heightKm = (maxLat - minLat) * 111.0; // 1° latitude ≈ 111 km
      print(
          '[OffersController] - تقريباً: ${widthKm.toStringAsFixed(1)} × ${heightKm.toStringAsFixed(1)} كم');
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// عند الضغط على الماركر
  void _onMarkerTapped(OrganizationCompanyDailyOfferItemModel org) {
    selectedOrganization.value = org;
    if (kDebugMode) {
      print('[OffersController] 👆 تم اختيار: ${org.organization}');
    }
  }

  /// إعادة جلب البيانات
  Future<void> refresh() async {
    if (currentLocation.value != null) {
      isFirstLoad.value = true;
      await fetchOffers(currentLocation.value!);
      // ملاحظة: fetchOffers سيطلق التريغر تلقائياً عند وجود بيانات
    }
  }

  /// تحويل إلى double (public method)
  double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  /// تحويل إلى double (private - للاستخدام الداخلي)
  double? _parseDouble(dynamic value) => parseDouble(value);

  // ===== Getters =====
  Set<Marker> get markerSet => markers.values.toSet();

  bool get hasData => organizations.isNotEmpty;

  int get organizationsCount => organizations.length;
}

// import 'dart:math' as math;
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../../../core/model/orgnization_company_daily_offer_item_model.dart';
// import '../../../../../../core/resources/manager_colors.dart';
// import '../../../../../common/map/domain/entities/location_entity.dart';
// import '../../../../../common/map/presenation/managers/custom_marker_painter.dart';
// import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
// import '../../domain/use_cases/get_organizations_use_case.dart';
//
// /// Controller محسّن لإدارة المنظمات على الخريطة
// class OffersController extends GetxController {
//   final GetOrganizationsUseCase _getOrganizationsUseCase;
//
//   OffersController(this._getOrganizationsUseCase);
//
//   // ===== Observable States =====
//   final RxList<OrganizationCompanyDailyOfferItemModel> organizations =
//       <OrganizationCompanyDailyOfferItemModel>[].obs;
//
//   final RxMap<int, Marker> markers = <int, Marker>{}.obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final Rxn<LocationEntity> currentLocation = Rxn<LocationEntity>();
//   final Rxn<OrganizationCompanyDailyOfferItemModel> selectedOrganization =
//       Rxn<OrganizationCompanyDailyOfferItemModel>();
//
//   /// هل تم جلب البيانات للمرة الأولى
//   final RxBool isFirstLoad = true.obs;
//
//   /// الحد الأقصى للمسافة (كم) - للفلترة
//   /// ⚠️ مُعطّل حالياً - سيتم تفعيله لاحقاً
//   static const double maxDistanceKm = 100.0;
//
//   /// جلب المنظمات القريبة
//   Future<void> fetchOffers(LocationEntity location) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       currentLocation.value = location;
//
//       if (kDebugMode) {
//         print('[OffersController] 🔄 جاري جلب المنظمات...');
//         print(
//             '[OffersController] 📍 الموقع: ${location.latitude}, ${location.longitude}');
//       }
//
//       final request = GetOrganizationsRequest(
//         lat: location.latitude.toString(),
//         lng: location.longitude.toString(),
//         language: Get.locale?.languageCode ?? 'ar',
//       );
//
//       final result = await _getOrganizationsUseCase.execute(request);
//
//       result.fold(
//         (failure) {
//           errorMessage.value = failure.message;
//           if (kDebugMode) {
//             print('[OffersController] ❌ خطأ: ${failure.message}');
//           }
//         },
//         (response) {
//           if (response.error) {
//             errorMessage.value = response.message;
//             if (kDebugMode) {
//               print('[OffersController] ⚠️ ${response.message}');
//             }
//             return;
//           }
//
//           _processOrganizations(response.data);
//
//           if (kDebugMode) {
//             print('[OffersController] ✅ تم جلب ${organizations.length} منظمة');
//           }
//         },
//       );
//     } catch (e) {
//       errorMessage.value = 'حدث خطأ غير متوقع';
//       if (kDebugMode) {
//         print('[OffersController] 💥 Exception: $e');
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// معالجة البيانات وإنشاء الماركرز (محسّن + فلترة قوية)
//   void _processOrganizations(
//     List<OrganizationCompanyDailyOfferItemModel> data,
//   ) {
//     if (currentLocation.value == null) {
//       if (kDebugMode) {
//         print('[OffersController] ❌ موقع المستخدم غير متوفر');
//       }
//       return;
//     }
//
//     final userLat = currentLocation.value!.latitude;
//     final userLng = currentLocation.value!.longitude;
//
//     // تصفية المنظمات ذات الإحداثيات الصالحة والقريبة
//     final validOrgs = data.where((org) {
//       final lat = _parseDouble(org.lat);
//       final lng = _parseDouble(org.lng);
//
//       // ✅ التحقق من صحة القيم الأساسية
//       if (lat == null || lng == null) {
//         if (kDebugMode) {
//           print('[OffersController] ❌ إحداثيات null: ${org.organization}');
//         }
//         return false;
//       }
//
//       // ✅ التحقق من أن القيم ضمن النطاق الجغرافي الصحيح
//       if (lat == 0 || lng == 0 || lat.abs() > 90 || lng.abs() > 180) {
//         if (kDebugMode) {
//           print(
//               '[OffersController] ❌ إحداثيات غير صالحة: ${org.organization} - ($lat, $lng)');
//         }
//         return false;
//       }
//
//       // ✅ فلترة القيم الثابتة المشبوهة (مثل 23.333, 23.333)
//       final latStr = lat.toStringAsFixed(3);
//       final lngStr = lng.toStringAsFixed(3);
//       if (latStr == lngStr && latStr == '23.333') {
//         if (kDebugMode) {
//           print(
//               '[OffersController] ❌ إحداثيات مشبوهة (23.333, 23.333): ${org.organization}');
//         }
//         return false;
//       }
//
//       // ✅ حساب المسافة من موقع المستخدم (معطّل مؤقتاً)
//       // final distance = _calculateDistance(userLat, userLng, lat, lng);
//
//       // ✅ فلترة المنظمات البعيدة جداً (معطّل مؤقتاً)
//       // TODO: تفعيل الفلترة لاحقاً عندما تكون البيانات صحيحة
//       // if (distance > maxDistanceKm) {
//       //   if (kDebugMode) {
//       //     print(
//       //         '[OffersController] ⚠️ منظمة بعيدة جداً: ${org.organization} - ${distance.toStringAsFixed(1)} كم');
//       //   }
//       //   return false;
//       // }
//
//       return true;
//     }).toList();
//
//     if (validOrgs.isEmpty) {
//       if (kDebugMode) {
//         print('[OffersController] ⚠️ لا توجد منظمات قريبة صالحة');
//       }
//       organizations.value = [];
//       markers.clear();
//       return;
//     }
//
//     organizations.value = validOrgs;
//     _createCustomMarkers(validOrgs);
//
//     if (kDebugMode) {
//       print('[OffersController] 📊 المنظمات الصالحة: ${validOrgs.length}');
//       print('[OffersController] 📍 موقع المستخدم: $userLat, $userLng');
//
//       // 🔍 طباعة كل المنظمات لإيجاد المشكلة
//       print('[OffersController] 📋 قائمة كل المنظمات:');
//       for (var i = 0; i < validOrgs.length; i++) {
//         final org = validOrgs[i];
//         final lat = _parseDouble(org.lat);
//         final lng = _parseDouble(org.lng);
//
//         if (lat != null && lng != null) {
//           final distance = _calculateDistance(userLat, userLng, lat, lng);
//           print(
//               '  ${i + 1}. ${org.organization} -> ($lat, $lng) - ${distance.toStringAsFixed(1)} كم');
//         } else {
//           print('  ${i + 1}. ${org.organization} -> (NULL COORDINATES!) ❌');
//         }
//       }
//     }
//   }
//
//   /// حساب المسافة بين نقطتين (Haversine formula) بالكيلومتر
//   double _calculateDistance(
//       double lat1, double lon1, double lat2, double lon2) {
//     const earthRadius = 6371.0; // نصف قطر الأرض بالكيلومتر
//
//     final dLat = _degreesToRadians(lat2 - lat1);
//     final dLon = _degreesToRadians(lon2 - lon1);
//
//     final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_degreesToRadians(lat1)) *
//             math.cos(_degreesToRadians(lat2)) *
//             math.sin(dLon / 2) *
//             math.sin(dLon / 2);
//
//     final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//
//     return earthRadius * c;
//   }
//
//   /// تحويل الدرجات إلى راديان
//   double _degreesToRadians(double degrees) {
//     return degrees * math.pi / 180.0;
//   }
//
//   /// إنشاء Markers مخصصة بالـ Primary Color ⚡
//   Future<void> _createCustomMarkers(
//     List<OrganizationCompanyDailyOfferItemModel> orgs,
//   ) async {
//     markers.clear();
//
//     for (var i = 0; i < orgs.length; i++) {
//       final org = orgs[i];
//       final lat = _parseDouble(org.lat);
//       final lng = _parseDouble(org.lng);
//
//       if (lat == null || lng == null) continue;
//
//       // استخدام ألوان متدرجة بناءً على القرب
//       final color = _getMarkerColor(i, orgs.length);
//
//       // إنشاء marker مخصص
//       final icon = await CustomMarkerPainter.createCustomMarker(
//         color: color,
//         label: '${i + 1}', // رقم الترتيب
//       );
//
//       final marker = Marker(
//         markerId: MarkerId('org_${org.id}'),
//         position: LatLng(lat, lng),
//         icon: icon,
//         infoWindow: InfoWindow(
//           title: org.organization,
//           snippet: '${org.offers?.length ?? 0} عرض متاح',
//         ),
//         onTap: () => _onMarkerTapped(org),
//         visible: true,
//         anchor: const Offset(0.5, 0.5), // مركز الـ marker
//       );
//
//       markers[org.id] = marker;
//     }
//
//     if (kDebugMode) {
//       print('[OffersController] 📍 تم إنشاء ${markers.length} custom marker');
//     }
//   }
//
//   /// اختيار لون الماركر حسب القرب (Primary Color + تدرجات)
//   Color _getMarkerColor(int index, int total) {
//     const primaryColor = ManagerColors.primaryColor; // 0xFF128C7E
//
//     // الأقرب -> الأبعد: primary (أخضر غامق) -> أزرق -> برتقالي -> أحمر
//     if (index < 3) {
//       return primaryColor; // أول 3 - primary color
//     } else if (index < 10) {
//       return const Color(0xFF25D366); // 4-10 - أخضر فاتح
//     } else if (index < 15) {
//       return const Color(0xFF34B7F1); // 11-15 - أزرق
//     } else {
//       return const Color(0xFFFF6B6B); // الباقي - أحمر
//     }
//   }
//
//   /// 🎯 حساب الـ Bounds (محسّن)
//   LatLngBounds? calculateBounds() {
//     if (kDebugMode) {
//       print('[OffersController] 🔍 محاولة حساب Bounds...');
//       print('[OffersController] - عدد المنظمات: ${organizations.length}');
//       print(
//           '[OffersController] - موقع المستخدم: ${currentLocation.value?.latitude}, ${currentLocation.value?.longitude}');
//
//       // 🔍 طباعة أول 10 منظمات لتحليل المشكلة
//       print('[OffersController] 📋 أول 10 منظمات:');
//       for (var i = 0; i < organizations.length && i < 10; i++) {
//         final org = organizations[i];
//         final lat = _parseDouble(org.lat);
//         final lng = _parseDouble(org.lng);
//         if (lat != null && lng != null) {
//           final distance = _calculateDistance(
//             currentLocation.value!.latitude,
//             currentLocation.value!.longitude,
//             lat,
//             lng,
//           );
//           print(
//               '  ${i + 1}. ${org.organization}: ($lat, $lng) - ${distance.toStringAsFixed(1)} كم');
//         }
//       }
//     }
//
//     if (organizations.isEmpty) {
//       if (kDebugMode) {
//         print('[OffersController] ❌ لا توجد منظمات لحساب Bounds');
//       }
//       return null;
//     }
//
//     if (currentLocation.value == null) {
//       if (kDebugMode) {
//         print('[OffersController] ❌ موقع المستخدم غير متوفر');
//       }
//       return null;
//     }
//
//     // ✅ حساب الـ Bounds بناءً على المنظمات فقط (بدون موقع المستخدم)
//     double? minLat;
//     double? maxLat;
//     double? minLng;
//     double? maxLng;
//
//     int validCoordinatesCount = 0;
//
//     // إضافة مواقع المنظمات (مع فلترة القيم الغريبة)
//     for (final org in organizations) {
//       final lat = _parseDouble(org.lat);
//       final lng = _parseDouble(org.lng);
//
//       // ✅ فلترة القيم الغريبة في حساب الـ Bounds
//       if (lat != null &&
//           lng != null &&
//           lat != 0 &&
//           lng != 0 &&
//           lat.abs() <= 90 &&
//           lng.abs() <= 180) {
//         // تجنب القيمة المشبوهة (23.333, 23.333)
//         final latStr = lat.toStringAsFixed(3);
//         final lngStr = lng.toStringAsFixed(3);
//         if (latStr == '23.333' && lngStr == '23.333') {
//           if (kDebugMode) {
//             print(
//                 '[OffersController] ⚠️ تجاهل coordinates مشبوهة في Bounds: ${org.organization}');
//           }
//           continue;
//         }
//
//         // Initialize or update bounds
//         if (minLat == null || lat < minLat) minLat = lat;
//         if (maxLat == null || lat > maxLat) maxLat = lat;
//         if (minLng == null || lng < minLng) minLng = lng;
//         if (maxLng == null || lng > maxLng) maxLng = lng;
//         validCoordinatesCount++;
//       }
//     }
//
//     if (validCoordinatesCount == 0 ||
//         minLat == null ||
//         maxLat == null ||
//         minLng == null ||
//         maxLng == null) {
//       if (kDebugMode) {
//         print('[OffersController] ⚠️ لا توجد إحداثيات صالحة لحساب Bounds');
//       }
//       // استخدام موقع المستخدم فقط مع zoom قريب
//       const delta = 0.05; // حوالي 5 كم
//       minLat = currentLocation.value!.latitude - delta;
//       maxLat = currentLocation.value!.latitude + delta;
//       minLng = currentLocation.value!.longitude - delta;
//       maxLng = currentLocation.value!.longitude + delta;
//     }
//
//     // حد أدنى للـ bounds (1km تقريباً)
//     const minDelta = 0.015;
//     if (maxLat - minLat < minDelta) {
//       final center = (maxLat + minLat) / 2;
//       minLat = center - minDelta / 2;
//       maxLat = center + minDelta / 2;
//     }
//     if (maxLng - minLng < minDelta) {
//       final center = (maxLng + minLng) / 2;
//       minLng = center - minDelta / 2;
//       maxLng = center + minDelta / 2;
//     }
//
//     if (kDebugMode) {
//       print('[OffersController] ✅ Bounds محسوبة:');
//       print('[OffersController] - إحداثيات صالحة: $validCoordinatesCount');
//       print(
//           '[OffersController] - SW: (${minLat.toStringAsFixed(6)}, ${minLng.toStringAsFixed(6)})');
//       print(
//           '[OffersController] - NE: (${maxLat.toStringAsFixed(6)}, ${maxLng.toStringAsFixed(6)})');
//       print(
//           '[OffersController] - Width: ${(maxLng - minLng).toStringAsFixed(3)}°');
//       print(
//           '[OffersController] - Height: ${(maxLat - minLat).toStringAsFixed(3)}°');
//
//       // حساب المسافة التقريبية
//       final widthKm =
//           (maxLng - minLng) * 111.0; // 1° longitude ≈ 111 km at equator
//       final heightKm = (maxLat - minLat) * 111.0; // 1° latitude ≈ 111 km
//       print(
//           '[OffersController] - تقريباً: ${widthKm.toStringAsFixed(1)} × ${heightKm.toStringAsFixed(1)} كم');
//     }
//
//     return LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//   }
//
//   /// عند الضغط على الماركر
//   void _onMarkerTapped(OrganizationCompanyDailyOfferItemModel org) {
//     selectedOrganization.value = org;
//     if (kDebugMode) {
//       print('[OffersController] 👆 تم اختيار: ${org.organization}');
//     }
//   }
//
//   /// إعادة جلب البيانات
//   Future<void> refresh() async {
//     if (currentLocation.value != null) {
//       isFirstLoad.value = true;
//       await fetchOffers(currentLocation.value!);
//     }
//   }
//
//   /// تحويل إلى double (public method)
//   double? parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) {
//       final trimmed = value.trim();
//       if (trimmed.isEmpty) return null;
//       return double.tryParse(trimmed);
//     }
//     return null;
//   }
//
//   /// تحويل إلى double (private - للاستخدام الداخلي)
//   double? _parseDouble(dynamic value) => parseDouble(value);
//
//   // ===== Getters =====
//   Set<Marker> get markerSet => markers.values.toSet();
//
//   bool get hasData => organizations.isNotEmpty;
//
//   int get organizationsCount => organizations.length;
// }
