import 'package:get/get.dart';

import '../../data/request/get_my_organization_details_request.dart';
import '../../domain/models/get_my_organization_details_model.dart';
import '../../domain/use_cases/get_my_organization_details_use_case.dart';

class DetailsMyOrganizationController extends GetxController {
  final GetMyOrganizationDetailsUseCase _getMyCompanyDetailsUseCase;

  DetailsMyOrganizationController(this._getMyCompanyDetailsUseCase);

  // State variables
  bool isLoading = false;
  GetMyOrganizationDetailsModel? companyDetailsData;
  String? errorMessage;
  bool hasError = false;
  String? currentCompanyId;

  @override
  void onInit() {
    super.onInit();
    // Don't call getMyCompanyDetails here - it will be called from screen
  }

  /// Fetch company details by ID
  Future<void> getMyCompanyDetails(String id) async {
    currentCompanyId = id;
    isLoading = true;
    hasError = false;
    errorMessage = null;
    update();

    final request = GetMyOrganizationDetailsRequest(
      id: id,
    );

    final result = await _getMyCompanyDetailsUseCase.execute(request);

    result.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
        isLoading = false;
        update();
      },
      (data) {
        if (data.error == true) {
          hasError = true;
          errorMessage = data.message ?? "Organization not found";
        } else {
          companyDetailsData = data;
          hasError = false;
        }
        isLoading = false;
        update();
      },
    );
  }

  /// Refresh company details
  Future<void> onRefresh() async {
    if (currentCompanyId != null) {
      await getMyCompanyDetails(currentCompanyId!);
    }
  }

  @override
  void onClose() {
    companyDetailsData = null;
    currentCompanyId = null;
    super.onClose();
  }
}
