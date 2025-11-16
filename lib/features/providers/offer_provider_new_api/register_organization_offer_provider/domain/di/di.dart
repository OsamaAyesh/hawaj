import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/get_organization_types_data_source.dart';
import '../../data/data_source/register_organization_offer_provider_data_source.dart';
import '../../data/repository/get_organization_types_repository.dart';
import '../../data/repository/register_organization_offer_provider_repository.dart';
import '../../presentation/controllers/register_organization_offer_provider_controller.dart';
import '../use_cases/get_organization_types_use_case.dart';
import '../use_cases/register_organization_offer_provider_use_cases.dart';

// ==================== Register Organization Offer Provider ====================

/// Initialize Register Organization DataSource
void _initRegisterOrganizationDataSource() {
  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderDataSource>()) {
    instance.registerLazySingleton<RegisterOrganizationOfferProviderDataSource>(
      () => RegisterOrganizationOfferProviderDataSourceImplement(
        instance<AppService>(),
      ),
    );
  }
}

/// Dispose Register Organization DataSource
void _disposeRegisterOrganizationDataSource() {
  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderDataSource>()) {
    instance.unregister<RegisterOrganizationOfferProviderDataSource>();
  }
}

/// Initialize Register Organization Repository
void _initRegisterOrganizationRepository() {
  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderRepository>()) {
    instance.registerLazySingleton<RegisterOrganizationOfferProviderRepository>(
      () => RegisterOrganizationOfferProviderRepositoryImplement(
        instance(),
        instance(),
      ),
    );
  }
}

/// Dispose Register Organization Repository
void _disposeRegisterOrganizationRepository() {
  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderRepository>()) {
    instance.unregister<RegisterOrganizationOfferProviderRepository>();
  }
}

/// Initialize Register Organization UseCase
void _initRegisterOrganizationUseCase() {
  if (!GetIt.I.isRegistered<RegisterOrganizationOfferProviderUseCases>()) {
    instance.registerFactory<RegisterOrganizationOfferProviderUseCases>(
      () => RegisterOrganizationOfferProviderUseCases(
        instance<RegisterOrganizationOfferProviderRepository>(),
      ),
    );
  }
}

/// Dispose Register Organization UseCase
void _disposeRegisterOrganizationUseCase() {
  if (GetIt.I.isRegistered<RegisterOrganizationOfferProviderUseCases>()) {
    instance.unregister<RegisterOrganizationOfferProviderUseCases>();
  }
}

// ==================== Get Organization Types ====================

/// Initialize Get Organization Types DataSource
void _initGetOrganizationTypesDataSource() {
  if (!GetIt.I.isRegistered<GetOrganizationTypesDataSource>()) {
    instance.registerLazySingleton<GetOrganizationTypesDataSource>(
      () => GetOrganizationTypesDataSourceImplement(
        instance<AppService>(),
      ),
    );
  }
}

/// Dispose Get Organization Types DataSource
void _disposeGetOrganizationTypesDataSource() {
  if (GetIt.I.isRegistered<GetOrganizationTypesDataSource>()) {
    instance.unregister<GetOrganizationTypesDataSource>();
  }
}

/// Initialize Get Organization Types Repository
void _initGetOrganizationTypesRepository() {
  if (!GetIt.I.isRegistered<GetOrganizationTypesRepository>()) {
    instance.registerLazySingleton<GetOrganizationTypesRepository>(
      () => GetOrganizationTypesRepositoryImplement(
        instance(),
        instance(),
      ),
    );
  }
}

/// Dispose Get Organization Types Repository
void _disposeGetOrganizationTypesRepository() {
  if (GetIt.I.isRegistered<GetOrganizationTypesRepository>()) {
    instance.unregister<GetOrganizationTypesRepository>();
  }
}

/// Initialize Get Organization Types UseCase
void _initGetOrganizationTypesUseCase() {
  if (!GetIt.I.isRegistered<GetOrganizationTypesUseCase>()) {
    instance.registerFactory<GetOrganizationTypesUseCase>(
      () => GetOrganizationTypesUseCase(
        instance<GetOrganizationTypesRepository>(),
      ),
    );
  }
}

/// Dispose Get Organization Types UseCase
void _disposeGetOrganizationTypesUseCase() {
  if (GetIt.I.isRegistered<GetOrganizationTypesUseCase>()) {
    instance.unregister<GetOrganizationTypesUseCase>();
  }
}

// ==================== Main Initialization ====================

/// Initialize complete Register Organization module with Controller
void initRegisterOrganizationOfferProvider() {
  // Initialize Register Organization dependencies
  _initRegisterOrganizationDataSource();
  _initRegisterOrganizationRepository();
  _initRegisterOrganizationUseCase();

  // Initialize Get Organization Types dependencies
  _initGetOrganizationTypesDataSource();
  _initGetOrganizationTypesRepository();
  _initGetOrganizationTypesUseCase();

  // Put Controller
  Get.put(
    RegisterOrganizationOfferProviderController(
      instance<RegisterOrganizationOfferProviderUseCases>(),
      instance<GetOrganizationTypesUseCase>(),
    ),
  );
}

/// Dispose complete Register Organization module with Controller
void disposeRegisterOrganizationOfferProvider() {
  // Delete Controller
  Get.delete<RegisterOrganizationOfferProviderController>();

  // Dispose Register Organization dependencies
  _disposeRegisterOrganizationUseCase();
  _disposeRegisterOrganizationRepository();
  _disposeRegisterOrganizationDataSource();

  // Dispose Get Organization Types dependencies
  _disposeGetOrganizationTypesUseCase();
  _disposeGetOrganizationTypesRepository();
  _disposeGetOrganizationTypesDataSource();
}
