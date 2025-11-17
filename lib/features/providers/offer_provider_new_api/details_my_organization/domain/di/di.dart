import 'package:app_mobile/features/providers/offer_provider_new_api/details_my_organization/data/repository/get_my_organization_details_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart' show AppService;
import '../../data/data_source/get_my_organization_details_data_source.dart';
import '../../presentation/controller/details_my_organization_controller.dart';
import '../use_cases/get_my_organization_details_use_case.dart'
    show GetMyOrganizationDetailsUseCase;

initGetMyOrganizationDetailsRequest() {
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

disposeGetMyOrganizationDetailsRequest() {
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

void initGetMyOrganizationDetails() {
  initGetMyOrganizationDetailsRequest();
  Get.put(DetailsMyOrganizationController(
    instance<GetMyOrganizationDetailsUseCase>(),
  ));
}

void disposeGetMyOrganizationDetails() {
  disposeGetMyOrganizationDetailsRequest();
  Get.delete<DetailsMyOrganizationController>();
}
