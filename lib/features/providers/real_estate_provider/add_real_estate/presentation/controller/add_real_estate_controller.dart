import 'dart:io';

import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/util/snack_bar.dart';
import '../../../../../common/lists/data/request/get_lists_request.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
// ✅ استيراد المالكين
import '../../../edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import '../../../edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import '../../data/request/add_real_state_request.dart';
import '../../domain/use_cases/add_real_estate_use_case.dart';

class AddRealEstateController extends GetxController {
  final AddRealEstateUseCase _addRealEstateUseCase;
  final GetListsUseCase _getListsUseCase;
  final GetPropertyOwnersUseCases _getPropertyOwnersUseCases;

  AddRealEstateController(
    this._addRealEstateUseCase,
    this._getListsUseCase,
    this._getPropertyOwnersUseCases,
  );

  // ✅ فصل حالات التحميل
  final isPageLoading = false
      .obs; // لتحميل البيانات الأولية (القوائم + المالكين) — يغطي الشاشة كاملة
  final isActionLoading =
      false.obs; // لتحميل عملية الإضافة فقط — Overlay فوق المحتوى

  final isListsLoaded = false.obs;
  final hasOwner = false.obs; // ✅ هل يوجد مؤسسة
  String? propertyOwnerId; // ✅ لتخزين أول ID

  // ===== Lists from API =====
  final propertyTypes = <Map<String, String>>[].obs;
  final operationTypes = <Map<String, String>>[].obs;
  final advertiserRoles = <Map<String, String>>[].obs;
  final saleTypes = <Map<String, String>>[].obs;
  final usageTypes = <Map<String, String>>[].obs;
  final weekDays = <Map<String, String>>[].obs;
  final features = <Map<String, String>>[].obs;
  final facilities = <Map<String, String>>[].obs;

  // ===== Selected =====
  final selectedPropertyType = RxnString();
  final selectedOperationType = RxnString();
  final selectedAdvertiserRole = RxnString();
  final selectedSaleType = RxnString();
  final selectedUsageType = RxnString();

  // ===== Multi Selects =====
  final selectedFeatureIds = <String>[].obs;
  final selectedFacilityIds = <String>[].obs;
  final selectedVisitDayIds = <String>[].obs;

  // ===== Text fields =====
  String? detailedAddress;
  String? price;
  String? area;
  String? commission;
  String? propertyDescription;
  String? propertySubject;
  String? keywords;
  String? visitTimeFrom;
  String? visitTimeTo;

  // ===== Extra Fields (UI only for now) =====
  String? roomCount;
  String? bathroomCount;
  String? buildingAge;
  String? facadeType;
  String? streetWidth;
  String? floorCount;

  // ===== Location =====
  final locationLatController = TextEditingController();
  final locationLngController = TextEditingController();

  // ===== Files =====
  final propertyImages = <File>[].obs;
  final propertyVideos = <File>[].obs;
  final Rx<File?> deedDocument = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // ✅ تحميل القوائم والمالكين معًا
  Future<void> _loadInitialData() async {
    isPageLoading.value = true;
    await Future.wait([
      _fetchLists(),
      _fetchPropertyOwner(),
    ]);
    isPageLoading.value = false;
  }

  // ✅ جلب المالكين
  Future<void> _fetchPropertyOwner() async {
    final result = await _getPropertyOwnersUseCases
        .execute(GetPropertyOwnersRequest(lat: '', lng: ''));
    result.fold(
      (failure) {
        hasOwner.value = false;
      },
      (response) {
        if (response.data.isEmpty) {
          hasOwner.value = false;
        } else {
          hasOwner.value = true;
          propertyOwnerId = response.data.first.id;
        }
      },
    );
  }

  // ✅ جلب القوائم
  Future<void> _fetchLists() async {
    final res = await _getListsUseCase
        .execute(GetListsRequest(language: AppLanguage().getCurrentLocale()));

    res.fold((failure) {
      AppSnackbar.error('فشل في تحميل البيانات');
    }, (response) {
      final fc = response.data.fieldChoices;

      propertyTypes.assignAll(fc
          .where((e) => e.choice == 'property_type')
          .map((e) => {'id': e.name, 'label': e.label}));
      operationTypes.assignAll(fc
          .where((e) => e.choice == 'operation_type')
          .map((e) => {'id': e.name, 'label': e.label}));
      advertiserRoles.assignAll(fc
          .where((e) => e.choice == 'advertiser_role')
          .map((e) => {'id': e.name, 'label': e.label}));
      saleTypes.assignAll(fc
          .where((e) => e.choice == 'sale_type')
          .map((e) => {'id': e.name, 'label': e.label}));
      usageTypes.assignAll(fc
          .where((e) => e.choice == 'usage_type')
          .map((e) => {'id': e.name, 'label': e.label}));
      weekDays.assignAll(fc
          .where((e) => e.choice == 'week_days')
          .map((e) => {'id': e.name, 'label': e.label}));

      features.assignAll(response.data.features
          .map((e) => {'id': e.id, 'label': e.featureName}));
      facilities.assignAll(response.data.facilities
          .map((e) => {'id': e.id, 'label': e.facilityName}));

      isListsLoaded.value = true;
    });
  }

