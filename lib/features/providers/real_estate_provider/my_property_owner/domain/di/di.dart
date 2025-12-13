import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart' show instance;
import '../../../../../../core/network/app_api.dart';
import '../../../edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
import '../../../edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
import '../../../edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import '../../../get_real_estate_my_owners/presentation/controller/get_my_real_estate_my_owner_controller.dart';
import '../../persentation/controller/get_my_property_owner_controller.dart';

void initGetMyPropertyOwnersModule() {
  /// ======== Data Source ========
  if (!GetIt.I.isRegistered<GetPropertyOwnersDataSource>()) {
    instance.registerLazySingleton<GetPropertyOwnersDataSource>(
      () => GetPropertyOwnersDataSourceImplement(instance<AppService>()),
    );
  }

  /// ======== Repository ========
  if (!GetIt.I.isRegistered<GetPropertyOwnersRepository>()) {
    instance.registerLazySingleton<GetPropertyOwnersRepository>(
      () => GetPropertyOwnersRepositoryImplement(instance(), instance()),
    );
  }

  /// ======== Use Case ========
  if (!GetIt.I.isRegistered<GetPropertyOwnersUseCases>()) {
    instance.registerFactory<GetPropertyOwnersUseCases>(
      () => GetPropertyOwnersUseCases(instance<GetPropertyOwnersRepository>()),
    );
  }

  /// ======== Controller ========
  if (!Get.isRegistered<GetRealEstateMyOwnersController>()) {
    Get.put(
      GetMyPropertyOwnerController(instance<GetPropertyOwnersUseCases>()),
    );
  }
}

void disposeGetMyPropertyOwnersModule() {
  if (Get.isRegistered<GetMyPropertyOwnerController>()) {
    Get.delete<GetMyPropertyOwnerController>();
  }
}
