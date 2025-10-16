// presentation/controller/add_my_property_owners_controller.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/util/snack_bar.dart';
import '../../data/request/add_my_property_owners_request.dart';
import '../../domain/use_cases/add_my_property_owners_usecase.dart';

class AddMyPropertyOwnersController extends GetxController {
  final AddMyPropertyOwnersUseCase _addMyPropertyOwnersUseCase;

  AddMyPropertyOwnersController(this._addMyPropertyOwnersUseCase);

  // Form Controllers
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final locationLatController = TextEditingController();
  final locationLngController = TextEditingController();
  final detailedAddressController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyBriefController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedAccountType = '1'.obs;
  final Rx<File?> commercialRegister = Rx<File?>(null);
  final Rx<File?> companyLogo = Rx<File?>(null);
  final Rx<File?> commercialRegistration = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    ownerNameController.dispose();
    mobileNumberController.dispose();
    whatsappNumberController.dispose();
    locationLatController.dispose();
    locationLngController.dispose();
    detailedAddressController.dispose();
    companyNameController.dispose();
    companyBriefController.dispose();
    super.onClose();
  }

  void setCommercialRegister(File file) {
    commercialRegister.value = file;
  }

  void setCompanyLogo(File file) {
    companyLogo.value = file;
  }

  void setCommercialRegistration(File file) {
    commercialRegistration.value = file;
  }

  void setAccountType(String type) {
    selectedAccountType.value = type;
  }

  Future<void> submitPropertyOwner() async {
    // التحقق من صحة البيانات قبل الإرسال
    if (!_validateForm()) {
      return;
    }

    // التحقق من الأرقام
    if (!_validatePhoneNumbers()) {
      return;
    }

    // التحقق من الإحداثيات
    if (!_validateCoordinates()) {
      return;
    }

    // التحقق من ملفات الشركة إذا كان الحساب تجاري
    if (!_validateCompanyFiles()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = AddMyPropertyOwnersRequest(
        ownerName: ownerNameController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        whatsappNumber: whatsappNumberController.text.trim(),
        locationLat: locationLatController.text.trim(),
        locationLng: locationLngController.text.trim(),
        detailedAddress: detailedAddressController.text.trim(),
        accountType: selectedAccountType.value,
        companyName: companyNameController.text.trim(),
        companyBrief: companyBriefController.text.trim(),
        commercialRegister: commercialRegister.value,
        companyLogo: companyLogo.value,
        commercialRegistration: commercialRegistration.value,
      );

      final result = await _addMyPropertyOwnersUseCase.execute(request);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(
            'فشلت عملية الإضافة',
            englishMessage: 'Failed to add property owner',
          );
        },
        (model) {
          if (!model.error) {
            AppSnackbar.success(
              'تم إضافة مالك العقار بنجاح',
              englishMessage: 'Property owner added successfully',
            );
            _clearForm();
            // Get.back(result: true);
          } else {
            errorMessage.value = model.message;
            AppSnackbar.error(
              model.message,
            );
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      AppSnackbar.error(
        'حدث خطأ غير متوقع',
        englishMessage: 'An unexpected error occurred',
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (ownerNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'اسم المالك مطلوب',
        englishMessage: 'Owner name is required',
      );
      return false;
    }

    if (mobileNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'رقم الجوال مطلوب',
        englishMessage: 'Mobile number is required',
      );
      return false;
    }

    if (whatsappNumberController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'رقم الواتساب مطلوب',
        englishMessage: 'WhatsApp number is required',
      );
      return false;
    }

    if (locationLatController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'خط العرض مطلوب',
        englishMessage: 'Latitude is required',
      );
      return false;
    }

    if (locationLngController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'خط الطول مطلوب',
        englishMessage: 'Longitude is required',
      );
      return false;
    }

    if (detailedAddressController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'العنوان التفصيلي مطلوب',
        englishMessage: 'Detailed address is required',
      );
      return false;
    }

    // التحقق من بيانات الشركة إذا كان الحساب تجاري
    if (selectedAccountType.value == '1') {
      // حساب تجاري
      if (companyNameController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'اسم الشركة مطلوب للحساب التجاري',
          englishMessage: 'Company name is required for business account',
        );
        return false;
      }

      if (companyBriefController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'نبذة عن الشركة مطلوبة',
          englishMessage: 'Company brief is required',
        );
        return false;
      }
    }

    return true;
  }

  bool _validatePhoneNumbers() {
    // التحقق من صحة رقم الجوال
    final mobileNumber = mobileNumberController.text.trim();
    if (mobileNumber.length < 10) {
      AppSnackbar.warning(
        'رقم الجوال غير صحيح',
        englishMessage: 'Invalid mobile number',
      );
      return false;
    }

    // التحقق من صحة رقم الواتساب
    final whatsappNumber = whatsappNumberController.text.trim();
    if (whatsappNumber.length < 10) {
      AppSnackbar.warning(
        'رقم الواتساب غير صحيح',
        englishMessage: 'Invalid WhatsApp number',
      );
      return false;
    }

    // التحقق من أن الأرقام تحتوي على أرقام فقط
    if (!RegExp(r'^[0-9]+$').hasMatch(mobileNumber)) {
      AppSnackbar.warning(
        'رقم الجوال يجب أن يحتوي على أرقام فقط',
        englishMessage: 'Mobile number must contain only digits',
      );
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(whatsappNumber)) {
      AppSnackbar.warning(
        'رقم الواتساب يجب أن يحتوي على أرقام فقط',
        englishMessage: 'WhatsApp number must contain only digits',
      );
      return false;
    }

    return true;
  }

  bool _validateCoordinates() {
    // التحقق من صحة الإحداثيات
    final lat = double.tryParse(locationLatController.text.trim());
    final lng = double.tryParse(locationLngController.text.trim());

    if (lat == null) {
      AppSnackbar.warning(
        'خط العرض غير صحيح',
        englishMessage: 'Invalid latitude',
      );
      return false;
    }

    if (lng == null) {
      AppSnackbar.warning(
        'خط الطول غير صحيح',
        englishMessage: 'Invalid longitude',
      );
      return false;
    }

    // التحقق من نطاق الإحداثيات
    if (lat < -90 || lat > 90) {
      AppSnackbar.warning(
        'خط العرض يجب أن يكون بين -90 و 90',
        englishMessage: 'Latitude must be between -90 and 90',
      );
      return false;
    }

    if (lng < -180 || lng > 180) {
      AppSnackbar.warning(
        'خط الطول يجب أن يكون بين -180 و 180',
        englishMessage: 'Longitude must be between -180 and 180',
      );
      return false;
    }

    return true;
  }

  bool _validateCompanyFiles() {
    // التحقق من الملفات المطلوبة للحساب التجاري
    if (selectedAccountType.value == '1') {
      // حساب تجاري
      if (commercialRegister.value == null) {
        AppSnackbar.warning(
          'السجل التجاري مطلوب للحساب التجاري',
          englishMessage:
              'Commercial register is required for business account',
        );
        return false;
      }

      if (companyLogo.value == null) {
        AppSnackbar.warning(
          'شعار الشركة مطلوب',
          englishMessage: 'Company logo is required',
        );
        return false;
      }
    }

    return true;
  }

  void _clearForm() {
    ownerNameController.clear();
    mobileNumberController.clear();
    whatsappNumberController.clear();
    locationLatController.clear();
    locationLngController.clear();
    detailedAddressController.clear();
    companyNameController.clear();
    companyBriefController.clear();
    commercialRegister.value = null;
    companyLogo.value = null;
    commercialRegistration.value = null;
    selectedAccountType.value = '1';
  }
}
