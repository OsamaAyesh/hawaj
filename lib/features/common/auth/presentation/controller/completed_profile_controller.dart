import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import '../../domain/use_case/completed_profile_use_case.dart';

class CompletedProfileController extends GetxController {
  final CompletedProfileUseCase _completedProfileUseCase;

  CompletedProfileController(this._completedProfileUseCase);

  /// --- Text Controllers ---
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  /// --- States ---
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;

  /// --- Gender ---
  var gender = 0.obs; // 0 = not selected, 1 = male, 2 = female

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

    final request = CompletedProfileRequest(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      gender: gender.value,
      dateOfBirth: dateOfBirthController.text.trim(),
    );

    final result = await _completedProfileUseCase.execute(request);

    result.fold(
          (Failure failure) {
        errorMessage.value = failure.message ?? ManagerStrings.noContent;
        isSuccess.value = false;
      },
          (WithOutDataModel response) {
        isSuccess.value = true;
        AppSnackbar.success("تم إكمال الملف الشخصي بنجاح، استمتع مع حواج!",
        englishMessage: "Profile completed successfully. Enjoy Hawaj!");

      },
    );

    isLoading.value = false;
  }

  /// --- Reset form ---
  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    dateOfBirthController.clear();
    gender.value = 0;
    errorMessage.value = '';
    isSuccess.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
