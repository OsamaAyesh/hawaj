import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../core/util/snack_bar.dart';
import '../../domain/use_case/update_profile_use_case.dart';
import '../../domain/use_case/update_avatar_use_case.dart';
import '../../data/request/update_profile_request.dart';
import '../../data/request/update_avatar_request.dart';

class EditProfileController extends GetxController {
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;

  late final TextEditingController nameController;

  final avatarFile = Rxn<File>();
  final isLoading = false.obs;
  final isPicking = false.obs;

  final String networkAvatarUrl;

  EditProfileController(
      this._updateProfileUseCase,
      this._updateAvatarUseCase, {
        required String? initialName,
        required this.networkAvatarUrl,
      }) {
    nameController = TextEditingController(text: initialName ?? '');
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

  /// Save profile (avatar + name) in one flow
  Future<void> saveProfile(BuildContext context) async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      _showLocalizedSnackbar(
        ar: "يرجى إدخال الاسم",
        en: "Please enter your name",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Step 1: Upload avatar if selected
      if (avatarFile.value != null) {
        final avatarRes = await _updateAvatarUseCase.execute(
          UpdateAvatarRequest(avatar: avatarFile.value),
        );

        final avatarFailed = avatarRes.fold((f) => f, (_) => null);
        if (avatarFailed != null) {
          _showLocalizedSnackbar(
            ar: avatarFailed.message ?? "فشل رفع الصورة",
            en: avatarFailed.message ?? "Failed to upload avatar",
            isError: true,
          );
          isLoading.value = false;
          return;
        }
      }

      // Step 2: Upload profile (name)
      final profileRes = await _updateProfileUseCase.execute(
        UpdateProfileRequest(name: name),
      );

      profileRes.fold(
            (failure) => _showLocalizedSnackbar(
          ar: failure.message,
          en: failure.message,
          isError: true,
        ),
            (_) async {
          _showLocalizedSnackbar(
            ar: "تم تحديث الملف الشخصي بنجاح",
            en: "Profile updated successfully",
            isError: false,
          );

          await Future.delayed(const Duration(milliseconds: 800));
          // Get.offAll(() => const HomeScreen());
        },
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
    nameController.dispose();
    super.onClose();
  }
}
