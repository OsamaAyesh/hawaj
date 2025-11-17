import 'package:get/get.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../offer_provider_new/common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../../offer_provider_new/common/domain/use_cases/get_my_company_use_case.dart'
    show GetMyCompanyUseCase;
import '../../presentation/controller/get_my_organization_offer_controller.dart';

void initGetMyOrganizationOffer() {
  initGetMyCompanyNew();
  Get.put(
    GetMyCompanyController(
      instance<GetMyCompanyUseCase>(),
    ),
  );
}

void disposeGetMyOrganizationOffer() {
  disposeGetMyCompanyNew();
  Get.delete<GetMyCompanyController>();
}
