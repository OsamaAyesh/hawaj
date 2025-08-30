import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';           // NEW
import 'package:path_provider/path_provider.dart';       // NEW
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/request/update_avatar_request.dart';
import '../../data/request/update_profile_request.dart';
import '../../domain/use_case/update_profile_use_case.dart';
import '../../domain/use_case/update_avatar_use_case.dart';

/// Controller that manages both profile (name) and avatar updates.
class EditProfileController extends GetxController {
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;

  EditProfileController(
      this._updateProfileUseCase,
      this._updateAvatarUseCase,
      );

  /// Local editable fields
  final RxString name = ''.obs;
  final Rxn<File> pickedAvatar = Rxn<File>();

  /// Loading states
  final RxBool isUpdatingProfile = false.obs;
  final RxBool isUpdatingAvatar = false.obs;
  final RxBool isSavingAll = false.obs;

  /// Loading while picking image via file_picker
  final RxBool isPickingAvatar = false.obs;

  /// Success flags
  final RxBool profileUpdated = false.obs;
  final RxBool avatarUpdated = false.obs;

  /// Errors
  final RxnString profileError = RxnString();
  final RxnString avatarError = RxnString();

  /// Helper: Aggregate busy state for full-screen overlay
  bool get isBusy =>
      isSavingAll.value ||
          isUpdatingProfile.value ||
          isUpdatingAvatar.value ||
          isPickingAvatar.value;

  /// Optionally seed initial data when the screen opens
  void seed({String? initialName}) {
    if (initialName != null) name.value = initialName;
  }

  /// Setters to update local state from UI
  void setName(String value) => name.value = value;
  void setAvatar(File? file) => pickedAvatar.value = file;

  /// Pick image using file_picker (gallery/files). Camera capture is not supported by file_picker.
  Future<void> pickAvatarWithFilePicker() async {
    if (isPickingAvatar.value) return;

    isPickingAvatar.value = true;
    avatarError.value = null;

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // in case path is null, we fallback to bytes
      );

      if (result == null) {
        // User canceled
        isPickingAvatar.value = false;
        return;
      }

      final PlatformFile file = result.files.first;

      // Optional: file size guard (e.g., 15 MB)
      const int maxBytes = 15 * 1024 * 1024;
      if (file.size > maxBytes) {
        avatarError.value = 'Selected image is too large (max 15MB)';
        isPickingAvatar.value = false;
        return;
      }

      // If path is available (mobile), use it directly
      if (file.path != null && file.path!.isNotEmpty) {
        setAvatar(File(file.path!));
        isPickingAvatar.value = false;
        return;
      }

      // Fallback: if only bytes available, write to temp file then use it
      if (file.bytes != null && file.bytes!.isNotEmpty) {
        final temp = await _writeBytesToTempFile(
          file.bytes!,
          file.name.isNotEmpty ? file.name : 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        setAvatar(temp);
        isPickingAvatar.value = false;
        return;
      }

      // If neither path nor bytes, it's an error
      avatarError.value = 'Failed to read selected image';
    } catch (_) {
      avatarError.value = 'Failed to pick image';
    } finally {
      isPickingAvatar.value = false;
    }
  }

  /// Writes bytes to a temporary file and returns the File reference
  Future<File> _writeBytesToTempFile(Uint8List bytes, String filename) async {
    final Directory dir = await getTemporaryDirectory();
    final String fullPath = '${dir.path}/$filename';
    final file = File(fullPath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Update only the profile (name)
  Future<bool> updateProfile({String? newName}) async {
    if (isUpdatingProfile.value) return false;
    final String finalName = (newName ?? name.value).trim();

    if (finalName.isEmpty) {
      profileError.value = 'Name cannot be empty';
      return false;
    }

    isUpdatingProfile.value = true;
    profileError.value = null;
    profileUpdated.value = false;

    final Either<Failure, WithOutDataModel> result =
    await _updateProfileUseCase.execute(UpdateProfileRequest(name: finalName));

    return result.fold((Failure failure) {
      profileError.value = failure.message ?? 'Something went wrong';
      isUpdatingProfile.value = false;
      return false;
    }, (WithOutDataModel _) {
      profileUpdated.value = true;
      isUpdatingProfile.value = false;
      return true;
    });
  }

  /// Update only the avatar (image file)
  Future<bool> updateAvatar({File? file}) async {
    if (isUpdatingAvatar.value) return false;
    final File? finalFile = file ?? pickedAvatar.value;

    // If there is no image picked, we return false (saveAll will skip calling this if null)
    if (finalFile == null) {
      avatarError.value = 'Please pick an image first';
      return false;
    }

    isUpdatingAvatar.value = true;
    avatarError.value = null;
    avatarUpdated.value = false;

    final Either<Failure, WithOutDataModel> result =
    await _updateAvatarUseCase.execute(UpdateAvatarRequest(avatar: finalFile));

    return result.fold((Failure failure) {
      avatarError.value = failure.message ?? 'Something went wrong';
      isUpdatingAvatar.value = false;
      return false;
    }, (WithOutDataModel _) {
      avatarUpdated.value = true;
      isUpdatingAvatar.value = false;
      return true;
    });
  }

  /// Save both (avatar and name) if provided.
  /// - Runs sequentially: avatar -> profile (so the avatar uploads first).
  /// - If one fails, it stops and returns false.
  Future<bool> saveAll({String? newName, File? newAvatar}) async {
    if (isSavingAll.value || isUpdatingAvatar.value || isUpdatingProfile.value) {
      return false;
    }

    isSavingAll.value = true;

    // Step 1: update avatar if we have a file (either from param or local state)
    final File? avatarToUpload = newAvatar ?? pickedAvatar.value;
    if (avatarToUpload != null) {
      final okAvatar = await updateAvatar(file: avatarToUpload);
      if (!okAvatar) {
        isSavingAll.value = false;
        return false;
      }
    }

    // Step 2: update name if provided
    final String finalName = (newName ?? name.value).trim();
    if (finalName.isNotEmpty) {
      final okProfile = await updateProfile(newName: finalName);
      if (!okProfile) {
        isSavingAll.value = false;
        return false;
      }
    }

    isSavingAll.value = false;
    return true;
  }

  void resetFlags() {
    profileUpdated.value = false;
    avatarUpdated.value = false;
  }

  void clearErrors() {
    profileError.value = null;
    avatarError.value = null;
  }
}
