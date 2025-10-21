import 'package:app_mobile/features/users/real_estate_user/data/data_source/get_real_estate_user_data_source.dart';
import 'package:app_mobile/features/users/real_estate_user/data/repository/get_real_estate_user_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/domain/use_cases/get_real_estate_user_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';

initGetRealEstateUserRequest() {
  if (!GetIt.I.isRegistered<GetRealEstateUserDataSource>()) {
    instance.registerLazySingleton<GetRealEstateUserDataSource>(
        () => GetRealEstateUserDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetRealEstateUserRepository>()) {
    instance.registerLazySingleton<GetRealEstateUserRepository>(
        () => GetRealEstateUserRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetRealEstateUserUseCase>()) {
    instance.registerFactory<GetRealEstateUserUseCase>(() =>
        GetRealEstateUserUseCase(instance<GetRealEstateUserRepository>()));
  }
}

disposeGetRealEstateUserRequest() {
  if (GetIt.I.isRegistered<GetRealEstateUserDataSource>()) {
    instance.unregister<GetRealEstateUserDataSource>();
  }

  if (GetIt.I.isRegistered<GetRealEstateUserRepository>()) {
    instance.unregister<GetRealEstateUserRepository>();
  }

  if (GetIt.I.isRegistered<GetRealEstateUserUseCase>()) {
    instance.unregister<GetRealEstateUserUseCase>();
  }
}

void initGetRealEstateUser() {
  initGetRealEstateUserRequest();
  // Get.put(AddOfferController(
  //   instance<CreateOfferProviderUseCase>(),
  //   instance<GetMyCompanySetOfferUseCase>(),
  // ));
}

void disposeGetRealEstateUser() {
  disposeGetRealEstateUserRequest();
  // Get.delete<AddOfferController>();
}
