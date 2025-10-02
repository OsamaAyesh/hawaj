import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
import '../../domain/entities/location_entity.dart';

/// أنواع الأقسام المتاحة في الخريطة
enum MapSectionType {
  dailyOffers,
  contracts,
  realEstate,
  delivery,
  jobs,
}

/// Controller لإدارة الأقسام المختلفة وبياناتها
class MapSectionsController extends GetxController {
  // القسم النشط حالياً
  final currentSection = MapSectionType.dailyOffers.obs;

  // حالة التحميل لكل قسم
  final sectionsLoading = <MapSectionType, RxBool>{}.obs;

  // البيانات لكل قسم
  final sectionsData = <MapSectionType, RxList<dynamic>>{}.obs;

  // الموقع الحالي للمستخدم
  Rxn<LocationEntity> currentLocation = Rxn<LocationEntity>();

  @override
  void onInit() {
    super.onInit();
    // تهيئة حالة التحميل والبيانات لكل قسم
    for (var section in MapSectionType.values) {
      sectionsLoading[section] = false.obs;
      sectionsData[section] = <dynamic>[].obs;
    }
  }

  /// تحديث الموقع الحالي
  void updateLocation(LocationEntity location) {
    currentLocation.value = location;
  }

  /// تغيير القسم النشط
  void changeSection(MapSectionType section) {
    if (currentSection.value == section) return;

    if (kDebugMode) {
      print(
          '[MapSections] 🔄 تغيير القسم من ${currentSection.value.name} إلى ${section.name}');
    }

    currentSection.value = section;

    // جلب البيانات إذا كانت فارغة
    if (sectionsData[section]!.isEmpty && currentLocation.value != null) {
      fetchSectionData(section, currentLocation.value!);
    }
  }

  /// جلب بيانات قسم معين
  Future<void> fetchSectionData(
    MapSectionType section,
    LocationEntity location,
  ) async {
    if (sectionsLoading[section]!.value) return; // منع الطلبات المتكررة

    sectionsLoading[section]!.value = true;

    try {
      if (kDebugMode) {
        print('[MapSections] 🔄 جاري جلب بيانات: ${section.name}');
      }

      switch (section) {
        case MapSectionType.dailyOffers:
          await _fetchDailyOffers(location);
          break;
        case MapSectionType.contracts:
          await _fetchContracts(location);
          break;
        case MapSectionType.realEstate:
          await _fetchRealEstate(location);
          break;
        case MapSectionType.delivery:
          await _fetchDelivery(location);
          break;
        case MapSectionType.jobs:
          await _fetchJobs(location);
          break;
      }

      if (kDebugMode) {
        print('[MapSections] ✅ تم جلب ${sectionsData[section]!.length} عنصر');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[MapSections] ❌ خطأ: $e');
      }
    } finally {
      sectionsLoading[section]!.value = false;
    }
  }

  /// إعادة جلب القسم الحالي
  Future<void> refreshCurrentSection() async {
    if (currentLocation.value == null) {
      if (kDebugMode) {
        print('[MapSections] ⚠️ لا يوجد موقع لإعادة الجلب');
      }
      return;
    }

    sectionsData[currentSection.value]!.clear();
    await fetchSectionData(currentSection.value, currentLocation.value!);
  }

  // ===== Private Methods لجلب البيانات =====

  /// جلب العروض اليومية
  Future<void> _fetchDailyOffers(LocationEntity location) async {
    if (!Get.isRegistered<OffersController>()) {
      if (kDebugMode) {
        print('[MapSections] ⚠️ OffersController غير مسجل');
      }
      return;
    }

    final offersC = Get.find<OffersController>();
    await offersC.fetchOffers(location);

    // تخزين البيانات في sectionsData
    sectionsData[MapSectionType.dailyOffers]!.value = offersC.organizations;
  }

