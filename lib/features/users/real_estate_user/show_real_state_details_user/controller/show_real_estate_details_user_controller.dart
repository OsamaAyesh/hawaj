import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/real_estate_item_model.dart';
import 'package:app_mobile/features/users/real_estate_user/data/request/get_real_estate_user_request.dart';
import 'package:app_mobile/features/users/real_estate_user/domain/use_cases/get_real_estate_user_use_case.dart';
import 'package:get/get.dart';

/// ===============================
/// 🔹 Controller: GetRealEstateUserController
/// ===============================
class GetRealEstateUserController extends GetxController {
  final GetRealEstateUserUseCase _getRealEstateUserUseCase;

  GetRealEstateUserController(this._getRealEstateUserUseCase);

  /// الحالة العامة
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final realEstate = Rxn<RealEstateItemModel>();

  /// دالة لجلب العقار بناءً على ID والموقع
  Future<void> getRealEstateUser({
    required String id,
    required String language,
    required String lat,
    required String lng,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = GetRealEstateUserRequest(
        id: id,
        language: language,
        lat: lat,
        lng: lng,
      );

      final result = await _getRealEstateUserUseCase.execute(request);

      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message ?? "حدث خطأ أثناء جلب البيانات";
        },
        (response) {
          if (response.error) {
            errorMessage.value = response.message;
          } else {
            realEstate.value = response.data;
          }
        },
      );
    } catch (e) {
      errorMessage.value = "حدث خطأ غير متوقع: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// لإعادة تحميل البيانات (Pull to refresh)
  Future<void> refreshRealEstate({
    required String id,
    required String language,
    required String lat,
    required String lng,
  }) async {
    await getRealEstateUser(id: id, language: language, lat: lat, lng: lng);
  }
}
