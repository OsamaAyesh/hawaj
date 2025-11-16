import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/get_organization_types_data_source.dart';
import '../../data/data_source/register_organization_offer_provider_data_source.dart';
import '../../data/repository/get_organization_types_repository.dart';
import '../../data/repository/register_organization_offer_provider_repository.dart';
import '../use_cases/get_organization_types_use_case.dart';
import '../use_cases/register_organization_offer_provider_use_cases.dart';

initRegisterOrganizationOfferProviderRequest() {
  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderDataSource>()) {
    instance.registerLazySingleton<RegisterOrganizationOfferProviderDataSource>(
        () => RegisterOrganizationOfferProviderDataSourceImplement(
            instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderRepository>()) {
    instance.registerLazySingleton<RegisterOrganizationOfferProviderRepository>(
        () => RegisterOrganizationOfferProviderRepositoryImplement(
            instance(), instance()));
  }

  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderUseCases>()) {
    instance.registerFactory<RegisterOrganizationOfferProviderUseCases>(() =>
        RegisterOrganizationOfferProviderUseCases(
            instance<RegisterOrganizationOfferProviderRepository>()));
  }
}

disposeRegisterOrganizationOfferProviderRequest() {
  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderDataSource>()) {
    instance.unregister<RegisterOrganizationOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderRepository>()) {
    instance.unregister<RegisterOrganizationOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderUseCases>()) {
    instance.unregister<RegisterOrganizationOfferProviderUseCases>();
  }
}

void initRegisterOrganizationOfferProvider() {
  initRegisterOrganizationOfferProviderRequest();
  // Get.put(AddOfferNewController(
  //   instance<AddOfferNewUseCase>(),
  //   instance<GetMyCompanyUseCase>(),
  // ));
}

void disposeRegisterOrganizationOfferProvider() {
  disposeRegisterOrganizationOfferProviderRequest();
  // Get.delete<AddOfferNewController>();
}

initGetOrganizationTypesRequest() {
  if (!GetIt.I.isRegistered<GetOrganizationTypesDataSource>()) {
    instance.registerLazySingleton<GetOrganizationTypesDataSource>(
        () => GetOrganizationTypesDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetOrganizationTypesRepository>()) {
    instance.registerLazySingleton<GetOrganizationTypesRepository>(
        () => GetOrganizationTypesRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetOrganizationTypesUseCase>()) {
    instance.registerFactory<GetOrganizationTypesUseCase>(() =>
        GetOrganizationTypesUseCase(
            instance<GetOrganizationTypesRepository>()));
  }
}

disposeGetOrganizationTypesRequest() {
  if (GetIt.I.isRegistered<GetOrganizationTypesDataSource>()) {
    instance.unregister<GetOrganizationTypesDataSource>();
  }

  if (GetIt.I.isRegistered<GetOrganizationTypesRepository>()) {
    instance.unregister<GetOrganizationTypesRepository>();
  }

  if (GetIt.I.isRegistered<GetOrganizationTypesUseCase>()) {
    instance.unregister<GetOrganizationTypesUseCase>();
  }
}

void initGetOrganizationTypes() {
  initGetOrganizationTypesRequest();
  // Get.put(AddOfferNewController(
  //   instance<AddOfferNewUseCase>(),
  //   instance<GetMyCompanyUseCase>(),
  // ));
}

void disposeGetOrganizationTypes() {
  disposeGetOrganizationTypesRequest();
  // Get.delete<AddOfferNewController>();
}
