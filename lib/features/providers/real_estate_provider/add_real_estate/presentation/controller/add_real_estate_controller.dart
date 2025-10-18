import 'dart:io';

import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/util/snack_bar.dart';
import '../../../../../common/lists/data/request/get_lists_request.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
import '../../data/request/add_real_state_request.dart';
import '../../domain/use_cases/add_real_estate_use_case.dart';

class AddRealEstateController extends GetxController {
  final AddRealEstateUseCase _addRealEstateUseCase;
  final GetListsUseCase _getListsUseCase;

  AddRealEstateController(this._addRealEstateUseCase, this._getListsUseCase);

  // ===== Loading =====
  final isLoading = false.obs;
  final isListsLoaded = false.obs;

  // ===== Lists from API =====
  final propertyTypes = <Map<String, String>>[].obs;
  final operationTypes = <Map<String, String>>[].obs;
  final advertiserRoles = <Map<String, String>>[].obs;
  final saleTypes = <Map<String, String>>[].obs;
  final usageTypes = <Map<String, String>>[].obs;

  final weekDays = <Map<String, String>>[].obs; // all week days
  final features = <Map<String, String>>[].obs; // all features
  final facilities = <Map<String, String>>[].obs; // all facilities

  // ===== Selected (single) =====
  final selectedPropertyType = RxnString();
  final selectedOperationType = RxnString();
  final selectedAdvertiserRole = RxnString();
  final selectedSaleType = RxnString();
  final selectedUsageType = RxnString();

  // ===== Selected (multi) =====
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

  // ===== Location =====
  final locationLatController = TextEditingController();
  final locationLngController = TextEditingController();

  // ===== Files =====
  final propertyImages = <File>[].obs; // allow many images
  final propertyVideos = <File>[].obs;
  File? deedDocument; // single file

  @override
  void onInit() {
    super.onInit();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    isLoading.value = true;

    final res = await _getListsUseCase
        .execute(GetListsRequest(language: AppLanguage().getCurrentLocale()));

    res.fold((failure) {
      AppSnackbar.error('فشل في تحميل البيانات',
          englishMessage: 'Failed to load lists');
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

    isLoading.value = false;
  }

  // ===== Helpers toString for API =====
  String get featureIdsString => selectedFeatureIds.join(',');

  String get facilityIdsString => selectedFacilityIds.join(',');

  String get visitDaysString => selectedVisitDayIds.join(',');

  // ===== Toggle selections =====
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

  bool validateAllFields() {
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
    if (deedDocument == null) {
      AppSnackbar.warning("يرجى رفع صك الملكية");
      return false;
    }
    if (selectedVisitDayIds.isEmpty) {
      AppSnackbar.warning("يرجى تحديد أيام الزيارة");
      return false;
    }
    // facilities غالباً مطلوبة
    if (selectedFacilityIds.isEmpty) {
      AppSnackbar.warning("يرجى اختيار المرافق");
      return false;
    }
    return true;
  }

  Future<void> addRealEstate() async {
    if (!validateAllFields()) return;

    isLoading.value = true;

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
      // ==> "1,4,8"
      facilityIds: facilityIdsString,
      // ==> "1,2"
      visitDays: visitDaysString,
      // ==> "1,2,5"
      visitTimeFrom: '2:00',
      visitTimeTo: '4:00',
      propertyImages: propertyImages.toList(),
      propertyVideos: propertyVideos.toList(),
      deedDocument: deedDocument,
      propertyOwnerId: '3',
    );

    final result = await _addRealEstateUseCase.execute(request);

    result.fold(
      (failure) =>
          AppSnackbar.error('فشل في إضافة العقار', englishMessage: 'Failed'),
      (_) => AppSnackbar.success('تمت إضافة العقار بنجاح',
          englishMessage: 'Property added successfully'),
    );

    isLoading.value = false;
  }

  @override
  void onClose() {
    locationLatController.dispose();
    locationLngController.dispose();
    super.onClose();
  }
}
