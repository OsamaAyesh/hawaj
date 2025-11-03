import 'package:app_mobile/features/providers/offer_provider_new/common/data/data_source/get_my_company_data_source.dart';
import 'package:app_mobile/features/providers/offer_provider_new/common/data/repository/get_my_company_repository.dart';
import 'package:app_mobile/features/providers/offer_provider_new/common/domain/use_cases/get_my_company_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';

final instance = GetIt.instance;

initGetMyCompanyRequest() {
  if (!GetIt.I.isRegistered<GetMyCompanyDataSource>()) {
    instance.registerLazySingleton<GetMyCompanyDataSource>(() =>
        GetMyCompanyDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanyRepository>()) {
    instance.registerLazySingleton<GetMyCompanyRepository>(() =>
        GetMyCompanyRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanyUseCase>()) {
    instance.registerFactory<GetMyCompanyUseCase>(() =>
        GetMyCompanyUseCase(
            instance<GetMyCompanyRepository>()));
  }
}

disposeGetMyCompanyRequest() {
  if (GetIt.I.isRegistered<GetMyCompanyDataSource>()) {
    instance.unregister<GetMyCompanyDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyCompanyRepository>()) {
    instance.unregister<GetMyCompanyRepository>();
  }

  if (GetIt.I.isRegistered<GetMyCompanyUseCase>()) {
    instance.unregister<GetMyCompanyUseCase>();
  }
}

void initGetMyCompany() {
  initGetMyCompanyRequest();
  // Get.put(EditCompanyJobProviderController(
  //   instance<EditCompanyJobsProviderUseCase>(),
  // ));
}

void disposeGetMyCompany() {
  disposeGetMyCompanyRequest();
  // Get.delete<EditCompanyJobProviderController>();
}
