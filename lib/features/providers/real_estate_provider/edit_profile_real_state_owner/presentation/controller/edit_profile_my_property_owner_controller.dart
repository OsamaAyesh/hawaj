// lib/features/providers/real_estate_provider/edit_profile_real_state_owner/presentation/controller/edit_profile_my_property_owner_controller.dart

import 'dart:io';

import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/request/edit_profile_my_property_owner_request.dart';
import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';

class EditProfileMyPropertyOwnerController extends GetxController {
  final EditProfileMyPropertyOwnerUseCase _editUseCase;
  final String ownerId;

  EditProfileMyPropertyOwnerController(this._editUseCase, this.ownerId);

  // ===== Form Controllers =====
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final whatsappNumberController = TextEditingController();
  final locationLatController = TextEditingController();
  final locationLngController = TextEditingController();
  final detailedAddressController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyBriefController = TextEditingController();

  // ===== Observable States =====
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedAccountType = '1'.obs; // 1 = مكتب، 2 = شخصي

  // ===== Files =====
  final Rx<File?> companyLogo = Rx<File?>(null);
  final Rx<File?> brokerageCertificate = Rx<File?>(null);
  final Rx<File?> commercialRegister = Rx<File?>(null);

  // ===== Existing URLs (للملفات الموجودة مسبقاً) =====
  String existingCompanyLogoUrl = '';
  String existingBrokerageCertificateUrl = '';
  String existingCommercialRegisterUrl = '';

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

  // ===== Set Account Type =====
  void setAccountType(String type) {
    selectedAccountType.value = type;
  }

  // ===== Set Files =====
  void setCompanyLogo(File file) {
    companyLogo.value = file;
  }

  void setBrokerageCertificate(File file) {
    brokerageCertificate.value = file;
  }

  void setCommercialRegister(File file) {
    commercialRegister.value = file;
  }

  // ===== Validation Methods =====
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
    final mobileNumber = mobileNumberController.text.trim();
    if (mobileNumber.length < 10) {
      AppSnackbar.warning(
        'رقم الجوال غير صحيح',
        englishMessage: 'Invalid mobile number',
      );
      return false;
    }

    final whatsappNumber = whatsappNumberController.text.trim();
    if (whatsappNumber.length < 10) {
      AppSnackbar.warning(
        'رقم الواتساب غير صحيح',
        englishMessage: 'Invalid WhatsApp number',
      );
      return false;
    }

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

