import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/get_organization_item_with_offer_model.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../register_organization_offer_provider/data/request/get_organization_types_request.dart';
import '../../../register_organization_offer_provider/domain/models/get_organization_types_model.dart';
import '../../../register_organization_offer_provider/domain/models/organization_type_model.dart';
import '../../../register_organization_offer_provider/domain/use_cases/get_organization_types_use_case.dart';
import '../../data/request/update_organization_offer_provider_request.dart';
import '../../domain/use_cases/update_organization_offer_provider_use_case.dart';

class UpdateOrganizationOfferProviderController extends GetxController {
  final UpdateOrganizationOfferProviderUseCase _updateUseCase;
  final GetOrganizationTypesUseCase _getTypesUseCase;
  final GetOrganizationItemWithOfferModel organizationData; // ✅ هنا

  // Constructor واحد فقط
  UpdateOrganizationOfferProviderController(
    this._updateUseCase,
    this._getTypesUseCase,
    this.organizationData, // ✅ يستقبل البيانات
  );

  // ==================== Organization Data ====================
  late final String organizationId;

  // ==================== Text Controllers ====================
  late final TextEditingController organizationNameController;
  late final TextEditingController organizationServicesController;
  late final TextEditingController organizationLocationLatController;
  late final TextEditingController organizationLocationLngController;
  late final TextEditingController organizationDetailedAddressController;
  late final TextEditingController managerNameController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController workingHoursController;
  late final TextEditingController commercialRegistrationNumberController;

  // ==================== State ====================
  final isLoading = false.obs;
  final isLoadingTypes = false.obs;
  final errorMessage = ''.obs;
  final typesErrorMessage = ''.obs;
  final isSuccess = false.obs;

  // ==================== Files ====================
  final organizationLogo = Rx<File?>(null);
  final organizationBanner = Rx<File?>(null);
  final commercialRegistrationFile = Rx<File?>(null);

  // ==================== Network Images (الصور الحالية) ====================
  final currentOrganizationLogo = ''.obs;
  final currentOrganizationBanner = ''.obs;
  final currentCommercialRegistration = ''.obs;

  // ==================== Dropdown Values ====================
  final selectedOrganizationType = Rx<OrganizationTypeModel?>(null);
  final organizationTypes = <OrganizationTypeModel>[].obs;
  final organizationStatus = '1'.obs;

  @override
  void onInit() {
    super.onInit();

    // تهيئة البيانات
    organizationId = organizationData.id;
    _initializeControllers();
    _fillInitialData();

    // جلب أنواع المؤسسات
    fetchOrganizationTypes();
  }

  // ==================== Initialize Controllers ====================
  void _initializeControllers() {
    organizationNameController = TextEditingController();
    organizationServicesController = TextEditingController();
    organizationLocationLatController = TextEditingController();
    organizationLocationLngController = TextEditingController();
    organizationDetailedAddressController = TextEditingController();
    managerNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    workingHoursController = TextEditingController();
    commercialRegistrationNumberController = TextEditingController();
  }

  // ==================== Fill Initial Data ====================
  void _fillInitialData() {
    // ملء الحقول النصية
    organizationNameController.text = organizationData.organizationName;
    organizationServicesController.text = organizationData.organizationServices;
    organizationLocationLatController.text =
        organizationData.organizationLocationLat;
    organizationLocationLngController.text =
        organizationData.organizationLocationLng;
    organizationDetailedAddressController.text =
        organizationData.organizationDetailedAddress;
    managerNameController.text = organizationData.managerName;
    phoneNumberController.text = organizationData.phoneNumber;
    workingHoursController.text = organizationData.workingHours;
    commercialRegistrationNumberController.text =
        organizationData.commercialRegistrationNumber;

    // حفظ الصور الحالية
    currentOrganizationLogo.value = organizationData.organizationLogo;
    currentOrganizationBanner.value = organizationData.organizationBanner;
    currentCommercialRegistration.value =
        organizationData.commercialRegistration;

    // Organization Status
    organizationStatus.value = organizationData.organizationStatus;
  }

