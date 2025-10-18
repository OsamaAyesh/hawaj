import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/get_my_real_estates_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/get_my_real_estates_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/get_my_real_estates_use_cases.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initGetMyRealEstatesRequest() {
  if (!GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
    instance.registerLazySingleton<GetMyRealEstatesDataSource>(
        () => GetMyRealEstatesDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
    instance.registerLazySingleton<GetMyRealEstatesRepository>(
        () => GetMyRealEstatesRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
    instance.registerFactory<GetMyRealEstatesUseCases>(
        () => GetMyRealEstatesUseCases(instance<GetMyRealEstatesRepository>()));
  }
}

disposeGetMyRealEstatesRequest() {
  if (GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
    instance.unregister<GetMyRealEstatesDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
    instance.unregister<GetMyRealEstatesRepository>();
  }

  if (GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
    instance.unregister<GetMyRealEstatesUseCases>();
  }
}

void initGetMyRealEstates() {
  initGetMyRealEstatesRequest();
  // Get.put(AddOfferController(
  //   instance<CreateOfferProviderUseCase>(),
  //   instance<GetMyCompanySetOfferUseCase>(),
  // ));
}

void disposeGetMyRealEstates() {
  disposeGetMyRealEstatesRequest();
  // Get.delete<AddOfferController>();
}
