import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../features/common/hawaj_voice/domain/models/job_item_hawaj_details_model.dart';
import '../../../../../features/common/hawaj_voice/domain/models/organization_item_hawaj_details_model.dart';
import '../../../../../features/common/hawaj_voice/domain/models/property_item_hawaj_details_model.dart';
import '../../../../../features/common/hawaj_voice/domain/models/send_data_results_model.dart';

enum HawajDataType { jobs, offers, properties }

/// ═══════════════════════════════════════════════════════════
/// 🎯 Controller لإدارة بيانات Hawaj في الخريطة
/// مع تنظيف تام وتزامن مباشر مع الخريطة
/// ═══════════════════════════════════════════════════════════
class HawajMapDataController extends GetxController {
  // === Current Data Type ===
  final _currentDataType = Rx<HawajDataType?>(null);

  // === Data Lists ===
  final _jobs = <JobItemHawajDetailsModel>[].obs;
  final _offers = <OrganizationItemHawajDetailsModel>[].obs;
  final _properties = <PropertyItemHawajDetailsModel>[].obs;

  // === Loading State ===
  final _isLoadingHawajData = false.obs;
  final _showResults = false.obs;

  // === Selected Item ===
  final _selectedJobId = Rxn<String>();
  final _selectedOfferId = Rxn<String>();
  final _selectedPropertyId = Rxn<String>();

  // === Markers for Map ===
  final markers = <String, Marker>{}.obs;

  // 🔔 Callbacks للتنسيق مع Map Screen
  Function? onDataCleaned;
  Function? onMarkersReady;
  Function? onAnimateToMarkers;

  // === Getters ===
  HawajDataType? get currentDataType => _currentDataType.value;

  List<JobItemHawajDetailsModel> get jobs => _jobs;

  List<OrganizationItemHawajDetailsModel> get offers => _offers;

  List<PropertyItemHawajDetailsModel> get properties => _properties;

  bool get isLoadingHawajData => _isLoadingHawajData.value;

  bool get showResults => _showResults.value;

  bool get hasData =>
      _jobs.isNotEmpty || _offers.isNotEmpty || _properties.isNotEmpty;

  int get dataCount {
    if (_currentDataType.value == HawajDataType.jobs) return _jobs.length;
    if (_currentDataType.value == HawajDataType.offers) return _offers.length;
    if (_currentDataType.value == HawajDataType.properties)
      return _properties.length;
    return 0;
  }

