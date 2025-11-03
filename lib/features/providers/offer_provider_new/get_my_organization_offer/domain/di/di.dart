import 'package:get/get.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../offers_provider/add_offer/domain/di/di.dart';
import '../../../common/domain/use_cases/get_my_company_use_case.dart';
import '../../presentation/controller/get_my_organization_offer_controller.dart';

void initGetMyOrganizationOffer() {
  initGetMyCompany();
  Get.put(
    GetMyCompanyController(
      instance<GetMyCompanyUseCase>(),
    ),
  );
}

void disposeGetMyOrganizationOffer() {
  disposeGetMyCompany();
  Get.delete<GetMyCompanyController>();
}
