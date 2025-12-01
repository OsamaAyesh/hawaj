// lib/features/.../presentation/controller/edit_profile_controller.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/util/snack_bar.dart';
import '../../data/request/update_profile_request.dart';
import '../../domain/use_case/update_profile_use_case.dart';

class EditProfileController extends GetxController {
  final UpdateProfileUseCase _updateProfileUseCase;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController genderController;
  late final TextEditingController dobController;

  final avatarFile = Rxn<File>();
  final isLoading = false.obs;
  final isPicking = false.obs;

  final String networkAvatarUrl;

  EditProfileController(
    this._updateProfileUseCase, {
    String? initialFirstName,
    String? initialLastName,
    String? initialGender,
    String? initialDob,
    required this.networkAvatarUrl,
  }) {
    firstNameController = TextEditingController(text: initialFirstName ?? '');
    lastNameController = TextEditingController(text: initialLastName ?? '');
    genderController = TextEditingController(text: initialGender ?? '');
    dobController = TextEditingController(text: initialDob ?? '');
  }

  /// Pick avatar using FilePicker
  Future<void> pickAvatar() async {
    if (isPicking.value) return;

    isPicking.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedPath = result.files.single.path;
        if (pickedPath != null) {
          avatarFile.value = File(pickedPath);
        }
      }
    } catch (_) {
      if (Get.isOverlaysOpen) return;
      _showLocalizedSnackbar(
        ar: "فشل اختيار الصورة. حاول مجددًا.",
        en: "Image selection failed. Try again.",
        isError: true,
      );
    } finally {
      isPicking.value = false;
    }
  }

  /// اختيار تاريخ الميلاد - اختياري تستعمله من الشاشة
  Future<void> pickDob(BuildContext context) async {
    final now = DateTime.now();
    final initial =
        now.subtract(const Duration(days: 365 * 18)); // مثلاً 18 سنة
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  /// Save profile (avatar + profile data) in ONE request
  Future<void> saveProfile(BuildContext context) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final gender = genderController.text.trim();
    final dob = dobController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      _showLocalizedSnackbar(
        ar: "يرجى إدخال الاسم الأول واسم العائلة",
        en: "Please enter first and last name",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        gender: gender.isEmpty ? null : gender,
        dob: dob.isEmpty ? null : dob,
        avatar: avatarFile.value, // ممكن تكون null
      );

      final result = await _updateProfileUseCase.execute(request);

      result.fold(
        (failure) {
          _showLocalizedSnackbar(
            ar: failure.message ?? "فشل تحديث الملف الشخصي",
            en: failure.message ?? "Failed to update profile",
            isError: true,
          );
        },
        (_) async {
          _showLocalizedSnackbar(
            ar: "تم تحديث الملف الشخصي بنجاح",
            en: "Profile updated successfully",
            isError: false,
          );

          await Future.delayed(const Duration(milliseconds: 800));
          // هنا ترجع للشاشة السابقة أو الريفريش
          Get.back();
        },
      );
    } on DioException {
      _showLocalizedSnackbar(
        ar: "فشل الاتصال بالخادم. حاول مرة أخرى.",
        en: "Network error. Please try again.",
        isError: true,
      );
    } catch (_) {
      _showLocalizedSnackbar(
        ar: "حدث خطأ غير متوقع",
        en: "An unexpected error occurred",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showLocalizedSnackbar({
    required String ar,
    required String en,
    required bool isError,
  }) {
    final locale = Get.locale?.languageCode ?? 'ar';
    final message = locale == 'ar' ? ar : en;

    if (isError) {
      AppSnackbar.error(message);
    } else {
      AppSnackbar.success(message);
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
