import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/request/get_organization_types_request.dart';
import '../../data/request/register_organization_offer_provider_request.dart';
import '../../domain/models/get_organization_types_model.dart';
import '../../domain/models/organization_type_model.dart';
import '../../domain/use_cases/get_organization_types_use_case.dart';
import '../../domain/use_cases/register_organization_offer_provider_use_cases.dart';

class RegisterOrganizationOfferProviderController extends GetxController {
  final RegisterOrganizationOfferProviderUseCases _registerUseCase;
  final GetOrganizationTypesUseCase _getTypesUseCase;

  RegisterOrganizationOfferProviderController(
    this._registerUseCase,
    this._getTypesUseCase,
  );

  // ==================== Text Controllers ====================
  final organizationNameController = TextEditingController();
  final organizationServicesController = TextEditingController();
  final organizationLocationController = TextEditingController();
  final organizationDetailedAddressController = TextEditingController();
  final managerNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final workingHoursController = TextEditingController();
  final commercialRegistrationNumberController = TextEditingController();

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

  // ==================== Dropdown Values ====================
  final selectedOrganizationType = Rx<OrganizationTypeModel?>(null);
  final organizationTypes = <OrganizationTypeModel>[].obs;
  final organizationStatus = '1'.obs; // Default: Active

  @override
  void onInit() {
    super.onInit();
    fetchOrganizationTypes();
  }

  // ==================== Fetch Organization Types ====================
  /// Fetch available organization types from API
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
          AppSnackbar.error(
            'فشل تحميل أنواع المؤسسات',
            englishMessage: 'Failed to load organization types',
          );
        },
        (GetOrganizationTypesModel response) {
          if (!response.error) {
            organizationTypes.value = response.data.organizationTypes;

            // Auto-select first type if available
            if (organizationTypes.isNotEmpty) {
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
  /// Validate all form fields before submission
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
    if (organizationLocationController.text.trim().isEmpty) {
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

    // Organization Logo
    if (organizationLogo.value == null) {
      AppSnackbar.warning(
        'يرجى رفع شعار المؤسسة',
        englishMessage: 'Please upload organization logo',
      );
      return false;
    }

    // Commercial Registration File
    if (commercialRegistrationFile.value == null) {
      AppSnackbar.warning(
        'يرجى رفع ملف السجل التجاري',
        englishMessage: 'Please upload commercial registration file',
      );
      return false;
    }

    return true;
  }

  // ==================== Register Organization ====================
  /// Submit registration form
  Future<void> registerOrganization() async {
    // Validate form
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      isSuccess.value = false;

      // Split location into lat,lng
      final locationParts =
          organizationLocationController.text.trim().split(',');
      final latitude = locationParts.isNotEmpty ? locationParts[0].trim() : '';
      final longitude = locationParts.length > 1 ? locationParts[1].trim() : '';

      // Create request
      final request = RegisterOrganizationOfferProviderRequest(
        organizationName: organizationNameController.text.trim(),
        organizationServices: organizationServicesController.text.trim(),
        organizationType: selectedOrganizationType.value!.id,
        organizationLocation: '$latitude,$longitude',
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
      final result = await _registerUseCase.execute(request);

      // Handle result
      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Registration failed',
          );
        },
        (WithOutDataModel response) {
          if (!response.error) {
            isSuccess.value = true;
            AppSnackbar.success(
              'تم تسجيل المؤسسة بنجاح',
              englishMessage: 'Organization registered successfully',
            );
            _clearForm();
            // Get.off(() => const SuccessRegisterOrganizationOfferProviderScreen());
          } else {
            errorMessage.value = response.message;
            AppSnackbar.error(response.message);
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('❌ Error registering organization: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Clear Form ====================
  /// Clear all form fields and reset state
  void _clearForm() {
    organizationNameController.clear();
    organizationServicesController.clear();
    organizationLocationController.clear();
    organizationDetailedAddressController.clear();
    managerNameController.clear();
    phoneNumberController.clear();
    workingHoursController.clear();
    commercialRegistrationNumberController.clear();

    organizationLogo.value = null;
    organizationBanner.value = null;
    commercialRegistrationFile.value = null;

    selectedOrganizationType.value =
        organizationTypes.isNotEmpty ? organizationTypes.first : null;
    organizationStatus.value = '1';
  }

  // ==================== Reset State ====================
  /// Reset loading and error states
  void resetState() {
    isLoading.value = false;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  // ==================== Retry Fetch Types ====================
  /// Retry fetching organization types
  void retryFetchTypes() {
    fetchOrganizationTypes();
  }

  @override
  void onClose() {
    // Dispose text controllers
    organizationNameController.dispose();
    organizationServicesController.dispose();
    organizationLocationController.dispose();
    organizationDetailedAddressController.dispose();
    managerNameController.dispose();
    phoneNumberController.dispose();
    workingHoursController.dispose();
    commercialRegistrationNumberController.dispose();
    super.onClose();
  }
}
