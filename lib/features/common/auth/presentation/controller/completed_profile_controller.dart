import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import '../../domain/use_case/completed_profile_use_case.dart';

class CompletedProfileController extends GetxController {
  final CompletedProfileUseCase _completedProfileUseCase;

  CompletedProfileController(this._completedProfileUseCase);

  /// --- Text Controllers ---
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  /// --- States ---
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;

  /// --- Gender & DOB (extra fields) ---
  var gender = 0.obs;
  var dateOfBirth = ''.obs;

  /// --- Submit Profile ---
  Future<void> submitProfile() async {
    errorMessage.value = '';
    isSuccess.value = false;
    isLoading.value = true;

    final request = CompletedProfileRequest(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      gender: gender.value,
      dateOfBirth: dateOfBirth.value,
    );

    final result = await _completedProfileUseCase.execute(request);

    result.fold(
          (Failure failure) {
        errorMessage.value = failure.message ?? "Unknown error occurred";
        isSuccess.value = false;
      },
          (WithOutDataModel response) {
        isSuccess.value = true;
      },
    );

    isLoading.value = false;
  }

  /// --- Reset form ---
  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    locationController.clear();
    gender.value = 0;
    dateOfBirth.value = '';
    errorMessage.value = '';
    isSuccess.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