  String get dataTypeLabel {
    switch (_currentDataType.value) {
      case HawajDataType.jobs:
        return 'وظيفة';
      case HawajDataType.offers:
        return 'عرض';
      case HawajDataType.properties:
        return 'عقار';
      default:
        return '';
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 📥 Update Data from Hawaj Response - مع تنظيف شامل
  /// ═══════════════════════════════════════════════════════════
  void updateFromHawaj(SendDataResultsModel results) {
    debugPrint('🎯 [HawajMapDataController] تحديث البيانات من Hawaj');

    _isLoadingHawajData.value = true;

    // 1️⃣ 🧹 مسح شامل لجميع البيانات القديمة
    debugPrint('🧹 [HawajMapDataController] تنظيف شامل...');
    _clearAllData();

    // 2️⃣ استدعاء callback التنظيف
    if (onDataCleaned != null) {
      debugPrint('🔔 [HawajMapDataController] استدعاء onDataCleaned callback');
      onDataCleaned!();
    }

    // 3️⃣ معالجة البيانات الجديدة
    if (results.jobs?.isNotEmpty == true) {
      _currentDataType.value = HawajDataType.jobs;
      _jobs.value = results.jobs!;
      debugPrint('✅ [HawajMapDataController] تم تحميل ${_jobs.length} وظيفة');
    } else if (results.offers?.isNotEmpty == true) {
      _currentDataType.value = HawajDataType.offers;
      _offers.value = results.offers!;
      debugPrint('✅ [HawajMapDataController] تم تحميل ${_offers.length} عرض');
    } else if (results.properties?.isNotEmpty == true) {
      _currentDataType.value = HawajDataType.properties;
      _properties.value = results.properties!;
      debugPrint(
          '✅ [HawajMapDataController] تم تحميل ${_properties.length} عقار');
    } else {
      debugPrint('⚠️ [HawajMapDataController] لا توجد بيانات للعرض');
    }

    _isLoadingHawajData.value = false;
    _showResults.value = hasData;

    // 4️⃣ تنبيه Map Screen بأن البيانات جاهزة
    if (hasData && onMarkersReady != null) {
      debugPrint('🔔 [HawajMapDataController] استدعاء onMarkersReady callback');
      Future.delayed(const Duration(milliseconds: 100), () {
        onMarkersReady!();
      });
    }
    // 4️⃣ تنبيه Map Screen بأن البيانات جاهزة
    if (hasData) {
      debugPrint('🔔 [HawajMapDataController] استدعاء onMarkersReady callback');

      // تنظيف الماركرات السابقة من الخريطة القديمة
      if (onDataCleaned != null) onDataCleaned!();

      // بناء الماركرات الجديدة مباشرة
      Future.delayed(const Duration(milliseconds: 300), () {
        onMarkersReady?.call();

        // بعد البناء، نحرك الكاميرا تلقائيًا للنتائج
        Future.delayed(const Duration(milliseconds: 700), () {
          onAnimateToMarkers?.call();
        });
      });
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🏢 Build Job Markers
  /// ═══════════════════════════════════════════════════════════
  void buildJobMarkers() {
    markers.clear();
    debugPrint('💼 [HawajMapDataController] بناء job markers...');
    // Jobs without exact locations are handled by map_screen
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🏪 Build Offer Markers
  /// ═══════════════════════════════════════════════════════════
  void buildOfferMarkers() {
    markers.clear();
    debugPrint(
        '🟠 [HawajMapDataController] بناء ${_offers.length} offer markers');

    for (var offer in _offers) {
      final lat = double.tryParse(offer.organizationLocationLat);
      final lng = double.tryParse(offer.organizationLocationLng);

      if (lat != null && lng != null) {
        final marker = Marker(
          markerId: MarkerId('offer_${offer.id}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: offer.organizationName,
            snippet: offer.organizationServices,
          ),
          onTap: () => selectOffer(offer.id),
        );

        markers['offer_${offer.id}'] = marker;
      }
    }

    debugPrint('✅ تم إنشاء ${markers.length} offer marker');
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🏠 Build Property Markers
  /// ═══════════════════════════════════════════════════════════
  void buildPropertyMarkers() {
    markers.clear();
    debugPrint(
        '🟢 [HawajMapDataController] بناء ${_properties.length} property markers');

    for (var property in _properties) {
      final lat = double.tryParse(property.lat);
      final lng = double.tryParse(property.lng);

      if (lat != null && lng != null) {
        final marker = Marker(
          markerId: MarkerId('property_${property.id}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: property.propertySubject,
            snippet: '${property.price} - ${property.areaSqm}م²',
          ),
          onTap: () => selectProperty(property.id),
        );

        markers['property_${property.id}'] = marker;
      }
    }

    debugPrint('✅ تم إنشاء ${markers.length} property marker');
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎯 Calculate Bounds for Camera Animation
  /// ═══════════════════════════════════════════════════════════
  LatLngBounds? calculateBounds() {
    if (markers.isEmpty) return null;

    double? minLat, maxLat, minLng, maxLng;

    for (var marker in markers.values) {
      final pos = marker.position;

      minLat = minLat == null
          ? pos.latitude
          : (pos.latitude < minLat ? pos.latitude : minLat);
      maxLat = maxLat == null
          ? pos.latitude
          : (pos.latitude > maxLat ? pos.latitude : maxLat);
      minLng = minLng == null
          ? pos.longitude
          : (pos.longitude < minLng ? pos.longitude : minLng);
      maxLng = maxLng == null
          ? pos.longitude
          : (pos.longitude > maxLng ? pos.longitude : maxLng);
    }

    if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
      return null;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎯 Selection Methods
  /// ═══════════════════════════════════════════════════════════
  void selectJob(String id) {
    _selectedJobId.value = id;
    debugPrint('✅ تم اختيار الوظيفة: $id');
  }

  void selectOffer(String id) {
    _selectedOfferId.value = id;
    debugPrint('✅ تم اختيار العرض: $id');
  }

  void selectProperty(String id) {
    _selectedPropertyId.value = id;
    debugPrint('✅ تم اختيار العقار: $id');
  }

  JobItemHawajDetailsModel? getSelectedJob() {
    if (_selectedJobId.value == null) return null;
    return _jobs.firstWhereOrNull((j) => j.id == _selectedJobId.value);
  }

  OrganizationItemHawajDetailsModel? getSelectedOffer() {
    if (_selectedOfferId.value == null) return null;
    return _offers.firstWhereOrNull((o) => o.id == _selectedOfferId.value);
  }

  PropertyItemHawajDetailsModel? getSelectedProperty() {
    if (_selectedPropertyId.value == null) return null;
    return _properties
        .firstWhereOrNull((p) => p.id == _selectedPropertyId.value);
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🧹 Clear All Data - تنظيف شامل
  /// ═══════════════════════════════════════════════════════════
  void _clearAllData() {
    _jobs.clear();
    _offers.clear();
    _properties.clear();
    markers.clear();
    _currentDataType.value = null;
    _selectedJobId.value = null;
    _selectedOfferId.value = null;
    _selectedPropertyId.value = null;
    _showResults.value = false;
    debugPrint('🧹 تم تنظيف جميع البيانات');
  }

  void clear() {
    _clearAllData();
  }

  void hideResults() {
    _showResults.value = false;
  }

  void showResultsPanel() {
    _showResults.value = true;
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../../../../features/common/hawaj_voice/domain/models/job_item_hawaj_details_model.dart';
// import '../../../../../features/common/hawaj_voice/domain/models/organization_item_hawaj_details_model.dart';
// import '../../../../../features/common/hawaj_voice/domain/models/property_item_hawaj_details_model.dart';
// import '../../../../../features/common/hawaj_voice/domain/models/send_data_results_model.dart';
//
// enum HawajDataType { jobs, offers, properties }
//
// /// ═══════════════════════════════════════════════════════════
// /// 🎯 Controller لإدارة بيانات Hawaj في الخريطة
// /// ═══════════════════════════════════════════════════════════
// class HawajMapDataController extends GetxController {
//   // === Current Data Type ===
//   final _currentDataType = Rx<HawajDataType?>(null);
//
//   // === Data Lists ===
//   final _jobs = <JobItemHawajDetailsModel>[].obs;
//   final _offers = <OrganizationItemHawajDetailsModel>[].obs;
//   final _properties = <PropertyItemHawajDetailsModel>[].obs;
//
//   // === Loading State ===
//   final _isLoadingHawajData = false.obs;
//   final _showResults = false.obs;
//
//   // === Selected Item ===
//   final _selectedJobId = Rxn<String>();
//   final _selectedOfferId = Rxn<String>();
//   final _selectedPropertyId = Rxn<String>();
//
//   // === Markers for Map ===
//   final markers = <String, Marker>{}.obs;
//
//   // === Getters ===
//   HawajDataType? get currentDataType => _currentDataType.value;
//
//   List<JobItemHawajDetailsModel> get jobs => _jobs;
//
//   List<OrganizationItemHawajDetailsModel> get offers => _offers;
//
//   List<PropertyItemHawajDetailsModel> get properties => _properties;
//
//   bool get isLoadingHawajData => _isLoadingHawajData.value;
//
//   bool get showResults => _showResults.value;
//
//   bool get hasData =>
//       _jobs.isNotEmpty || _offers.isNotEmpty || _properties.isNotEmpty;
//
//   int get dataCount {
//     if (_currentDataType.value == HawajDataType.jobs) return _jobs.length;
//     if (_currentDataType.value == HawajDataType.offers) return _offers.length;
//     if (_currentDataType.value == HawajDataType.properties)
//       return _properties.length;
//     return 0;
//   }
//
//   String get dataTypeLabel {
//     switch (_currentDataType.value) {
//       case HawajDataType.jobs:
//         return 'وظيفة';
//       case HawajDataType.offers:
//         return 'عرض';
//       case HawajDataType.properties:
//         return 'عقار';
//       default:
//         return '';
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 📥 Update Data from Hawaj Response
//   /// ═══════════════════════════════════════════════════════════
//   void updateFromHawaj(SendDataResultsModel results) {
//     debugPrint('🎯 [HawajMapData] تحديث البيانات من Hawaj');
//
//     _isLoadingHawajData.value = true;
//
//     // Clear previous data
//     clear();
//
//     // Determine data type and update
//     if (results.jobs?.isNotEmpty == true) {
//       _currentDataType.value = HawajDataType.jobs;
//       _jobs.value = results.jobs!;
//       debugPrint('✅ تم تحميل ${_jobs.length} وظيفة');
//       _buildJobMarkers();
//     } else if (results.offers?.isNotEmpty == true) {
//       _currentDataType.value = HawajDataType.offers;
//       _offers.value = results.offers!;
//       debugPrint('✅ تم تحميل ${_offers.length} عرض');
//       _buildOfferMarkers();
//     } else if (results.properties?.isNotEmpty == true) {
//       _currentDataType.value = HawajDataType.properties;
//       _properties.value = results.properties!;
//       debugPrint('✅ تم تحميل ${_properties.length} عقار');
//       _buildPropertyMarkers();
//     } else {
//       debugPrint('⚠️ لا توجد بيانات للعرض');
//     }
//
//     _isLoadingHawajData.value = false;
//     _showResults.value = hasData;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🏢 Build Job Markers (if jobs have locations)
//   /// ═══════════════════════════════════════════════════════════
//   void _buildJobMarkers() {
//     markers.clear();
//     // Jobs usually don't have exact locations, so we won't add markers
//     // But if they do in future, add them here
//     debugPrint('ℹ️ الوظائف لا تحتوي على مواقع على الخريطة');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🏪 Build Offer Markers
//   /// ═══════════════════════════════════════════════════════════
//   void _buildOfferMarkers() {
//     markers.clear();
//
//     for (var offer in _offers) {
//       final lat = double.tryParse(offer.organizationLocationLat);
//       final lng = double.tryParse(offer.organizationLocationLng);
//
//       if (lat != null && lng != null) {
//         final marker = Marker(
//           markerId: MarkerId('offer_${offer.id}'),
//           position: LatLng(lat, lng),
//           infoWindow: InfoWindow(
//             title: offer.organizationName,
//             snippet: offer.organizationServices,
//           ),
//           onTap: () => selectOffer(offer.id),
//         );
//
//         markers[offer.id] = marker;
//       }
//     }
//
//     debugPrint('✅ تم إنشاء ${markers.length} marker للعروض');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🏠 Build Property Markers
//   /// ═══════════════════════════════════════════════════════════
//   void _buildPropertyMarkers() {
//     markers.clear();
//
//     for (var property in _properties) {
//       final lat = double.tryParse(property.lat);
//       final lng = double.tryParse(property.lng);
//
//       if (lat != null && lng != null) {
//         final marker = Marker(
//           markerId: MarkerId('property_${property.id}'),
//           position: LatLng(lat, lng),
//           infoWindow: InfoWindow(
//             title: property.propertySubject,
//             snippet: '${property.price} - ${property.areaSqm}م²',
//           ),
//           onTap: () => selectProperty(property.id),
//         );
//
//         markers[property.id] = marker;
//       }
//     }
//
//     debugPrint('✅ تم إنشاء ${markers.length} marker للعقارات');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎯 Calculate Bounds for Camera Animation
//   /// ═══════════════════════════════════════════════════════════
//   LatLngBounds? calculateBounds() {
//     if (markers.isEmpty) return null;
//
//     double? minLat, maxLat, minLng, maxLng;
//
//     for (var marker in markers.values) {
//       final pos = marker.position;
//
//       minLat = minLat == null
//           ? pos.latitude
//           : (pos.latitude < minLat ? pos.latitude : minLat);
//       maxLat = maxLat == null
//           ? pos.latitude
//           : (pos.latitude > maxLat ? pos.latitude : maxLat);
//       minLng = minLng == null
//           ? pos.longitude
//           : (pos.longitude < minLng ? pos.longitude : minLng);
//       maxLng = maxLng == null
//           ? pos.longitude
//           : (pos.longitude > maxLng ? pos.longitude : maxLng);
//     }
//
//     if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
//       return null;
//     }
//
//     return LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎯 Selection Methods
//   /// ═══════════════════════════════════════════════════════════
//   void selectJob(String id) {
//     _selectedJobId.value = id;
//     debugPrint('✅ تم اختيار الوظيفة: $id');
//   }
//
//   void selectOffer(String id) {
//     _selectedOfferId.value = id;
//     debugPrint('✅ تم اختيار العرض: $id');
//   }
//
//   void selectProperty(String id) {
//     _selectedPropertyId.value = id;
//     debugPrint('✅ تم اختيار العقار: $id');
//   }
//
//   JobItemHawajDetailsModel? getSelectedJob() {
//     if (_selectedJobId.value == null) return null;
//     return _jobs.firstWhereOrNull((j) => j.id == _selectedJobId.value);
//   }
//
//   OrganizationItemHawajDetailsModel? getSelectedOffer() {
//     if (_selectedOfferId.value == null) return null;
//     return _offers.firstWhereOrNull((o) => o.id == _selectedOfferId.value);
//   }
//
//   PropertyItemHawajDetailsModel? getSelectedProperty() {
//     if (_selectedPropertyId.value == null) return null;
//     return _properties
//         .firstWhereOrNull((p) => p.id == _selectedPropertyId.value);
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🧹 Clear All Data
//   /// ═══════════════════════════════════════════════════════════
//   void clear() {
//     _jobs.clear();
//     _offers.clear();
//     _properties.clear();
//     markers.clear();
//     _currentDataType.value = null;
//     _selectedJobId.value = null;
//     _selectedOfferId.value = null;
//     _selectedPropertyId.value = null;
//     _showResults.value = false;
//   }
//
//   void hideResults() {
//     _showResults.value = false;
//   }
//
//   void showResultsPanel() {
//     _showResults.value = true;
//   }
// }
