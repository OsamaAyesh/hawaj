import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../data/request/edit_my_real_estate_request.dart';
import '../../domain/use_cases/edit_my_real_estate_use_case.dart';

class EditMyRealEstateController extends GetxController {
  final EditMyRealEstateUseCase _editMyRealEstateUseCase;

  EditMyRealEstateController(this._editMyRealEstateUseCase);

  final isLoading = false.obs;

  Future<void> editRealEstate(EditMyRealEstateRequest request) async {
    try {
      isLoading.value = true;

      final Either<Failure, WithOutDataModel> response =
          await _editMyRealEstateUseCase.execute(request);

      response.fold(
        (failure) {
          AppSnackbar.error(failure.message);
        },
        (data) {
          AppSnackbar.success("تم تعديل العقار بنجاح ");
        },
      );
    } catch (e) {
      AppSnackbar.error("حدث خطأ أثناء تعديل العقار");
    } finally {
      isLoading.value = false;
    }
  }
}
