import 'package:app_mobile/features/users/offer_user/list_offers/data/data_source/get_offers_user_data_source.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/data/repository/get_offers_user_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/get_offers_controller.dart';
import '../use_case/get_offer_use_case.dart';

initGetOfferUserRequest() {
  if (!GetIt.I.isRegistered<GetOffersUserDataSource>()) {
    instance.registerLazySingleton<GetOffersUserDataSource>(
            () => GetOffersUserDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetOffersUserRepository>()) {
    instance.registerLazySingleton<GetOffersUserRepository>(
            () => GetOffersUserRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetOfferUseCase>()) {
    instance.registerFactory<GetOfferUseCase>(
            () => GetOfferUseCase(instance<GetOffersUserRepository>()));
  }
}

disposeGetOfferUserRequest() {
  if (GetIt.I.isRegistered<GetOffersUserDataSource>()) {
    instance.unregister<GetOffersUserDataSource>();
  }

  if (GetIt.I.isRegistered<GetOffersUserRepository>()) {
    instance.unregister<GetOffersUserRepository>();
  }

  if (GetIt.I.isRegistered<GetOfferUseCase>()) {
    instance.unregister<GetOfferUseCase>();
  }
}

void initGetOfferUser() {
  initGetOfferUserRequest();
  Get.put(OffersController(
    instance<GetOfferUseCase>(),
  ));
}

void disposeGetOfferUser() {
  disposeGetOfferUserRequest();
  Get.delete<OffersController>();
}