  // ==================== Fetch Organization Types ====================
  Future<void> fetchOrganizationTypes() async {
    try {
      isLoadingTypes.value = true;
      typesErrorMessage.value = '';

      final request = GetOrganizationTypesRequest(
        language: Get.locale?.languageCode ?? 'ar',
      );

      final result = await _getTypesUseCase.execute(request);

      result.fold(
        (Failure failure) {
          typesErrorMessage.value = failure.message;
          organizationTypes.clear();
        },
        (GetOrganizationTypesModel response) {
          if (!response.error) {
            organizationTypes.value = response.data.organizationTypes;

            // اختيار النوع الحالي
            final currentType = organizationTypes.firstWhereOrNull(
              (type) => type.id == organizationData.organizationType,
            );

            if (currentType != null) {
              selectedOrganizationType.value = currentType;
            } else if (organizationTypes.isNotEmpty) {
              selectedOrganizationType.value = organizationTypes.first;
            }
          } else {
            typesErrorMessage.value = response.message;
            organizationTypes.clear();
          }
        },
      );
    } catch (e) {
      typesErrorMessage.value = e.toString();
      debugPrint('❌ Error fetching organization types: $e');
    } finally {
      isLoadingTypes.value = false;
    }
  }

  // ==================== Validation ====================
  bool _validateForm() {
    // Organization Name
    if (organizationNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم المؤسسة',
        englishMessage: 'Please enter organization name',
      );
      return false;
    }

    // Organization Services
    if (organizationServicesController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال خدمات المؤسسة',
        englishMessage: 'Please enter organization services',
      );
      return false;
    }

    // Organization Type
    if (selectedOrganizationType.value == null) {
      AppSnackbar.warning(
        'يرجى اختيار نوع المؤسسة',
        englishMessage: 'Please select organization type',
      );
      return false;
    }

    // Location
    if (organizationLocationLatController.text.trim().isEmpty ||
        organizationLocationLngController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى تحديد الموقع',
        englishMessage: 'Please set location',
      );
      return false;
    }

    // Detailed Address
    if (organizationDetailedAddressController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال العنوان التفصيلي',
        englishMessage: 'Please enter detailed address',
      );
      return false;
    }

    // Manager Name
    if (managerNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم المسؤول',
        englishMessage: 'Please enter manager name',
      );
      return false;
    }

    // Phone Number
    if (phoneNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال رقم الهاتف',
        englishMessage: 'Please enter phone number',
      );
      return false;
    }

    // Working Hours
    if (workingHoursController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال ساعات العمل',
        englishMessage: 'Please enter working hours',
      );
      return false;
    }

    // Commercial Registration Number
    if (commercialRegistrationNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال رقم السجل التجاري',
        englishMessage: 'Please enter commercial registration number',
      );
      return false;
    }

    return true;
  }

  // ==================== Update Organization ====================
  Future<void> updateOrganization() async {
    // Validate form
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      isSuccess.value = false;

      // Create request
      final request = UpdateOrganizationOfferProviderRequest(
        organizationId: organizationId,
        organizationName: organizationNameController.text.trim(),
        organizationServices: organizationServicesController.text.trim(),
        organizationType: selectedOrganizationType.value!.id,
        organizationLocationLat: organizationLocationLatController.text.trim(),
        organizationLocationLng: organizationLocationLngController.text.trim(),
        organizationDetailedAddress:
            organizationDetailedAddressController.text.trim(),
        managerName: managerNameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        workingHours: workingHoursController.text.trim(),
        commercialRegistrationNumber:
            commercialRegistrationNumberController.text.trim(),
        organizationStatus: organizationStatus.value,
        organizationLogo: organizationLogo.value,
        organizationBanner: organizationBanner.value,
        commercialRegistrationFile: commercialRegistrationFile.value,
      );

      // Execute request
      final result = await _updateUseCase.execute(request);

      // Handle result
      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Update failed',
          );
        },
        (WithOutDataModel response) {
          if (!response.error) {
            isSuccess.value = true;
            AppSnackbar.success(
              'تم تحديث المؤسسة بنجاح',
              englishMessage: 'Organization updated successfully',
            );
            Get.back(result: true); // الرجوع مع نتيجة النجاح
          } else {
            errorMessage.value = response.message;
            AppSnackbar.error(response.message);
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('❌ Error updating organization: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Reset State ====================
  void resetState() {
    isLoading.value = false;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  // ==================== Retry Fetch Types ====================
  void retryFetchTypes() {
    fetchOrganizationTypes();
  }

  @override
  void onClose() {
    // Dispose text controllers
    organizationNameController.dispose();
    organizationServicesController.dispose();
    organizationLocationLatController.dispose();
    organizationLocationLngController.dispose();
    organizationDetailedAddressController.dispose();
    managerNameController.dispose();
    phoneNumberController.dispose();
    workingHoursController.dispose();
    commercialRegistrationNumberController.dispose();
    super.onClose();
  }
}
