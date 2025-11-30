import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import 'package:app_mobile/features/common/profile/data/request/update_avatar_request.dart';
import 'package:app_mobile/features/common/profile/domain/use_case/update_avatar_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/routes.dart';
import '../../domain/use_case/completed_profile_use_case.dart';

class CompletedProfileController extends GetxController {
  final CompletedProfileUseCase _completedProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;

  CompletedProfileController(
    this._completedProfileUseCase,
    this._updateAvatarUseCase,
  );

  /// --- Text Controllers ---
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController dateOfBirthController;

  /// --- States ---
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;

  /// --- Gender ---
  var gender = 0.obs;

  /// --- Avatar Image ---
  var avatarImage = Rx<File?>(null);
  var isUploadingAvatar = false.obs;

  @override
  void onInit() {
    super.onInit();
    // تهيئة الـ Controllers في onInit
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    dateOfBirthController = TextEditingController();
  }

  /// --- Submit Profile ---
  Future<void> submitProfile() async {
    errorMessage.value = '';
    isSuccess.value = false;

    if (firstNameController.text.trim().isEmpty) {
      errorMessage.value = ManagerStrings.firstNameRequired;
      return;
    }
    if (lastNameController.text.trim().isEmpty) {
      errorMessage.value = ManagerStrings.lastNameRequired;
      return;
    }
    if (gender.value == 0) {
      errorMessage.value = ManagerStrings.genderRequired;
      return;
    }
    if (dateOfBirthController.text.trim().isEmpty) {
      errorMessage.value = ManagerStrings.dobRequired;
      return;
    }

    isLoading.value = true;

    try {
      // 1️⃣ إكمال الملف الشخصي أولاً
      final profileRequest = CompletedProfileRequest(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: gender.value,
        dateOfBirth: dateOfBirthController.text.trim(),
      );

      final profileResult =
          await _completedProfileUseCase.execute(profileRequest);

      await profileResult.fold(
        (Failure failure) async {
          errorMessage.value = failure.message ?? ManagerStrings.noContent;
          isSuccess.value = false;
          throw Exception(failure.message);
        },
        (WithOutDataModel response) async {
          // 2️⃣ إذا كان هناك صورة، نرفعها بعد إكمال الملف الشخصي
          if (avatarImage.value != null) {
            await _uploadAvatar();
          }

          isSuccess.value = true;
          AppSnackbar.success(
            "تم إكمال الملف الشخصي بنجاح، استمتع مع حواج!",
            englishMessage: "Profile completed successfully. Enjoy Hawaj!",
          );

          // تنظيف الـ Controllers قبل الانتقال
          _cleanupBeforeNavigation();

          Get.offAllNamed(Routes.hawajWelcomeStartScreen);
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// --- رفع الصورة الشخصية ---
  Future<void> _uploadAvatar() async {
    if (avatarImage.value == null) return;

    try {
      isUploadingAvatar.value = true;

      final avatarRequest = UpdateAvatarRequest(
        avatar: avatarImage.value!,
      );

      final result = await _updateAvatarUseCase.execute(avatarRequest);

      result.fold(
        (failure) {
          debugPrint('فشل رفع الصورة: ${failure.message}');
        },
        (data) {
          if (!data.error) {
            debugPrint('تم رفع الصورة بنجاح: ${data.message}');
          }
        },
      );
    } catch (e) {
      debugPrint('خطأ في رفع الصورة: $e');
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  /// --- تنظيف قبل الانتقال ---
  void _cleanupBeforeNavigation() {
    // لا تحذف الـ Controllers هنا
    // فقط امسح القيم
    firstNameController.clear();
    lastNameController.clear();
    dateOfBirthController.clear();
    gender.value = 0;
    avatarImage.value = null;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  /// --- Reset form ---
  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    dateOfBirthController.clear();
    gender.value = 0;
    avatarImage.value = null;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  @override
  void onClose() {
    // حذف الـ Controllers فقط عند إغلاق الـ Controller نهائياً
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
