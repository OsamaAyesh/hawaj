import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
// ===== Common Lists =====
import '../../../../../common/lists/data/data_source/get_lists_data_source.dart';
import '../../../../../common/lists/data/repository/get_lists_repository.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
// ===== Get Property Owners =====
import '../../../edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
import '../../../edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
import '../../../edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
// ===== Add Real Estate =====
import '../../data/data_source/add_real_estate_data_source.dart';
import '../../data/repository/add_real_estate_repository.dart';
import '../../domain/use_cases/add_real_estate_use_case.dart';
// ===== Controller =====
import '../../presentation/controller/add_real_estate_controller.dart';

void initAddRealEstateModule() {
  final instance = GetIt.I;

  /// ======== Get Lists ========
  if (!instance.isRegistered<GetListsDataSource>()) {
    instance.registerLazySingleton<GetListsDataSource>(
        () => GetListsDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<GetListsRepository>()) {
    instance.registerLazySingleton<GetListsRepository>(
        () => GetListsRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<GetListsUseCase>()) {
    instance.registerFactory<GetListsUseCase>(
        () => GetListsUseCase(instance<GetListsRepository>()));
  }

  /// ======== Add Real Estate ========
  if (!instance.isRegistered<AddRealEstateDataSource>()) {
    instance.registerLazySingleton<AddRealEstateDataSource>(
        () => AddRealEstateDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<AddRealEstateRepository>()) {
    instance.registerLazySingleton<AddRealEstateRepository>(
        () => AddRealEstateRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<AddRealEstateUseCase>()) {
    instance.registerFactory<AddRealEstateUseCase>(
        () => AddRealEstateUseCase(instance<AddRealEstateRepository>()));
  }

  /// ======== Get Property Owners ========
  if (!instance.isRegistered<GetPropertyOwnersDataSource>()) {
    instance.registerLazySingleton<GetPropertyOwnersDataSource>(
        () => GetPropertyOwnersDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<GetPropertyOwnersRepository>()) {
    instance.registerLazySingleton<GetPropertyOwnersRepository>(
        () => GetPropertyOwnersRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<GetPropertyOwnersUseCases>()) {
    instance.registerFactory<GetPropertyOwnersUseCases>(() =>
        GetPropertyOwnersUseCases(instance<GetPropertyOwnersRepository>()));
  }

  /// ======== Controller ========
  if (!Get.isRegistered<AddRealEstateController>()) {
    Get.put(AddRealEstateController(
      instance<AddRealEstateUseCase>(),
      instance<GetListsUseCase>(),
      instance<GetPropertyOwnersUseCases>(),
    ));
  }
}

void disposeAddRealEstateModule() {
  final instance = GetIt.I;

  if (instance.isRegistered<GetListsDataSource>())
    instance.unregister<GetListsDataSource>();
  if (instance.isRegistered<GetListsRepository>())
    instance.unregister<GetListsRepository>();
  if (instance.isRegistered<GetListsUseCase>())
    instance.unregister<GetListsUseCase>();

  if (instance.isRegistered<AddRealEstateDataSource>())
    instance.unregister<AddRealEstateDataSource>();
  if (instance.isRegistered<AddRealEstateRepository>())
    instance.unregister<AddRealEstateRepository>();
  if (instance.isRegistered<AddRealEstateUseCase>())
    instance.unregister<AddRealEstateUseCase>();

  if (instance.isRegistered<GetPropertyOwnersDataSource>())
    instance.unregister<GetPropertyOwnersDataSource>();
  if (instance.isRegistered<GetPropertyOwnersRepository>())
    instance.unregister<GetPropertyOwnersRepository>();
  if (instance.isRegistered<GetPropertyOwnersUseCases>())
    instance.unregister<GetPropertyOwnersUseCases>();

  if (Get.isRegistered<AddRealEstateController>())
    Get.delete<AddRealEstateController>();
}
