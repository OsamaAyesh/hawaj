import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../offer_provider_new/common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../../offer_provider_new/common/domain/use_cases/get_my_company_use_case.dart'
    show GetMyCompanyUseCase;
import '../../data/data_source/add_offer_new_data_source.dart';
import '../../data/repository/add_offer_new_repository.dart';
import '../../presentaion/controller/add_offer_new_controller.dart';
import '../use_cases/add_offer_new_use_case.dart';

initAddOfferNewRequest() {
  if (!GetIt.I.isRegistered<AddOfferNewDataSource>()) {
    instance.registerLazySingleton<AddOfferNewDataSource>(
        () => AddOfferNewDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddOfferNewRepository>()) {
    instance.registerLazySingleton<AddOfferNewRepository>(
        () => AddOfferNewRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddOfferNewUseCase>()) {
    instance.registerFactory<AddOfferNewUseCase>(
        () => AddOfferNewUseCase(instance<AddOfferNewRepository>()));
  }
}

disposeAddOfferNewRequest() {
  if (GetIt.I.isRegistered<AddOfferNewDataSource>()) {
    instance.unregister<AddOfferNewDataSource>();
  }

  if (GetIt.I.isRegistered<AddOfferNewRepository>()) {
    instance.unregister<AddOfferNewRepository>();
  }

  if (GetIt.I.isRegistered<AddOfferNewUseCase>()) {
    instance.unregister<AddOfferNewUseCase>();
  }
}

void initAddOfferNew() {
  initAddOfferNewRequest();
  initGetMyCompanyNew();
  Get.put(AddOfferNewController(
    instance<AddOfferNewUseCase>(),
    instance<GetMyCompanyUseCase>(),
  ));
}

void disposeAddOfferNew() {
  disposeAddOfferNewRequest();
  disposeGetMyCompanyNew();
  Get.delete<AddOfferNewController>();
}
