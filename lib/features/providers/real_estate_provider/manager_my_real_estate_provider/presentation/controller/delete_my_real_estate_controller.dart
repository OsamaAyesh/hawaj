import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../data/request/delete_my_real_estate_request.dart';
import '../../domain/use_cases/delete_my_real_estate_use_case.dart';

class DeleteMyRealEstateController extends GetxController {
  final DeleteMyRealEstateUseCase _deleteMyRealEstateUseCase;

  DeleteMyRealEstateController(this._deleteMyRealEstateUseCase);

  /// Reactive loading indicator
  final isLoading = false.obs;

  /// Function to call the delete use case
  Future<void> deleteRealEstate(double id) async {
    isLoading.value = true;

    final Either<Failure, WithOutDataModel> response =
        await _deleteMyRealEstateUseCase.execute(DeleteMyRealEstateRequest(
            language: AppLanguage().getCurrentLocale(),
            lng: "31.0",
            lat: "21.0",
            id: id));

    response.fold(
      (failure) {
        AppSnackbar.error(failure.message);
      },
      (data) {
        AppSnackbar.success("تم حذف العقار بنجاح 🗑️");
        update(); // To refresh data in the UI if needed
      },
    );

    isLoading.value = false;
  }
}
