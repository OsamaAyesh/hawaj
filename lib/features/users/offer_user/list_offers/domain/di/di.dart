import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/get_organizations_data_source.dart';
import '../../data/repository/get_organizations_repository.dart';
import '../../presentation/controller/get_organizations_controller.dart';
import '../use_cases/get_organizations_use_case.dart';

initGetOrganizationsRequest() {
  if (!GetIt.I.isRegistered<GetOrganizationsDataSource>()) {
    instance.registerLazySingleton<GetOrganizationsDataSource>(
        () => GetOrganizationsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetOrganizationsRepository>()) {
    instance.registerLazySingleton<GetOrganizationsRepository>(
        () => GetOrganizationsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetOrganizationsUseCase>()) {
    instance.registerFactory<GetOrganizationsUseCase>(
        () => GetOrganizationsUseCase(instance<GetOrganizationsRepository>()));
  }
}

disposeGetOrganizationsRequest() {
  if (GetIt.I.isRegistered<GetOrganizationsDataSource>()) {
    instance.unregister<GetOrganizationsDataSource>();
  }

  if (GetIt.I.isRegistered<GetOrganizationsRepository>()) {
    instance.unregister<GetOrganizationsRepository>();
  }

  if (GetIt.I.isRegistered<GetOrganizationsUseCase>()) {
    instance.unregister<GetOrganizationsUseCase>();
  }
}

void initGetOrganizationsProvider() {
  initGetOrganizationsRequest();
  Get.put(OffersController(
    instance<GetOrganizationsUseCase>(),
  ));
}

void disposeGetOrganizations() {
  disposeGetOrganizationsRequest();
  Get.delete<OffersController>();
}
