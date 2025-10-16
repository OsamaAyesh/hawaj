import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/add_my_property_owners_data_source.dart';
import '../../data/repository/add_my_property_owners_repository.dart';
import '../../presentation/controller/add_my_property_owners_controller.dart';
import '../use_cases/add_my_property_owners_usecase.dart';

final instance = GetIt.instance;

initAddMyPropertyOwnersRequest() {
  if (!GetIt.I.isRegistered<AddMyPropertyOwnersDataSource>()) {
    instance.registerLazySingleton<AddMyPropertyOwnersDataSource>(
        () => AddMyPropertyOwnersDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddMyPropertyOwnersRepository>()) {
    instance.registerLazySingleton<AddMyPropertyOwnersRepository>(
        () => AddMyPropertyOwnersRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddMyPropertyOwnersUseCase>()) {
    instance.registerFactory<AddMyPropertyOwnersUseCase>(() =>
        AddMyPropertyOwnersUseCase(instance<AddMyPropertyOwnersRepository>()));
  }
}

disposeAddMyPropertyOwnersRequest() {
  if (GetIt.I.isRegistered<AddMyPropertyOwnersDataSource>()) {
    instance.unregister<AddMyPropertyOwnersDataSource>();
  }

  if (GetIt.I.isRegistered<AddMyPropertyOwnersRepository>()) {
    instance.unregister<AddMyPropertyOwnersRepository>();
  }

  if (GetIt.I.isRegistered<AddMyPropertyOwnersUseCase>()) {
    instance.unregister<AddMyPropertyOwnersUseCase>();
  }
}

void initAddMyPropertyOwners() {
  initAddMyPropertyOwnersRequest();
  Get.put(AddMyPropertyOwnersController(
    instance<AddMyPropertyOwnersUseCase>(),
  ));
}

void disposeAddMyPropertyOwners() {
  disposeAddMyPropertyOwnersRequest();
  Get.delete<AddMyPropertyOwnersController>();
}
