import 'package:get/get.dart';
import 'package:app_mobile/core/error_handler/failure.dart';

import '../../domain/model/get_profile_model.dart';
import '../../domain/use_case/get_profile_use_case.dart';

/// Manages profile state: loading, refreshing, error, and data.
class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;

  ProfileController(this._getProfileUseCase);

  /// Reactive states
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final profileData = Rxn<GetProfileModel>();
  final errorMessage = ''.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  /// Initial load / retry
  Future<void> loadProfileData() async {
    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final result = await _getProfileUseCase.execute();

      result.fold(
            (Failure failure) {
          hasError.value = true;
          errorMessage.value = failure.message ?? 'Something went wrong';
          profileData.value = null;
        },
            (GetProfileModel data) {
          profileData.value = data;
          hasError.value = false;
        },
      );
    } catch (_) {
      hasError.value = true;
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh (keeps old data on failure)
  Future<void> refreshProfileData() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    // Keep current data while refreshing

    try {
      final result = await _getProfileUseCase.execute();

      result.fold(
            (Failure failure) {
          // Keep existing data, just expose error message
          errorMessage.value = failure.message ?? 'Something went wrong';
          hasError.value = profileData.value == null;
        },
            (GetProfileModel data) {
          profileData.value = data;
          hasError.value = false;
          errorMessage.value = '';
        },
      );
    } catch (_) {
      errorMessage.value = 'An unexpected error occurred';
      hasError.value = profileData.value == null;
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Retry action from error view
  void retryLoading() {
    hasError.value = false;
    loadProfileData();
  }
}
