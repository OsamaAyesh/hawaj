import 'package:app_mobile/features/providers/offer_provider_new/common/domain/models/get_my_company_model.dart';
import 'package:get/get.dart';

import '../../../common/domain/use_cases/get_my_company_use_case.dart';

class GetMyCompanyController extends GetxController {
  final GetMyCompanyUseCase _useCase;

  /// Loading indicator
  final isLoading = false.obs;

  /// Company data
  final company = Rxn<GetMyCompanyModel>();

  GetMyCompanyController(this._useCase);

  /// Fetch company data
  Future<void> getMyCompany() async {
    isLoading.value = true;

    final result = await _useCase.execute();

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        company.value = data;
        isLoading.value = false;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    getMyCompany();
  }
}
