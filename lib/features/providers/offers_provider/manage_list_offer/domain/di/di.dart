import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/data_source/get_my_offer_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/repository/get_my_offer_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/use_case/get_my_offer_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initGetMyOfferProviderRequest() {
  if (!GetIt.I.isRegistered<GetMyOfferDataSource>()) {
    instance.registerLazySingleton<GetMyOfferDataSource>(
            () => GetMyOfferDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyOfferRepository>()) {
    instance.registerLazySingleton<GetMyOfferRepository>(
            () => GetMyOfferRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyOfferUseCase>()) {
    instance.registerFactory<GetMyOfferUseCase>(
            () => GetMyOfferUseCase(instance<GetMyOfferRepository>()));
  }
}

disposeGetMyOfferProviderRequest() {
  if (GetIt.I.isRegistered<GetMyOfferDataSource>()) {
    instance.unregister<GetMyOfferDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyOfferRepository>()) {
    instance.unregister<GetMyOfferRepository>();
  }

  if (GetIt.I.isRegistered<GetMyOfferUseCase>()) {
    instance.unregister<GetMyOfferUseCase>();
  }
}

void initGetMyOfferProvider() {
  initGetMyOfferProviderRequest();
  // Get.put(RegisterMyCompanyOfferProviderController(
  //   instance<RegisterMyCompanyOfferProviderUseCase>(),
  // ));
}

void disposeGetMyOfferProvider() {
  disposeGetMyOfferProviderRequest();
  // Get.delete<RegisterMyCompanyOfferProviderController>();
}