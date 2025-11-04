import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/users/real_estate_user/data/request/add_visit_request.dart';
import 'package:get/get.dart';

import '../../domain/use_cases/add_visit_use_case.dart';

/// ===============================
/// 🔹 Controller: AddVisitController
/// ===============================
class AddVisitController extends GetxController {
  final AddVisitUseCase _addVisitUseCase;

  AddVisitController(this._addVisitUseCase);

  /// حالة التحميل
  final isLoading = false.obs;

  /// رسالة الخطأ
  final errorMessage = ''.obs;

  /// رسالة النجاح
  final successMessage = ''.obs;

  /// تنفيذ طلب حجز الزيارة للعقار
  Future<void> addVisit({
    required String visitDate,
    required String timeFrom,
    required String timeTo,
    required String visitorMemberId,
    required String propertyId,
    required String visitStatus,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final request = AddMyVisitRequest(
        visitDate: visitDate,
        timeFrom: timeFrom,
        timeTo: timeTo,
        visitorMemberId: visitorMemberId,
        propertyId: propertyId,
        visitStatus: visitStatus,
      );

      final result = await _addVisitUseCase.execute(request);

      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message ?? "حدث خطأ أثناء إرسال الطلب.";
        },
        (WithOutDataModel response) {
          if (response.error) {
            errorMessage.value = response.message;
          } else {
            successMessage.value = response.message;
          }
        },
      );
    } catch (e) {
      errorMessage.value = "حدث خطأ غير متوقع: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// لإعادة ضبط الحالة بعد العملية
  void reset() {
    isLoading.value = false;
    errorMessage.value = '';
    successMessage.value = '';
  }
}
