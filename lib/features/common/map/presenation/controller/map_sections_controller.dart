import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

  // البيانات لكل قسم (يمكن تخصيصها حسب نوع البيانات)
  final sectionsData = <MapSectionType, RxList<dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // تهيئة حالة التحميل لكل قسم
    for (var section in MapSectionType.values) {
      sectionsLoading[section] = false.obs;
      sectionsData[section] = <dynamic>[].obs;
    }
  }

  /// تغيير القسم النشط
  void changeSection(MapSectionType section) {
    if (currentSection.value != section) {
      currentSection.value = section;

      // جلب البيانات إذا كانت فارغة
      if (sectionsData[section]!.isEmpty) {
        fetchSectionData(section);
      }
    }
  }

  /// جلب بيانات قسم معين
  Future<void> fetchSectionData(MapSectionType section) async {
    if (sectionsLoading[section]!.value) return; // منع الطلبات المتكررة

    sectionsLoading[section]!.value = true;

    try {
      if (kDebugMode) print('[MapSections] جاري جلب بيانات: ${section.name}');

      // هنا يتم استدعاء الـ UseCase المناسب لكل قسم
      switch (section) {
        case MapSectionType.dailyOffers:
          await _fetchDailyOffers();
          break;
        case MapSectionType.contracts:
          await _fetchContracts();
          break;
        case MapSectionType.realEstate:
          await _fetchRealEstate();
          break;
        case MapSectionType.delivery:
          await _fetchDelivery();
          break;
        case MapSectionType.jobs:
          await _fetchJobs();
          break;
      }

      if (kDebugMode) {
        print('[MapSections] ✅ تم جلب ${sectionsData[section]!.length} عنصر');
      }
    } catch (e) {
      if (kDebugMode) print('[MapSections] ❌ خطأ: $e');
    } finally {
      sectionsLoading[section]!.value = false;
    }
  }

  /// إعادة جلب القسم الحالي
  Future<void> refreshCurrentSection() async {
    sectionsData[currentSection.value]!.clear();
    await fetchSectionData(currentSection.value);
  }

  // ===== Private Methods لجلب البيانات =====

  Future<void> _fetchDailyOffers() async {
    // TODO: استدعاء UseCase الخاص بالعروض اليومية
    await Future.delayed(const Duration(seconds: 1)); // Placeholder
  }

  Future<void> _fetchContracts() async {
    // TODO: استدعاء UseCase الخاص بالعقود
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _fetchRealEstate() async {
    // TODO: استدعاء UseCase الخاص بالعقارات
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _fetchDelivery() async {
    // TODO: استدعاء UseCase الخاص بالتوصيل
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _fetchJobs() async {
    // TODO: استدعاء UseCase الخاص بالوظائف
    await Future.delayed(const Duration(seconds: 1));
  }

  /// الحصول على حالة التحميل للقسم الحالي
  bool get isCurrentSectionLoading =>
      sectionsLoading[currentSection.value]?.value ?? false;

  /// الحصول على بيانات القسم الحالي
  List<dynamic> get currentSectionData =>
      sectionsData[currentSection.value] ?? [];
}
