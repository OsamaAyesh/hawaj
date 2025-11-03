import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/data/data_source/add_offer_new_data_source.dart';
import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/data/repository/add_offer_new_repository.dart';
import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/domain/use_cases/add_offer_new_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../common/domain/use_cases/get_my_company_use_case.dart';
import '../../presentaion/controller/add_offer_new_controller.dart';

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
