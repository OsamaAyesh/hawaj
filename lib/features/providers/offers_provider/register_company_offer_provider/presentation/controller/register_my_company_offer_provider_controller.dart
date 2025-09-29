import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/request/register_my_company_offer_provider_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/use_case/register_my_company_offer_provider_use_case.dart';
import '../pages/success_register_company_offer_provider_screen.dart';

class RegisterMyCompanyOfferProviderController extends GetxController {
  final RegisterMyCompanyOfferProviderUseCase _useCase;

  RegisterMyCompanyOfferProviderController(this._useCase);

  // ===== Text Controllers =====
  final organizationNameController = TextEditingController();
  final organizationServicesController = TextEditingController();
  final organizationLocationController = TextEditingController();
  final organizationDetailedAddressController = TextEditingController();
  final managerNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final workingHoursController = TextEditingController();
  final commercialRegistrationNumberController = TextEditingController();

  // ===== State =====
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSuccess = false.obs;

  // ===== Files =====
  final organizationLogo = Rx<File?>(null);
  final organizationBanner = Rx<File?>(null);
  final commercialRegistrationFile = Rx<File?>(null);

  // ===== Dropdown Values =====
  final organizationType = ''.obs;
  final organizationStatus = '1'.obs; // افتراضياً: نشط

  // ===== Validation =====
  bool _validateForm() {
    if (organizationNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم الشركة',
        englishMessage: 'Please enter company name',
      );
      return false;
    }
    if (organizationServicesController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال خدمات الشركة',
        englishMessage: 'Please enter company services',
      );
      return false;
    }
    if (organizationLocationController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى تحديد الموقع',
        englishMessage: 'Please set location',
      );
      return false;
    }
    if (managerNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم المسؤول',
        englishMessage: 'Please enter manager name',
      );
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال رقم الهاتف',
        englishMessage: 'Please enter phone number',
      );
      return false;
    }
    if (commercialRegistrationNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال السجل التجاري',
        englishMessage: 'Please enter commercial registration',
      );
      return false;
    }
    if (organizationLogo.value == null) {
      AppSnackbar.warning(
        'يرجى رفع شعار الشركة',
        englishMessage: 'Please upload company logo',
      );
      return false;
    }
    if (commercialRegistrationFile.value == null) {
      AppSnackbar.warning(
        'يرجى رفع السجل التجاري',
        englishMessage: 'Please upload commercial registration',
      );
      return false;
    }
    return true;
  }

  // ===== Register Organization =====
  Future<void> registerOrganization() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    final request = RegisterMyCompanyOfferProviderRequest(
      organizationName: organizationNameController.text.trim(),
      organizationServices: organizationServicesController.text.trim(),
      organizationType: organizationType.value,
      organizationLocation: organizationLocationController.text.trim(),
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

    final result = await _useCase.execute(request);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        AppSnackbar.error(
          failure.message,
          englishMessage: 'Registration failed',
        );
      },
      (WithOutDataModel response) {
        isSuccess.value = true;
        AppSnackbar.success(
          'تم تسجيل الشركة بنجاح',
          englishMessage: 'Company registered successfully',
        );
        _clearForm();
        Get.offAll(const SuccessRegisterCompanyOfferProviderScreen());
      },
    );

    isLoading.value = false;
  }

  // ===== Clear Form =====
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
    organizationType.value = '';
    organizationStatus.value = '1';
  }

  // ===== Reset State =====
  void resetState() {
    isLoading.value = false;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  @override
  void onClose() {
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
