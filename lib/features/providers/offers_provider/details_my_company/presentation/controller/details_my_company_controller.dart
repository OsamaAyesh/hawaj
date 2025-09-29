import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/request/get_my_company_details_request.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/models/get_my_company_details_model.dart';
import 'package:get/get.dart';

import '../../domain/use_cases/get_my_company_details_use_case.dart';

class DetailsMyCompanyController extends GetxController {
  final GetMyCompanyDetailsUseCase _getMyCompanyDetailsUseCase;

  DetailsMyCompanyController(this._getMyCompanyDetailsUseCase);

  bool isLoading = false;
  GetMyCompanyDetailsModel? companyDetailsData;

  @override
  void onInit() {
    super.onInit();
    getMyCompanyDetails();
  }

  Future<void> getMyCompanyDetails() async {
    isLoading = true;
    update();

    final request = GetMyCompanyDetailsRequest(
      my: true,
      language: AppLanguage().getCurrentLocale(),
      lat: "24.7136", // Default latitude - يمكنك استبداله لاحقاً
      lng: "46.6753", // Default longitude - يمكنك استبداله لاحقاً
    );

    final result = await _getMyCompanyDetailsUseCase.execute(request);

    result.fold(
      (failure) {
        // Handle error
      },
      (data) {
        companyDetailsData = data;
      },
    );

    isLoading = false;
    update();
  }

  Future<void> onRefresh() async {
    await getMyCompanyDetails();
  }
}
