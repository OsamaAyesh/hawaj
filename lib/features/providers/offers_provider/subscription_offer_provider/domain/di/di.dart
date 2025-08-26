import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/data_source/get_plans_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/get_plan_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/use_case/get_plans_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

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

  // Get.put(LoginController(
  //   instance<LoginUseCase>(),
  //   instance<AppSettingsPrefs>(),
  // ));
}

void disposeGetPlan() {
  disposeGetPlanRequest();
  // Get.delete<LoginController>();
}