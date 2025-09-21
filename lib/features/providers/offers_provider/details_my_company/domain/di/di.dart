import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/data_source/get_my_company_details_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/repository/get_my_company_details_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/use_cases/get_my_company_details_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initGetMyCompanyDetailsRequest() {
  if (!GetIt.I.isRegistered<GetMyCompanyDetailsDataSource>()) {
    instance.registerLazySingleton<GetMyCompanyDetailsDataSource>(
        () => GetMyCompanyDetailsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanyDetailsRepository>()) {
    instance.registerLazySingleton<GetMyCompanyDetailsRepository>(
        () => GetMyCompanyDetailsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanyDetailsUseCase>()) {
    instance.registerFactory<GetMyCompanyDetailsUseCase>(() =>
        GetMyCompanyDetailsUseCase(instance<GetMyCompanyDetailsRepository>()));
  }
}

disposeGetMyCompanyDetailsRequest() {
  if (GetIt.I.isRegistered<GetMyCompanyDetailsDataSource>()) {
    instance.unregister<GetMyCompanyDetailsDataSource>();
  }
  if (GetIt.I.isRegistered<GetMyCompanyDetailsRepository>()) {
    instance.unregister<GetMyCompanyDetailsRepository>();
  }

  if (GetIt.I.isRegistered<GetMyCompanyDetailsUseCase>()) {
    instance.unregister<GetMyCompanyDetailsUseCase>();
  }
}
// void initCreateOfferProvider() {
//   initCreateOfferProviderRequest();
//   initGetMyCompanySetOfferRequest();
//   Get.put(AddOfferController(
//     instance<CreateOfferProviderUseCase>(),
//     instance<GetMyCompanySetOfferUseCase>(),
//   ));
// }
//
// void disposeCreateOfferProvider() {
//   disposeCreateOfferProviderRequest();
//   disposeGetMyCompanySetOfferRequest();
//   Get.delete<AddOfferController>();
// }