  // ✅ Multi-select toggles
  void toggleFeature(String id) {
    if (selectedFeatureIds.contains(id)) {
      selectedFeatureIds.remove(id);
    } else {
      selectedFeatureIds.add(id);
    }
  }

  void toggleFacility(String id) {
    if (selectedFacilityIds.contains(id)) {
      selectedFacilityIds.remove(id);
    } else {
      selectedFacilityIds.add(id);
    }
  }

  void toggleVisitDay(String id) {
    if (selectedVisitDayIds.contains(id)) {
      selectedVisitDayIds.remove(id);
    } else {
      selectedVisitDayIds.add(id);
    }
  }

  String get featureIdsString => selectedFeatureIds.join(',');

  String get facilityIdsString => selectedFacilityIds.join(',');

  String get visitDaysString => selectedVisitDayIds.join(',');

  bool validateAllFields() {
    if (!hasOwner.value) {
      AppSnackbar.warning("يجب تسجيل مؤسسة أولاً قبل إضافة العقار");
      return false;
    }
    if (propertySubject == null || propertySubject!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال عنوان الإعلان");
      return false;
    }
    if (selectedPropertyType.value == null) {
      AppSnackbar.warning("يرجى اختيار نوع العقار");
      return false;
    }
    if (selectedOperationType.value == null) {
      AppSnackbar.warning("يرجى اختيار نوع العملية");
      return false;
    }
    if (selectedAdvertiserRole.value == null) {
      AppSnackbar.warning("يرجى اختيار صفة المعلن");
      return false;
    }
    if (selectedSaleType.value == null) {
      AppSnackbar.warning("يرجى اختيار نوع البيع");
      return false;
    }
    if (detailedAddress == null || detailedAddress!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال العنوان التفصيلي");
      return false;
    }
    if (price == null || price!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال السعر المطلوب");
      return false;
    }
    if (area == null || area!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال المساحة");
      return false;
    }
    if (commission == null || commission!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال نسبة العمولة");
      return false;
    }
    if (propertyDescription == null || propertyDescription!.isEmpty) {
      AppSnackbar.warning("يرجى كتابة وصف للعقار");
      return false;
    }
    if (locationLatController.text.isEmpty ||
        locationLngController.text.isEmpty) {
      AppSnackbar.warning("يرجى تحديد موقع العقار");
      return false;
    }
    if (deedDocument.value == null) {
      AppSnackbar.warning("يرجى رفع صك الملكية");
      return false;
    }
    if (propertyImages.isEmpty) {
      AppSnackbar.warning("يرجى رفع صور العقار");
      return false;
    }
    return true;
  }

  // ✅ Add Real Estate (فصل الـ loading)
  Future<void> addRealEstate() async {
    if (!validateAllFields()) return;

    isActionLoading.value = true; // فقط عند الإضافة

    final request = AddRealStateRequest(
      propertySubject: propertySubject ?? '',
      propertyType: selectedPropertyType.value ?? '',
      operationType: selectedOperationType.value ?? '',
      advertiserRole: selectedAdvertiserRole.value ?? '',
      saleType: selectedSaleType.value ?? '',
      keywords: keywords ?? '',
      lat: locationLatController.text,
      lng: locationLngController.text,
      propertyDetailedAddress: detailedAddress ?? '',
      price: price ?? '',
      areaSqm: area ?? '',
      commissionPercentage: commission ?? '',
      usageType: selectedUsageType.value ?? '',
      propertyDescription: propertyDescription ?? '',
      featureIds: featureIdsString,
      facilityIds: facilityIdsString,
      visitDays: visitDaysString,
      visitTimeFrom: visitTimeFrom ?? '09:00',
      visitTimeTo: visitTimeTo ?? '17:00',
      propertyOwnerId: propertyOwnerId ?? '3',
      propertyImages: propertyImages.toList(),
      propertyVideos: propertyVideos.toList(),
      deedDocument: deedDocument.value,
    );

    final result = await _addRealEstateUseCase.execute(request);

    result.fold(
      (failure) => AppSnackbar.error('فشل في إضافة العقار'),
      (_) {
        AppSnackbar.success('تمت إضافة العقار بنجاح');
        disposeAddRealEstateModule();
      },
    );

    isActionLoading.value = false;
  }

  @override
  void onClose() {
    locationLatController.dispose();
    locationLngController.dispose();
    super.onClose();
  }

  void disposeAddRealEstateModule() {
    selectedFeatureIds.clear();
    selectedFacilityIds.clear();
    selectedVisitDayIds.clear();

    selectedPropertyType.value = null;
    selectedOperationType.value = null;
    selectedAdvertiserRole.value = null;
    selectedSaleType.value = null;
    selectedUsageType.value = null;

    propertySubject = null;
    detailedAddress = null;
    price = null;
    area = null;
    commission = null;
    propertyDescription = null;
    keywords = null;
    visitTimeFrom = null;
    visitTimeTo = null;

    roomCount = null;
    bathroomCount = null;
    buildingAge = null;
    facadeType = null;
    streetWidth = null;
    floorCount = null;

    locationLatController.clear();
    locationLngController.clear();

    propertyImages.clear();
    propertyVideos.clear();
    deedDocument.value = null;

    isActionLoading.value = false;
    isPageLoading.value = false;
  }
}
