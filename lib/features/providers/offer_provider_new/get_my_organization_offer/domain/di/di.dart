import 'package:get/get.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../common/domain/use_cases/get_my_company_use_case.dart';
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
