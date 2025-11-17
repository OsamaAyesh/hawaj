// في ملف: details_my_organization/domain/di/di.dart

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart' show AppService;
// Get Organization Details
import '../../data/data_source/delete_offer_data_source.dart';
import '../../data/data_source/get_my_organization_details_data_source.dart';
import '../../data/repository/delete_offer_repository.dart';
import '../../data/repository/get_my_organization_details_repository.dart';
import '../../presentation/controller/details_my_organization_controller.dart';
import '../use_cases/delete_offer_use_case.dart';
import '../use_cases/get_my_organization_details_use_case.dart';

// ==================== Get Organization Details ====================
void initGetMyOrganizationDetailsRequest() {
  if (!GetIt.I.isRegistered<GetMyOrganizationDetailsDataSource>()) {
    instance.registerLazySingleton<GetMyOrganizationDetailsDataSource>(() =>
        GetMyOrganizationDetailsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationDetailsRepository>()) {
    instance.registerLazySingleton<GetMyOrganizationDetailsRepository>(() =>
        GetMyOrganizationDetailsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyOrganizationDetailsUseCase>()) {
    instance.registerFactory<GetMyOrganizationDetailsUseCase>(() =>
        GetMyOrganizationDetailsUseCase(
            instance<GetMyOrganizationDetailsRepository>()));
  }
}

void disposeGetMyOrganizationDetailsRequest() {
  if (GetIt.I.isRegistered<GetMyOrganizationDetailsDataSource>()) {
    instance.unregister<GetMyOrganizationDetailsDataSource>();
  }
  if (GetIt.I.isRegistered<GetMyOrganizationDetailsRepository>()) {
    instance.unregister<GetMyOrganizationDetailsRepository>();
  }
  if (GetIt.I.isRegistered<GetMyOrganizationDetailsUseCase>()) {
    instance.unregister<GetMyOrganizationDetailsUseCase>();
  }
}

// ==================== Delete Offer ====================
void initDeleteOfferRequest() {
  if (!GetIt.I.isRegistered<DeleteOfferDataSource>()) {
    instance.registerLazySingleton<DeleteOfferDataSource>(
        () => DeleteOfferDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<DeleteOfferRepository>()) {
    instance.registerLazySingleton<DeleteOfferRepository>(
        () => DeleteOfferRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<DeleteOfferUseCase>()) {
    instance.registerFactory<DeleteOfferUseCase>(
        () => DeleteOfferUseCase(instance<DeleteOfferRepository>()));
  }
}

void disposeDeleteOfferRequest() {
  if (GetIt.I.isRegistered<DeleteOfferDataSource>()) {
    instance.unregister<DeleteOfferDataSource>();
  }
  if (GetIt.I.isRegistered<DeleteOfferRepository>()) {
    instance.unregister<DeleteOfferRepository>();
  }
  if (GetIt.I.isRegistered<DeleteOfferUseCase>()) {
    instance.unregister<DeleteOfferUseCase>();
  }
}

// ==================== Main Init & Dispose ====================
void initGetMyOrganizationDetails() {
  initGetMyOrganizationDetailsRequest();
  initDeleteOfferRequest();

  Get.put(DetailsMyOrganizationController(
    instance<GetMyOrganizationDetailsUseCase>(),
    instance<DeleteOfferUseCase>(),
  ));
}

void disposeGetMyOrganizationDetails() {
  Get.delete<DetailsMyOrganizationController>();

  disposeGetMyOrganizationDetailsRequest();
  disposeDeleteOfferRequest();
}