  // ===== Update Profile =====
  Future<void> editProfile() async {
    // Validation
    if (!_validateForm()) return;
    if (!_validatePhoneNumbers()) return;
    if (!_validateCoordinates()) return;

    isLoading.value = true;
    errorMessage.value = '';

    AppSnackbar.loading(
      'جاري تحديث البيانات...',
      englishMessage: 'Updating profile...',
    );

    try {
      final request = EditProfileMyPropertyOwnerRequest(
        id: ownerId,
        ownerName: ownerNameController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        whatsappNumber: whatsappNumberController.text.trim(),
        locationLat: locationLatController.text.trim(),
        locationLng: locationLngController.text.trim(),
        detailedAddress: detailedAddressController.text.trim(),
        accountType: selectedAccountType.value,
        companyName: companyNameController.text.trim(),
        companyBrief: companyBriefController.text.trim(),
        companyLogo: companyLogo.value,
        brokerageCertificate: brokerageCertificate.value,
        commercialRegister: commercialRegister.value,
      );

      final result = await _editUseCase.execute(request);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(
            'فشل تحديث البيانات',
            englishMessage: 'Failed to update profile',
          );
        },
        (model) {
          if (!model.error) {
            AppSnackbar.success(
              'تم تحديث الملف الشخصي بنجاح',
              englishMessage: 'Profile updated successfully',
            );
            // Get.back(result: true);
          } else {
            errorMessage.value = model.message;
            AppSnackbar.error(model.message);
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
}
// // import 'dart:io';
// //
// // import 'package:app_mobile/core/util/snack_bar.dart';
// // import 'package:get/get.dart';
// //
// // import '../../data/request/edit_profile_my_property_owner_request.dart';
// // import '../../data/request/get_property_owners_request.dart';
// // import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';
// import 'dart:io';
//
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:get/get.dart';
//
// import '../../data/request/edit_profile_my_property_owner_request.dart';
// import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';
//
// class EditProfileMyPropertyOwnerController extends GetxController {
//   final EditProfileMyPropertyOwnerUseCase _editUseCase;
//
//   /// Owner ID passed from the previous screen
//   final String ownerId;
//
//   EditProfileMyPropertyOwnerController(this._editUseCase, this.ownerId);
//
//   /// Observables
//   final isLoading = false.obs;
//   final ownerDataAvailable = true.obs; // Always true, since id is provided
//
//   /// Owner Data Fields
//   String? ownerName;
//   String? mobileNumber;
//   String? whatsappNumber;
//   String? locationLat;
//   String? locationLng;
//   String? detailedAddress;
//   String? accountType;
//   String? companyName;
//   String? companyBrief;
//   File? companyLogo;
//   File? brokerageCertificate;
//   File? commercialRegister;
//
//   /// Update Owner Profile
//   Future<void> editProfile() async {
//     isLoading.value = true;
//
//     AppSnackbar.loading(
//       'جاري تحديث البيانات...',
//       englishMessage: 'Updating profile...',
//     );
//
//     final request = EditProfileMyPropertyOwnerRequest(
//       id: ownerId,
//       ownerName: ownerName ?? '',
//       mobileNumber: mobileNumber ?? '',
//       whatsappNumber: whatsappNumber ?? '',
//       locationLat: locationLat ?? '',
//       locationLng: locationLng ?? '',
//       detailedAddress: detailedAddress ?? '',
//       accountType: accountType ?? '',
//       companyName: companyName ?? '',
//       companyBrief: companyBrief ?? '',
//       companyLogo: companyLogo,
//       brokerageCertificate: brokerageCertificate,
//       commercialRegister: commercialRegister,
//     );
//
//     final result = await _editUseCase.execute(request);
//
//     result.fold(
//       (failure) {
//         isLoading.value = false;
//         AppSnackbar.error(
//           'فشل تحديث البيانات، حاول مرة أخرى لاحقًا.',
//           englishMessage: 'Profile update failed, please try again later.',
//         );
//       },
//       (response) {
//         isLoading.value = false;
//         AppSnackbar.success(
//           'تم تحديث الملف الشخصي بنجاح.',
//           englishMessage: 'Profile updated successfully.',
//         );
//       },
//     );
//   }
// }
//
// // import '../../domain/use_cases/get_property_owners_use_cases.dart';
// //
// // class EditProfileMyPropertyOwnerController extends GetxController {
// //   final EditProfileMyPropertyOwnerUseCase _editUseCase;
// //   final GetPropertyOwnersUseCases _getUseCase;
// //
// //   EditProfileMyPropertyOwnerController(this._editUseCase, this._getUseCase);
// //
// //   final isLoading = false.obs;
// //   final ownerDataAvailable = false.obs;
// //
// //   // Fields
// //   String? id;
// //   String? ownerName;
// //   String? mobileNumber;
// //   String? whatsappNumber;
// //   String? locationLat;
// //   String? locationLng;
// //   String? detailedAddress;
// //   String? accountType;
// //   String? companyName;
// //   String? companyBrief;
// //   File? companyLogo;
// //   File? brokerageCertificate;
// //   File? commercialRegister;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _getPropertyOwnerData();
// //   }
// //
// //   Future<void> _getPropertyOwnerData() async {
// //     isLoading.value = true;
// //     AppSnackbar.loading(
// //       'جاري جلب بيانات المالك...',
// //       englishMessage: 'Fetching owner data...',
// //     );
// //
// //     final result =
// //         await _getUseCase.execute(GetPropertyOwnersRequest(lat: '', lng: ''));
// //     result.fold((failure) {
// //       isLoading.value = false;
// //       AppSnackbar.error(
// //         'فشل في جلب بيانات المالك.',
// //         englishMessage: 'Failed to fetch property owner data.',
// //       );
// //     }, (response) {
// //       if (response.data.isEmpty) {
// //         isLoading.value = false;
// //         ownerDataAvailable.value = false;
// //         AppSnackbar.warning(
// //           'لا يمكنك التعديل لأن ليس لديك مؤسسة مسجلة.',
// //           englishMessage:
// //               'You cannot edit because you do not have any registered organization.',
// //         );
// //       } else {
// //         final owner = response.data.first;
// //         id = owner.id;
// //         ownerName = owner.ownerName;
// //         mobileNumber = owner.mobileNumber;
// //         whatsappNumber = owner.whatsappNumber;
// //         locationLat = owner.locationLat;
// //         locationLng = owner.locationLng;
// //         detailedAddress = owner.detailedAddress;
// //         accountType = owner.accountType;
// //         companyName = owner.companyName;
// //         companyBrief = owner.companyBrief;
// //
// //         ownerDataAvailable.value = true;
// //         isLoading.value = false;
// //         AppSnackbar.success(
// //           'تم تحميل بيانات المؤسسة بنجاح.',
// //           englishMessage: 'Organization data loaded successfully.',
// //         );
// //       }
// //     });
// //   }
// //
// //   Future<void> editProfile() async {
// //     if (!ownerDataAvailable.value) {
// //       AppSnackbar.warning(
// //         'لا يمكنك التعديل لأن ليس لديك مؤسسة مسجلة.',
// //         englishMessage:
// //             'You cannot edit because you do not have any registered organization.',
// //       );
// //       return;
// //     }
// //
// //     final request = EditProfileMyPropertyOwnerRequest(
// //       id: id ?? '',
// //       ownerName: ownerName ?? '',
// //       mobileNumber: mobileNumber ?? '',
// //       whatsappNumber: whatsappNumber ?? '',
// //       locationLat: locationLat ?? '',
// //       locationLng: locationLng ?? '',
// //       detailedAddress: detailedAddress ?? '',
// //       accountType: accountType ?? '',
// //       companyName: companyName ?? '',
// //       companyBrief: companyBrief ?? '',
// //       companyLogo: companyLogo,
// //       brokerageCertificate: brokerageCertificate,
// //       commercialRegister: commercialRegister,
// //     );
// //
// //     isLoading.value = true;
// //     AppSnackbar.loading(
// //       'جاري تحديث البيانات...',
// //       englishMessage: 'Updating profile...',
// //     );
// //
// //     final result = await _editUseCase.execute(request);
// //     result.fold((failure) {
// //       isLoading.value = false;
// //       AppSnackbar.error(
// //         'فشل تحديث البيانات، حاول مرة أخرى لاحقًا.',
// //         englishMessage: 'Profile update failed, please try again later.',
// //       );
// //     }, (response) {
// //       isLoading.value = false;
// //       AppSnackbar.success(
// //         'تم تحديث الملف الشخصي بنجاح.',
// //         englishMessage: 'Profile updated successfully.',
// //       );
// //     });
// //   }
// // }
