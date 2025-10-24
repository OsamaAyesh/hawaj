// import 'dart:io';
//
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:get/get.dart';
//
// import '../../data/request/edit_profile_my_property_owner_request.dart';
// import '../../data/request/get_property_owners_request.dart';
// import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';
import 'dart:io';

import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:get/get.dart';

import '../../data/request/edit_profile_my_property_owner_request.dart';
import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';

class EditProfileMyPropertyOwnerController extends GetxController {
  final EditProfileMyPropertyOwnerUseCase _editUseCase;

  /// Owner ID passed from the previous screen
  final String ownerId;

  EditProfileMyPropertyOwnerController(this._editUseCase, this.ownerId);

  /// Observables
  final isLoading = false.obs;
  final ownerDataAvailable = true.obs; // Always true, since id is provided

  /// Owner Data Fields
  String? ownerName;
  String? mobileNumber;
  String? whatsappNumber;
  String? locationLat;
  String? locationLng;
  String? detailedAddress;
  String? accountType;
  String? companyName;
  String? companyBrief;
  File? companyLogo;
  File? brokerageCertificate;
  File? commercialRegister;

  /// Update Owner Profile
  Future<void> editProfile() async {
    isLoading.value = true;

    AppSnackbar.loading(
      'جاري تحديث البيانات...',
      englishMessage: 'Updating profile...',
    );

    final request = EditProfileMyPropertyOwnerRequest(
      id: ownerId,
      ownerName: ownerName ?? '',
      mobileNumber: mobileNumber ?? '',
      whatsappNumber: whatsappNumber ?? '',
      locationLat: locationLat ?? '',
      locationLng: locationLng ?? '',
      detailedAddress: detailedAddress ?? '',
      accountType: accountType ?? '',
      companyName: companyName ?? '',
      companyBrief: companyBrief ?? '',
      companyLogo: companyLogo,
      brokerageCertificate: brokerageCertificate,
      commercialRegister: commercialRegister,
    );

    final result = await _editUseCase.execute(request);

    result.fold(
      (failure) {
        isLoading.value = false;
        AppSnackbar.error(
          'فشل تحديث البيانات، حاول مرة أخرى لاحقًا.',
          englishMessage: 'Profile update failed, please try again later.',
        );
      },
      (response) {
        isLoading.value = false;
        AppSnackbar.success(
          'تم تحديث الملف الشخصي بنجاح.',
          englishMessage: 'Profile updated successfully.',
        );
      },
    );
  }
}

// import '../../domain/use_cases/get_property_owners_use_cases.dart';
//
// class EditProfileMyPropertyOwnerController extends GetxController {
//   final EditProfileMyPropertyOwnerUseCase _editUseCase;
//   final GetPropertyOwnersUseCases _getUseCase;
//
//   EditProfileMyPropertyOwnerController(this._editUseCase, this._getUseCase);
//
//   final isLoading = false.obs;
//   final ownerDataAvailable = false.obs;
//
//   // Fields
//   String? id;
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
//   @override
//   void onInit() {
//     super.onInit();
//     _getPropertyOwnerData();
//   }
//
//   Future<void> _getPropertyOwnerData() async {
//     isLoading.value = true;
//     AppSnackbar.loading(
//       'جاري جلب بيانات المالك...',
//       englishMessage: 'Fetching owner data...',
//     );
//
//     final result =
//         await _getUseCase.execute(GetPropertyOwnersRequest(lat: '', lng: ''));
//     result.fold((failure) {
//       isLoading.value = false;
//       AppSnackbar.error(
//         'فشل في جلب بيانات المالك.',
//         englishMessage: 'Failed to fetch property owner data.',
//       );
//     }, (response) {
//       if (response.data.isEmpty) {
//         isLoading.value = false;
//         ownerDataAvailable.value = false;
//         AppSnackbar.warning(
//           'لا يمكنك التعديل لأن ليس لديك مؤسسة مسجلة.',
//           englishMessage:
//               'You cannot edit because you do not have any registered organization.',
//         );
//       } else {
//         final owner = response.data.first;
//         id = owner.id;
//         ownerName = owner.ownerName;
//         mobileNumber = owner.mobileNumber;
//         whatsappNumber = owner.whatsappNumber;
//         locationLat = owner.locationLat;
//         locationLng = owner.locationLng;
//         detailedAddress = owner.detailedAddress;
//         accountType = owner.accountType;
//         companyName = owner.companyName;
//         companyBrief = owner.companyBrief;
//
//         ownerDataAvailable.value = true;
//         isLoading.value = false;
//         AppSnackbar.success(
//           'تم تحميل بيانات المؤسسة بنجاح.',
//           englishMessage: 'Organization data loaded successfully.',
//         );
//       }
//     });
//   }
//
//   Future<void> editProfile() async {
//     if (!ownerDataAvailable.value) {
//       AppSnackbar.warning(
//         'لا يمكنك التعديل لأن ليس لديك مؤسسة مسجلة.',
//         englishMessage:
//             'You cannot edit because you do not have any registered organization.',
//       );
//       return;
//     }
//
//     final request = EditProfileMyPropertyOwnerRequest(
//       id: id ?? '',
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
//     isLoading.value = true;
//     AppSnackbar.loading(
//       'جاري تحديث البيانات...',
//       englishMessage: 'Updating profile...',
//     );
//
//     final result = await _editUseCase.execute(request);
//     result.fold((failure) {
//       isLoading.value = false;
//       AppSnackbar.error(
//         'فشل تحديث البيانات، حاول مرة أخرى لاحقًا.',
//         englishMessage: 'Profile update failed, please try again later.',
//       );
//     }, (response) {
//       isLoading.value = false;
//       AppSnackbar.success(
//         'تم تحديث الملف الشخصي بنجاح.',
//         englishMessage: 'Profile updated successfully.',
//       );
//     });
//   }
// }
