import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initGetPropertyOwnersRequest() {
  if (!GetIt.I.isRegistered<GetPropertyOwnersDataSource>()) {
    instance.registerLazySingleton<GetPropertyOwnersDataSource>(
        () => GetPropertyOwnersDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetPropertyOwnersRepository>()) {
    instance.registerLazySingleton<GetPropertyOwnersRepository>(
        () => GetPropertyOwnersRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetPropertyOwnersUseCases>()) {
    instance.registerFactory<GetPropertyOwnersUseCases>(() =>
        GetPropertyOwnersUseCases(instance<GetPropertyOwnersRepository>()));
  }
}

disposeGetPropertyOwnersRequest() {
  if (GetIt.I.isRegistered<GetPropertyOwnersDataSource>()) {
    instance.unregister<GetPropertyOwnersDataSource>();
  }

  if (GetIt.I.isRegistered<GetPropertyOwnersRepository>()) {
    instance.unregister<GetPropertyOwnersRepository>();
  }

  if (GetIt.I.isRegistered<GetPropertyOwnersUseCases>()) {
    instance.unregister<GetPropertyOwnersUseCases>();
  }
}

void initGetPropertyOwners() {
  initGetPropertyOwnersRequest();
  // Get.put(SendOtpController(
  //   instance<SendOtpUseCase>(),
  //   instance<VerfiyOtpUseCase>(),
  // ));
}

void disposeGetPropertyOwners() {
  disposeGetPropertyOwnersRequest();
  // Get.delete<SendOtpController>();
}
