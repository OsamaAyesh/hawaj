import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
// ===== Data & Domain =====
import '../../../../../common/lists/data/data_source/get_lists_data_source.dart';
import '../../../../../common/lists/data/repository/get_lists_repository.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
import '../../data/data_source/add_real_estate_data_source.dart';
import '../../data/repository/add_real_estate_repository.dart';
import '../../domain/use_cases/add_real_estate_use_case.dart';
// ===== Controller =====
import '../../presentation/controller/add_real_estate_controller.dart';

void initAddRealEstateModule() {
  final instance = GetIt.I;

  // ===== Get Lists =====
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

  // ===== Add Real Estate =====
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

  // ===== Controller =====
  if (!Get.isRegistered<AddRealEstateController>()) {
    Get.put(AddRealEstateController(
      instance<AddRealEstateUseCase>(),
      instance<GetListsUseCase>(),
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

  if (Get.isRegistered<AddRealEstateController>())
    Get.delete<AddRealEstateController>();
}
