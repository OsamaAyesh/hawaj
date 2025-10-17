import 'package:get/get.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/util/snack_bar.dart';
import '../../data/request/get_lists_request.dart';
import '../../domain/models/get_lists_model.dart';
import '../../domain/use_cases/get_lists_use_case.dart';

class GetListsController extends GetxController {
  final GetListsUseCase _getListsUseCase;

  /// Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final data = Rxn<GetListsModel>();

  GetListsController(this._getListsUseCase);

  /// Fetch all lists data
  Future<void> getLists({String language = 'ar'}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result =
        await _getListsUseCase.execute(GetListsRequest(language: language));

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        AppSnackbar.error(failure.message);
      },
      (GetListsModel response) {
        data.value = response;
        AppSnackbar.success('تم جلب البيانات بنجاح',
            englishMessage: "Data fetched successfully");
      },
    );

    isLoading.value = false;
  }

  /// Reset controller state
  void clearData() {
    data.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
