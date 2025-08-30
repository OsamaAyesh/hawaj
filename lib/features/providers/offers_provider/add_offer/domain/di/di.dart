import 'package:app_mobile/features/providers/offers_provider/add_offer/data/data_source/create_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/repository/create_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/domain/use_case/create_offer_provider_use_case.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/add_offer_controller.dart';

initCreateOfferProviderRequest() {
  if (!GetIt.I.isRegistered<CreateOfferProviderDataSource>()) {
    instance.registerLazySingleton<CreateOfferProviderDataSource>(
            () => CreateOfferProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CreateOfferProviderRepository>()) {
    instance.registerLazySingleton<CreateOfferProviderRepository>(
            () => CreateOfferProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CreateOfferProviderUseCase>()) {
    instance.registerFactory<CreateOfferProviderUseCase>(
            () => CreateOfferProviderUseCase(instance<CreateOfferProviderRepository>()));
  }
}

disposeCreateOfferProviderRequest() {
  if (GetIt.I.isRegistered<CreateOfferProviderDataSource>()) {
    instance.unregister<CreateOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<CreateOfferProviderRepository>()) {
    instance.unregister<CreateOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<CreateOfferProviderUseCase>()) {
    instance.unregister<CreateOfferProviderUseCase>();
  }
}

void initCreateOfferProvider() {
  initCreateOfferProviderRequest();
  Get.put(CreateOfferProviderController(
    instance<CreateOfferProviderUseCase>(),
  ));
}

void disposeCreateOfferProvider() {
  disposeCreateOfferProviderRequest();
  Get.delete<CreateOfferProviderController>();
}