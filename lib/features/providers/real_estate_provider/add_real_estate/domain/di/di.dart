import 'package:app_mobile/features/providers/real_estate_provider/add_real_estate/data/data_source/add_real_estate_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/add_real_estate/domain/use_cases/add_real_estate_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../data/repository/add_real_estate_repository.dart';

initAddRealEstateRequest() {
  if (!GetIt.I.isRegistered<AddRealEstateDataSource>()) {
    instance.registerLazySingleton<AddRealEstateDataSource>(
        () => AddRealEstateDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddRealEstateRepository>()) {
    instance.registerLazySingleton<AddRealEstateRepository>(
        () => AddRealEstateRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddRealEstateUseCase>()) {
    instance.registerFactory<AddRealEstateUseCase>(
        () => AddRealEstateUseCase(instance<AddRealEstateRepository>()));
  }
}

disposeAddRealEstateRequest() {
  if (GetIt.I.isRegistered<AddRealEstateDataSource>()) {
    instance.unregister<AddRealEstateDataSource>();
  }

  if (GetIt.I.isRegistered<AddRealEstateRepository>()) {
    instance.unregister<AddRealEstateRepository>();
  }

  if (GetIt.I.isRegistered<AddRealEstateUseCase>()) {
    instance.unregister<AddRealEstateUseCase>();
  }
}

void initAddRealEstate() {
  initAddRealEstateRequest();
  // Get.put(SendOtpController(
  //   instance<SendOtpUseCase>(),
  //   instance<VerfiyOtpUseCase>(),
  // ));
}

void disposeAddRealEstate() {
  disposeAddRealEstateRequest();
  // Get.delete<SendOtpController>();
}
