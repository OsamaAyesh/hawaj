import 'dart:io';

import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import '../../../../../common/lists/data/request/get_lists_request.dart';
import '../../../../../common/lists/domain/models/facility_item_model.dart';
import '../../../../../common/lists/domain/models/feature_item_model.dart';
import '../../../../../common/lists/domain/models/field_choice_item_model.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
import '../../../edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import '../../../edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import '../../data/request/edit_my_real_estate_request.dart';
import '../../domain/use_cases/edit_my_real_estate_use_case.dart';

class EditMyRealEstateController extends GetxController {
  final EditMyRealEstateUseCase _editMyRealEstateUseCase;
  final GetListsUseCase _getListsUseCase;
  final GetPropertyOwnersUseCases _getPropertyOwnersUseCases;

  EditMyRealEstateController(
    this._editMyRealEstateUseCase,
    this._getListsUseCase,
    this._getPropertyOwnersUseCases,
  );

  // ===== Loading States =====
  final isPageLoading = false.obs;
  final isActionLoading = false.obs;
  final isListsLoaded = false.obs;

  // ===== Property Owners =====
  final propertyOwners = <PropertyItemOwnerModel>[].obs;
  String? propertyOwnerId;

  // ===== Lists from API (Models) =====
  final propertyTypes = <FieldChoiceItemModel>[].obs;
  final operationTypes = <FieldChoiceItemModel>[].obs;
  final advertiserRoles = <FieldChoiceItemModel>[].obs;
  final saleTypes = <FieldChoiceItemModel>[].obs;
  final usageTypes = <FieldChoiceItemModel>[].obs;
  final weekDays = <FieldChoiceItemModel>[].obs;
  final features = <FeatureItemModel>[].obs;
  final facilities = <FacilityItemModel>[].obs;

  // ===== Selected Values =====
  final selectedPropertyType = RxnString();
  final selectedOperationType = RxnString();
  final selectedAdvertiserRole = RxnString();
  final selectedSaleType = RxnString();
  final selectedUsageType = RxnString();

  // ===== Multi Selects =====
  final selectedFeatureIds = <String>[].obs;
  final selectedFacilityIds = <String>[].obs;
  final selectedVisitDayIds = <String>[].obs;

  // ===== Text Controllers =====
  final subjectController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final commissionController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final visitTimeFromController = TextEditingController();
  final visitTimeToController = TextEditingController();

  // ===== Files =====
  final propertyImages = <File>[].obs;
  final propertyVideos = <File>[].obs;
  final Rx<File?> deedDocument = Rx<File?>(null);

  // ===== Current Real Estate ID =====
  String? currentRealEstateId;

  @override
  void onInit() {
    super.onInit();
  }

  // ✅ تهيئة البيانات عند فتح الشاشة
  Future<void> initializeWithRealEstate(RealEstateItemModel estate) async {
    currentRealEstateId = estate.id;
    isPageLoading.value = true;

    // تحميل القوائم والمالكين
    await Future.wait([
      _fetchLists(),
      _fetchPropertyOwners(),
    ]);

    // ملء الحقول بالبيانات الموجودة
    _populateFields(estate);

    isPageLoading.value = false;
  }

  // ✅ ملء الحقول بالبيانات الموجودة
  void _populateFields(RealEstateItemModel estate) {
    // Text Fields
    subjectController.text = estate.propertySubject;
    addressController.text = estate.propertyDetailedAddress;
    priceController.text = estate.price;
    areaController.text = estate.areaSqm;
    commissionController.text = estate.commissionPercentage;
    descriptionController.text = estate.propertyDescription;
    keywordsController.text = estate.keywords;
    latController.text = estate.lat;
    lngController.text = estate.lng;
    visitTimeFromController.text = estate.visitTimeFrom;
    visitTimeToController.text = estate.visitTimeTo;

    // Selected Values
    selectedPropertyType.value = estate.propertyType;
    selectedOperationType.value = estate.operationType;
    selectedAdvertiserRole.value = estate.advertiserRole;
    selectedSaleType.value = estate.saleType;
    selectedUsageType.value = estate.usageType;
    propertyOwnerId = estate.propertyOwnerId;

    // Multi-select Lists
    if (estate.featureIds.isNotEmpty) {
      selectedFeatureIds.assignAll(estate.featureIds.split(','));
    }
    if (estate.facilityIds.isNotEmpty) {
      selectedFacilityIds.assignAll(estate.facilityIds.split(','));
    }
    if (estate.visitDays.isNotEmpty) {
      selectedVisitDayIds.assignAll(estate.visitDays.split(','));
    }
  }

  // ✅ جلب المالكين
  Future<void> _fetchPropertyOwners() async {
    final result = await _getPropertyOwnersUseCases
        .execute(GetPropertyOwnersRequest(lat: '', lng: ''));
    result.fold(
      (failure) {
        propertyOwners.clear();
      },
      (response) {
        if (response.data.isNotEmpty) {
          propertyOwners.assignAll(response.data);
        }
      },
    );
  }

