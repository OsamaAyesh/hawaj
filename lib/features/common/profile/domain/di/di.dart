
import 'package:app_mobile/features/common/profile/data/data_source/update_profile_data_source.dart';
import 'package:app_mobile/features/common/profile/data/repository/update_profile_repository.dart';
import 'package:app_mobile/features/common/profile/domain/use_case/update_profile_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';

initUpdateProfileRequest() {
  if (!GetIt.I.isRegistered<UpdateProfileDataSource>()) {
    instance.registerLazySingleton<UpdateProfileDataSource>(
            () => UpdateProfileDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<UpdateProfileRepository>()) {
    instance.registerLazySingleton<UpdateProfileRepository>(
            () => UpdateProfileRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<UpdateProfileUseCase>()) {
    instance.registerFactory<UpdateProfileUseCase>(
            () => UpdateProfileUseCase(instance<UpdateProfileUseCase>()));
  }
}

disposeUpdateProfileRequest() {
  if (GetIt.I.isRegistered<UpdateProfileDataSource>()) {
    instance.unregister<UpdateProfileDataSource>();
  }

  if (GetIt.I.isRegistered<UpdateProfileUseCase>()) {
    instance.unregister<UpdateProfileUseCase>();
  }

  if (GetIt.I.isRegistered<UpdateProfileUseCase>()) {
    instance.unregister<UpdateProfileUseCase>();
  }
}

void initUpdateProfile() {
  initUpdateProfileRequest();
  // Get.put(SendOtpController(
  //   instance<SendOtpUseCase>(),
  //   instance<VerfiyOtpUseCase>(),
  // ));
}

void disposeUpdateProfile() {
  disposeUpdateProfileRequest();
  // Get.delete<SendOtpController>();
}
