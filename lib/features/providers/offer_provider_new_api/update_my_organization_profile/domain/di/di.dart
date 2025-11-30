import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../register_organization_offer_provider/data/data_source/get_organization_types_data_source.dart';
import '../../../register_organization_offer_provider/data/repository/get_organization_types_repository.dart';
import '../../../register_organization_offer_provider/domain/use_cases/get_organization_types_use_case.dart';
import '../../data/data_source/update_organization_offer_provider_data_source.dart';
import '../../data/repository/update_organization_offer_provider_repository.dart';
import '../../presentation/controller/update_organization_offer_provider_controller.dart';
import '../use_cases/update_organization_offer_provider_use_case.dart';

// ==================== Update Organization Offer Provider ====================

/// Initialize Update Organization DataSource
void _initUpdateOrganizationDataSource() {
  if (!GetIt.I.isRegistered<UpdateOrganizationOfferProviderDataSource>()) {
    instance.registerLazySingleton<UpdateOrganizationOfferProviderDataSource>(
      () => UpdateOrganizationOfferProviderDataSourceImplement(
        instance<AppService>(),
      ),
    );
  }
}

/// Dispose Update Organization DataSource
void _disposeUpdateOrganizationDataSource() {
  if (GetIt.I.isRegistered<UpdateOrganizationOfferProviderDataSource>()) {
    instance.unregister<UpdateOrganizationOfferProviderDataSource>();
  }
}

/// Initialize Update Organization Repository
void _initUpdateOrganizationRepository() {
  if (!GetIt.I.isRegistered<UpdateOrganizationOfferProviderRepository>()) {
    instance.registerLazySingleton<UpdateOrganizationOfferProviderRepository>(
      () => UpdateOrganizationOfferProviderRepositoryImplement(
        instance(),
        instance(),
      ),
    );
  }
}

/// Dispose Update Organization Repository
void _disposeUpdateOrganizationRepository() {
  if (GetIt.I.isRegistered<UpdateOrganizationOfferProviderRepository>()) {
    instance.unregister<UpdateOrganizationOfferProviderRepository>();
  }
}

/// Initialize Update Organization UseCase
void _initUpdateOrganizationUseCase() {
  if (!GetIt.I.isRegistered<UpdateOrganizationOfferProviderUseCase>()) {
    instance.registerFactory<UpdateOrganizationOfferProviderUseCase>(
      () => UpdateOrganizationOfferProviderUseCase(
        instance<UpdateOrganizationOfferProviderRepository>(),
      ),
    );
  }
}

/// Dispose Update Organization UseCase
void _disposeUpdateOrganizationUseCase() {
  if (GetIt.I.isRegistered<UpdateOrganizationOfferProviderUseCase>()) {
    instance.unregister<UpdateOrganizationOfferProviderUseCase>();
  }
}

// ==================== Get Organization Types (مشترك) ====================

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

/// Initialize complete Update Organization module with Controller
void initUpdateOrganizationOfferProvider(
    GetOrganizationItemWithOfferModel organizationData) {
  // Initialize Update Organization dependencies
  _initUpdateOrganizationDataSource();
  _initUpdateOrganizationRepository();
  _initUpdateOrganizationUseCase();

  // Initialize Get Organization Types dependencies (مشترك)
  _initGetOrganizationTypesDataSource();
  _initGetOrganizationTypesRepository();
  _initGetOrganizationTypesUseCase();

  // Put Controller with organization data
  Get.put(
    UpdateOrganizationOfferProviderController(
      instance<UpdateOrganizationOfferProviderUseCase>(),
      instance<GetOrganizationTypesUseCase>(),
      organizationData, // ✅ تمرير البيانات للـ Controller
    ),
  );
}

/// Dispose complete Update Organization module with Controller
void disposeUpdateOrganizationOfferProvider() {
  // Delete Controller
  Get.delete<UpdateOrganizationOfferProviderController>();

  // Dispose Update Organization dependencies
  _disposeUpdateOrganizationUseCase();
  _disposeUpdateOrganizationRepository();
  _disposeUpdateOrganizationDataSource();

  // Dispose Get Organization Types dependencies
  _disposeGetOrganizationTypesUseCase();
  _disposeGetOrganizationTypesRepository();
  _disposeGetOrganizationTypesDataSource();
}
