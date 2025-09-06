import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/data_source/get_my_organization_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/data_source/get_plans_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/data_source/set_subscription_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/get_my_organization_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/get_plan_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/set_subscription_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/use_case/get_plans_use_case.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/use_case/set_subscription_offer_provider_use_case.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/get_plans_controller.dart';
import '../use_case/get_my_organization_offer_provider_use_case.dart';

initGetPlanRequest() {
  if (!GetIt.I.isRegistered<GetPlansDataSource>()) {
    instance.registerLazySingleton<GetPlansDataSource>(
            () => GetPlansDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetPlanRepository>()) {
    instance.registerLazySingleton<GetPlanRepository>(
            () => GetPlanRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetPlansUseCase>()) {
    instance.registerFactory<GetPlansUseCase>(
            () => GetPlansUseCase(instance<GetPlanRepository>()));
  }
}

disposeGetPlanRequest() {
  if (GetIt.I.isRegistered<GetPlansDataSource>()) {
    instance.unregister<GetPlansDataSource>();
  }

  if (GetIt.I.isRegistered<GetPlanRepository>()) {
    instance.unregister<GetPlanRepository>();
  }

  if (GetIt.I.isRegistered<GetPlansUseCase>()) {
    instance.unregister<GetPlansUseCase>();
  }
}

void initGetPlan() {
  initGetPlanRequest();

  Get.put(PlansController(
    instance<GetPlansUseCase>(),
  ));
}

void disposeGetPlan() {
  disposeGetPlanRequest();
  Get.delete<PlansController>();
}

initSetSubscriptionOfferProviderRequest() {
  if (!GetIt.I.isRegistered<SetSubscriptionOfferProviderDataSource>()) {
    instance.registerLazySingleton<SetSubscriptionOfferProviderDataSource>(
            () => SetSubscriptionOfferProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<SetSubscriptionOfferProviderRepository>()) {
    instance.registerLazySingleton<SetSubscriptionOfferProviderRepository>(
            () => SetSubscriptionOfferProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<SetSubscriptionOfferProviderUseCase>()) {
    instance.registerFactory<SetSubscriptionOfferProviderUseCase>(
            () => SetSubscriptionOfferProviderUseCase(instance<SetSubscriptionOfferProviderRepository>()));
  }
}

disposeSetSubscriptionOfferProviderRequest() {
  if (GetIt.I.isRegistered<SetSubscriptionOfferProviderDataSource>()) {
    instance.unregister<SetSubscriptionOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<SetSubscriptionOfferProviderRepository>()) {
    instance.unregister<SetSubscriptionOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<SetSubscriptionOfferProviderUseCase>()) {
    instance.unregister<SetSubscriptionOfferProviderUseCase>();
  }
}

void initSetSubscriptionOfferProvider() {
  initSetSubscriptionOfferProviderRequest();

  // Get.put(LoginController(
  //   instance<LoginUseCase>(),
  //   instance<AppSettingsPrefs>(),
  // ));
}

void disposeSetSubscriptionOfferProvider() {
  disposeSetSubscriptionOfferProviderRequest();
  // Get.delete<LoginController>();
}
initGetMyOrganizationsRequest() {
  if (!GetIt.I.isRegistered<GetMyOrganizationOfferProviderDataSource>()) {
    instance.registerLazySingleton<GetMyOrganizationOfferProviderDataSource>(
            () => GetMyOrganizationOfferProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationOfferProviderRepository>()) {
    instance.registerLazySingleton<GetMyOrganizationOfferProviderRepository>(
            () => GetMyOrganizationOfferProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationOfferProviderUseCase>()) {
    instance.registerFactory<GetMyOrganizationOfferProviderUseCase>(
            () => GetMyOrganizationOfferProviderUseCase(instance<GetMyOrganizationOfferProviderRepository>()));
  }
}

disposeGetMyOrganizationsRequest() {
  if (GetIt.I.isRegistered<GetMyOrganizationOfferProviderDataSource>()) {
    instance.unregister<GetMyOrganizationOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyOrganizationOfferProviderRepository>()) {
    instance.unregister<GetMyOrganizationOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<GetMyOrganizationOfferProviderUseCase>()) {
    instance.unregister<GetMyOrganizationOfferProviderUseCase>();
  }
}

void initGetMyOrganizations() {
  initGetMyOrganizationsRequest();

  // Get.put(LoginController(
  //   instance<LoginUseCase>(),
  //   instance<AppSettingsPrefs>(),
  // ));
}

void disposeGetMyOrganizations() {
  disposeGetMyOrganizationsRequest();
  // Get.delete<LoginController>();
}