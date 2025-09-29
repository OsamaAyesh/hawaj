import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/request/get_my_company_details_request.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/models/get_my_company_details_model.dart';
import 'package:get/get.dart';

import '../../domain/use_cases/get_my_company_details_use_case.dart';

class DetailsMyCompanyController extends GetxController {
  final GetMyCompanyDetailsUseCase _getMyCompanyDetailsUseCase;

  DetailsMyCompanyController(this._getMyCompanyDetailsUseCase);

  bool isLoading = false;
  GetMyCompanyDetailsModel? companyDetailsData;
  String? errorMessage;
  bool hasError = false;

  @override
  void onInit() {
    super.onInit();
    getMyCompanyDetails();
  }

  Future<void> getMyCompanyDetails() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    update();

    final request = GetMyCompanyDetailsRequest(
      my: true,
      language: Get.locale?.languageCode ?? 'ar',
      lat: "24.7136",
      lng: "46.6753",
    );

    final result = await _getMyCompanyDetailsUseCase.execute(request);

    result.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (data) {
        if (data.error == true || data.data == null) {
          hasError = true;
          errorMessage = data.message ?? "Organization not found";
        } else {
          companyDetailsData = data;
        }
      },
    );

    isLoading = false;
    update();
  }

  Future<void> onRefresh() async {
    await getMyCompanyDetails();
  }
}
