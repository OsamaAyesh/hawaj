import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../common/domain/use_cases/get_my_company_use_case.dart';

class GetMyCompanyController extends GetxController {
  final GetMyCompanyUseCase _useCase;

  /// Loading indicator
  final isLoading = false.obs;

  /// Company data
  final companies = <GetOrganizationItemWithOfferModel>[].obs;

  GetMyCompanyController(this._useCase);

  /// Fetch company data
  Future<void> getMyCompany() async {
    isLoading.value = true;

    final result = await _useCase.execute();

    result.fold(
      (failure) {
        isLoading.value = false;
        AppSnackbar.error(failure.message);
      },
      (data) {
        companies.value = data.data;
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