  /// جلب العقود
  Future<void> _fetchContracts(LocationEntity location) async {
    // TODO: استدعاء UseCase الخاص بالعقود
    // مثال:
    // final contractsC = Get.find<ContractsController>();
    // await contractsC.fetchContracts(location);
    // sectionsData[MapSectionType.contracts]!.value = contractsC.contracts;

    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('[MapSections] ⚠️ جلب العقود غير مُنفذ بعد');
    }
  }

  /// جلب العقارات
  Future<void> _fetchRealEstate(LocationEntity location) async {
    // TODO: استدعاء UseCase الخاص بالعقارات
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('[MapSections] ⚠️ جلب العقارات غير مُنفذ بعد');
    }
  }

  /// جلب خدمات التوصيل
  Future<void> _fetchDelivery(LocationEntity location) async {
    // TODO: استدعاء UseCase الخاص بالتوصيل
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('[MapSections] ⚠️ جلب التوصيل غير مُنفذ بعد');
    }
  }

  /// جلب الوظائف
  Future<void> _fetchJobs(LocationEntity location) async {
    // TODO: استدعاء UseCase الخاص بالوظائف
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('[MapSections] ⚠️ جلب الوظائف غير مُنفذ بعد');
    }
  }

  // ===== Getters =====

  /// الحصول على حالة التحميل للقسم الحالي
  bool get isCurrentSectionLoading =>
      sectionsLoading[currentSection.value]?.value ?? false;

  /// الحصول على بيانات القسم الحالي
  List<dynamic> get currentSectionData =>
      sectionsData[currentSection.value] ?? [];

  /// عدد العناصر في القسم الحالي
  int get currentSectionCount => currentSectionData.length;

  /// اسم القسم الحالي بالعربي
  String get currentSectionName {
    switch (currentSection.value) {
      case MapSectionType.dailyOffers:
        return 'العروض اليومية';
      case MapSectionType.contracts:
        return 'العقود';
      case MapSectionType.realEstate:
        return 'العقارات';
      case MapSectionType.delivery:
        return 'التوصيل';
      case MapSectionType.jobs:
        return 'الوظائف';
    }
  }
}
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
// /// أنواع الأقسام المتاحة في الخريطة
// enum MapSectionType {
//   dailyOffers,
//   contracts,
//   realEstate,
//   delivery,
//   jobs,
// }
//
// /// Controller لإدارة الأقسام المختلفة وبياناتها
// class MapSectionsController extends GetxController {
//   // القسم النشط حالياً
//   final currentSection = MapSectionType.dailyOffers.obs;
//
//   // حالة التحميل لكل قسم
//   final sectionsLoading = <MapSectionType, RxBool>{}.obs;
//
//   // البيانات لكل قسم (يمكن تخصيصها حسب نوع البيانات)
//   final sectionsData = <MapSectionType, RxList<dynamic>>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // تهيئة حالة التحميل لكل قسم
//     for (var section in MapSectionType.values) {
//       sectionsLoading[section] = false.obs;
//       sectionsData[section] = <dynamic>[].obs;
//     }
//   }
//
//   /// تغيير القسم النشط
//   void changeSection(MapSectionType section) {
//     if (currentSection.value != section) {
//       currentSection.value = section;
//
//       // جلب البيانات إذا كانت فارغة
//       if (sectionsData[section]!.isEmpty) {
//         fetchSectionData(section);
//       }
//     }
//   }
//
//   /// جلب بيانات قسم معين
//   Future<void> fetchSectionData(MapSectionType section) async {
//     if (sectionsLoading[section]!.value) return; // منع الطلبات المتكررة
//
//     sectionsLoading[section]!.value = true;
//
//     try {
//       if (kDebugMode) print('[MapSections] جاري جلب بيانات: ${section.name}');
//
//       switch (section) {
//         case MapSectionType.dailyOffers:
//           await _fetchDailyOffers();
//           break;
//         case MapSectionType.contracts:
//           await _fetchContracts();
//           break;
//         case MapSectionType.realEstate:
//           await _fetchRealEstate();
//           break;
//         case MapSectionType.delivery:
//           await _fetchDelivery();
//           break;
//         case MapSectionType.jobs:
//           await _fetchJobs();
//           break;
//       }
//
//       if (kDebugMode) {
//         print('[MapSections] ✅ تم جلب ${sectionsData[section]!.length} عنصر');
//       }
//     } catch (e) {
//       if (kDebugMode) print('[MapSections] ❌ خطأ: $e');
//     } finally {
//       sectionsLoading[section]!.value = false;
//     }
//   }
//
//   /// إعادة جلب القسم الحالي
//   Future<void> refreshCurrentSection() async {
//     sectionsData[currentSection.value]!.clear();
//     await fetchSectionData(currentSection.value);
//   }
//
//   // ===== Private Methods لجلب البيانات =====
//
//   Future<void> _fetchDailyOffers() async {
//     await Future.delayed(const Duration(seconds: 1)); // Placeholder
//   }
//
//   Future<void> _fetchContracts() async {
//     // TODO: استدعاء UseCase الخاص بالعقود
//     await Future.delayed(const Duration(seconds: 1));
//   }
//
//   Future<void> _fetchRealEstate() async {
//     // TODO: استدعاء UseCase الخاص بالعقارات
//     await Future.delayed(const Duration(seconds: 1));
//   }
//
//   Future<void> _fetchDelivery() async {
//     // TODO: استدعاء UseCase الخاص بالتوصيل
//     await Future.delayed(const Duration(seconds: 1));
//   }
//
//   Future<void> _fetchJobs() async {
//     // TODO: استدعاء UseCase الخاص بالوظائف
//     await Future.delayed(const Duration(seconds: 1));
//   }
//
//   /// الحصول على حالة التحميل للقسم الحالي
//   bool get isCurrentSectionLoading =>
//       sectionsLoading[currentSection.value]?.value ?? false;
//
//   /// الحصول على بيانات القسم الحالي
//   List<dynamic> get currentSectionData =>
//       sectionsData[currentSection.value] ?? [];
// }
