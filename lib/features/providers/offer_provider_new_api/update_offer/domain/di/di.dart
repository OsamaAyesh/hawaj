// di.dart
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../common/domain/use_cases/get_my_company_use_case.dart';
import '../../data/data_source/update_offer_data_source.dart';
import '../../data/repository/update_offer_repository.dart';
import '../../presentation/controller/update_offer_controller.dart';
import '../use_cases/update_offer_use_case.dart';

void initUpdateOfferRequest() {
  if (!GetIt.I.isRegistered<UpdateOfferDataSource>()) {
    instance.registerLazySingleton<UpdateOfferDataSource>(
        () => UpdateOfferDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<UpdateOfferRepository>()) {
    instance.registerLazySingleton<UpdateOfferRepository>(
        () => UpdateOfferRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<UpdateOfferUseCase>()) {
    instance.registerFactory<UpdateOfferUseCase>(
        () => UpdateOfferUseCase(instance<UpdateOfferRepository>()));
  }
}

void disposeUpdateOfferRequest() {
  if (GetIt.I.isRegistered<UpdateOfferDataSource>()) {
    instance.unregister<UpdateOfferDataSource>();
  }

  if (GetIt.I.isRegistered<UpdateOfferRepository>()) {
    instance.unregister<UpdateOfferRepository>();
  }

  if (GetIt.I.isRegistered<UpdateOfferUseCase>()) {
    instance.unregister<UpdateOfferUseCase>();
  }
}

void initUpdateOffer(dynamic offerModel) {
  initUpdateOfferRequest();
  initGetMyCompanyNew();
  Get.put(UpdateOfferController(
    instance<UpdateOfferUseCase>(),
    instance<GetMyCompanyUseCase>(),
    offerModel, // Pass the offer model here
  ));
}

void disposeUpdateOffer() {
  disposeUpdateOfferRequest();
  disposeGetMyCompanyNew();
  Get.delete<UpdateOfferController>();
}
