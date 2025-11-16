import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/data/repository/get_my_organization_not_subscription_repository.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/domain/use_cases/get_my_organization_not_subscription_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/get_my_organization_not_subscription_data_source.dart';
import '../../data/data_source/get_offer_plans_data_source.dart';
import '../../data/repository/get_offer_plans_repository.dart';
import '../use_cases/get_offer_plans_use_case.dart';

initGetOfferPlansRequest() {
  if (!GetIt.I.isRegistered<GetOfferPlansDataSource>()) {
    instance.registerLazySingleton<GetOfferPlansDataSource>(
        () => GetOfferPlansDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetOfferPlansRepository>()) {
    instance.registerLazySingleton<GetOfferPlansRepository>(
        () => GetOfferPlansRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetOfferPlansUseCase>()) {
    instance.registerFactory<GetOfferPlansUseCase>(
        () => GetOfferPlansUseCase(instance<GetOfferPlansRepository>()));
  }
}

disposeOfferPlansRequest() {
  if (GetIt.I.isRegistered<GetOfferPlansDataSource>()) {
    instance.unregister<GetOfferPlansDataSource>();
  }

  if (GetIt.I.isRegistered<GetOfferPlansRepository>()) {
    instance.unregister<GetOfferPlansRepository>();
  }

  if (GetIt.I.isRegistered<GetOfferPlansUseCase>()) {
    instance.unregister<GetOfferPlansUseCase>();
  }
}

void initGetOfferPlans() {
  initGetOfferPlansRequest();
  // Get.put(AddOfferNewController(
  //   instance<AddOfferNewUseCase>(),
  //   instance<GetMyCompanyUseCase>(),
  // ));
}

void disposeGetOfferPlans() {
  disposeOfferPlansRequest();
  // Get.delete<AddOfferNewController>();
}

initGetMyOrganizationRequest() {
  if (!GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionDataSource>()) {
    instance.registerLazySingleton<GetMyOrganizationNotSubscriptionDataSource>(
        () => GetMyOrganizationNotSubscriptionDataSourceImplement(
            instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionRepository>()) {
    instance.registerLazySingleton<GetMyOrganizationNotSubscriptionRepository>(
        () => GetMyOrganizationNotSubscriptionRepositoryImplement(
            instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionUseCase>()) {
    instance.registerFactory<GetMyOrganizationNotSubscriptionUseCase>(() =>
        GetMyOrganizationNotSubscriptionUseCase(
            instance<GetMyOrganizationNotSubscriptionRepository>()));
  }
}

disposeGetMyOrganizationRequest() {
  if (GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionDataSource>()) {
    instance.unregister<GetMyOrganizationNotSubscriptionDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionRepository>()) {
    instance.unregister<GetMyOrganizationNotSubscriptionRepository>();
  }

  if (GetIt.I.isRegistered<GetMyOrganizationNotSubscriptionUseCase>()) {
    instance.unregister<GetMyOrganizationNotSubscriptionUseCase>();
  }
}

void initGetMyOrganizationPlans() {
  initGetMyOrganizationRequest();
  // Get.put(AddOfferNewController(
  //   instance<AddOfferNewUseCase>(),
  //   instance<GetMyCompanyUseCase>(),
  // ));
}

void disposeGetMyOrganizationPlans() {
  disposeGetMyOrganizationRequest();
  // Get.delete<AddOfferNewController>();
}
