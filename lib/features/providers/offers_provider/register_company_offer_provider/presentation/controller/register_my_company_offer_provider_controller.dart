import 'dart:io';
import 'package:get/get.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/request/register_my_company_offer_provider_request.dart';

import '../../domain/use_case/register_my_company_offer_provider_use_case.dart';

class RegisterMyCompanyOfferProviderController extends GetxController {
  final RegisterMyCompanyOfferProviderUseCase _useCase;

  RegisterMyCompanyOfferProviderController(this._useCase);

  /// ================= Observables =================
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;

  /// Form fields
  var organizationName = ''.obs;
  var organizationServices = ''.obs;
  var organizationType = ''.obs;
  var organizationLocation = ''.obs;
  var organizationDetailedAddress = ''.obs;
  var managerName = ''.obs;
  var phoneNumber = ''.obs;
  var workingHours = ''.obs;
  var commercialRegistrationNumber = ''.obs;
  var organizationStatus = ''.obs;

  /// File pickers
  File? organizationLogo;
  File? organizationBanner;
  File? commercialRegistrationFile;

  /// ================== Methods ==================

  /// Update file fields
  void setOrganizationLogo(File file) {
    organizationLogo = file;
    update();
  }

  void setOrganizationBanner(File file) {
    organizationBanner = file;
    update();
  }

  void setCommercialRegistrationFile(File file) {
    commercialRegistrationFile = file;
    update();
  }

  /// Main submit
  Future<void> registerOrganization() async {
    isLoading.value = true;
    errorMessage.value = '';
    isSuccess.value = false;

    final request = RegisterMyCompanyOfferProviderRequest(
      organizationName: organizationName.value,
      organizationServices: organizationServices.value,
      organizationType: organizationType.value,
      organizationLocation: organizationLocation.value,
      organizationDetailedAddress: organizationDetailedAddress.value,
      managerName: managerName.value,
      phoneNumber: phoneNumber.value,
      workingHours: workingHours.value,
      commercialRegistrationNumber: commercialRegistrationNumber.value,
      organizationStatus: organizationStatus.value,
      organizationLogo: organizationLogo,
      organizationBanner: organizationBanner,
      commercialRegistrationFile: commercialRegistrationFile,
    );

    final result = await _useCase.execute(request);

    result.fold(
          (Failure failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
          (WithOutDataModel response) {
        isSuccess.value = true;
        isLoading.value = false;
      },
    );
  }

  /// Reset state
  void resetState() {
    isLoading.value = false;
    errorMessage.value = '';
    isSuccess.value = false;
  }
}
