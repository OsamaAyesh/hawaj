import 'package:app_mobile/features/splash_and_boarding/data/repository/get_on_boarding_data_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/internet_checker/interent_checker.dart';
import '../../../../core/network/app_api.dart';
import '../../data/data_source/get_on_boarding_data_source.dart';
import '../../presentation/controller/get_on_boarding_controller.dart';
import '../use_case/on_boarding_use_case.dart';

/// Register OnBoarding dependencies into GetIt
void initGetOnBoardingRequest() {
  if (!GetIt.I.isRegistered<GetOnBoardingDataSource>()) {
    instance.registerLazySingleton<GetOnBoardingDataSource>(
          () => GetOnBoardingDataSourceImplement(instance<AppService>()),
    );
  }

  if (!GetIt.I.isRegistered<GetOnBoardingDataRepository>()) {
    instance.registerLazySingleton<GetOnBoardingDataRepository>(
          () => GetOnBoardingDataRepositoryImplement(
        instance<NetworkInfo>(),               // أول باراميتر NetworkInfo
        instance<GetOnBoardingDataSource>(),   // ثاني باراميتر DataSource
      ),
    );
  }

  if (!GetIt.I.isRegistered<OnBoardingUseCase>()) {
    instance.registerFactory<OnBoardingUseCase>(
          () => OnBoardingUseCase(instance<GetOnBoardingDataRepository>()),
    );
  }
}

/// Unregister OnBoarding dependencies
void disposeGetOnBoardingRequest() {
  if (GetIt.I.isRegistered<GetOnBoardingDataSource>()) {
    instance.unregister<GetOnBoardingDataSource>();
  }

  if (GetIt.I.isRegistered<GetOnBoardingDataRepository>()) {
    instance.unregister<GetOnBoardingDataRepository>();
  }

  if (GetIt.I.isRegistered<OnBoardingUseCase>()) {
    instance.unregister<OnBoardingUseCase>();
  }
}

/// Init OnBoarding Controller using GetX
void initGetOnBoarding() {
  initGetOnBoardingRequest();

  // Important: controller uses the UseCase from GetIt
  Get.put<OnBoardingPreloadController>(
    OnBoardingPreloadController(instance<OnBoardingUseCase>()),
    permanent: true,
  );
}

/// Dispose OnBoarding Controller and its dependencies
void disposeGetOnBoarding() {
  if (Get.isRegistered<OnBoardingPreloadController>()) {
    Get.delete<OnBoardingPreloadController>();
  }
  disposeGetOnBoardingRequest();
}