  // ✅ جلب القوائم
  Future<void> _fetchLists() async {
    final res = await _getListsUseCase
        .execute(GetListsRequest(language: AppLanguage().getCurrentLocale()));

    res.fold(
      (failure) {
        AppSnackbar.error('فشل في تحميل البيانات');
      },
      (response) {
        final fieldChoices = response.data.fieldChoices;

        propertyTypes.assignAll(
          fieldChoices.realstate
              .where((e) => e.choice == 'property_type')
              .toList(),
        );

        operationTypes.assignAll(
          fieldChoices.realstate
              .where((e) => e.choice == 'operation_type')
              .toList(),
        );

        advertiserRoles.assignAll(
          fieldChoices.realstate
              .where((e) => e.choice == 'advertiser_role')
              .toList(),
        );

        saleTypes.assignAll(
          fieldChoices.realstate.where((e) => e.choice == 'sale_type').toList(),
        );

        usageTypes.assignAll(
          fieldChoices.realstate
              .where((e) => e.choice == 'usage_type')
              .toList(),
        );

        weekDays.assignAll(
          fieldChoices.realstate.where((e) => e.choice == 'week_days').toList(),
        );

        features.assignAll(response.data.features);
        facilities.assignAll(response.data.facilities);

        isListsLoaded.value = true;
      },
    );
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

  // ✅ Getters
  String get featureIdsString => selectedFeatureIds.join(',');

  String get facilityIdsString => selectedFacilityIds.join(',');

  String get visitDaysString => selectedVisitDayIds.join(',');

  // ✅ التحقق من الحقول
  bool validateAllFields() {
    if (subjectController.text.isEmpty) {
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
    if (addressController.text.isEmpty) {
      AppSnackbar.warning("يرجى إدخال العنوان التفصيلي");
      return false;
    }
    if (priceController.text.isEmpty) {
      AppSnackbar.warning("يرجى إدخال السعر المطلوب");
      return false;
    }
    if (areaController.text.isEmpty) {
      AppSnackbar.warning("يرجى إدخال المساحة");
      return false;
    }
    if (descriptionController.text.isEmpty) {
      AppSnackbar.warning("يرجى كتابة وصف للعقار");
      return false;
    }
    return true;
  }

  // ✅ تعديل العقار
  Future<void> editRealEstate() async {
    if (!validateAllFields()) return;
    if (currentRealEstateId == null) {
      AppSnackbar.error('خطأ: لا يوجد معرف للعقار');
      return;
    }

    isActionLoading.value = true;

    final request = EditMyRealEstateRequest(
      id: currentRealEstateId!,
      propertySubject: subjectController.text,
      propertyType: selectedPropertyType.value,
      operationType: selectedOperationType.value,
      advertiserRole: selectedAdvertiserRole.value,
      saleType: selectedSaleType.value,
      keywords: keywordsController.text,
      lat: latController.text,
      lng: lngController.text,
      propertyDetailedAddress: addressController.text,
      price: priceController.text,
      areaSqm: areaController.text,
      commissionPercentage: commissionController.text,
      usageType: selectedUsageType.value,
      propertyDescription: descriptionController.text,
      featureIds: featureIdsString,
      facilityIds: facilityIdsString,
      visitDays: visitDaysString,
      visitTimeFrom: visitTimeFromController.text.isNotEmpty
          ? visitTimeFromController.text
          : '09:00',
      visitTimeTo: visitTimeToController.text.isNotEmpty
          ? visitTimeToController.text
          : '17:00',
      propertyOwnerId: propertyOwnerId,
      propertyImages:
          propertyImages.isNotEmpty ? propertyImages.toList() : null,
      propertyVideos:
          propertyVideos.isNotEmpty ? propertyVideos.toList() : null,
      deedDocument: deedDocument.value,
    );

    final result = await _editMyRealEstateUseCase.execute(request);

    result.fold(
      (failure) => AppSnackbar.error('فشل في تعديل العقار'),
      (_) {
        AppSnackbar.success('تم تعديل العقار بنجاح');
        // Get.back();
        // Get.back(); // العودة للشاشة السابقة
      },
    );

    isActionLoading.value = false;
  }

  @override
  void onClose() {
    subjectController.dispose();
    addressController.dispose();
    priceController.dispose();
    areaController.dispose();
    commissionController.dispose();
    descriptionController.dispose();
    keywordsController.dispose();
    latController.dispose();
    lngController.dispose();
    visitTimeFromController.dispose();
    visitTimeToController.dispose();
    super.onClose();
  }
}
// import 'package:app_mobile/core/error_handler/failure.dart';
// import 'package:app_mobile/core/model/with_out_data_model.dart';
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:dartz/dartz.dart';
// import 'package:get/get.dart';
//
// import '../../data/request/edit_my_real_estate_request.dart';
// import '../../domain/use_cases/edit_my_real_estate_use_case.dart';
//
// class EditMyRealEstateController extends GetxController {
//   final EditMyRealEstateUseCase _editMyRealEstateUseCase;
//
//   EditMyRealEstateController(this._editMyRealEstateUseCase);
//
//   final isLoading = false.obs;
//
//   Future<void> editRealEstate(EditMyRealEstateRequest request) async {
//     try {
//       isLoading.value = true;
//
//       final Either<Failure, WithOutDataModel> response =
//           await _editMyRealEstateUseCase.execute(request);
//
//       response.fold(
//         (failure) {
//           AppSnackbar.error(failure.message);
//         },
//         (data) {
//           AppSnackbar.success("تم تعديل العقار بنجاح ");
//         },
//       );
//     } catch (e) {
//       AppSnackbar.error("حدث خطأ أثناء تعديل العقار");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
