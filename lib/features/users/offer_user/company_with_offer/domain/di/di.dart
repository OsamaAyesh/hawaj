import 'package:app_mobile/features/users/offer_user/company_with_offer/data/data_source/get_company_data_source.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/repository/get_company_repository.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/use_case/get_company_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initGetCompanyRequest() {
  if (!GetIt.I.isRegistered<GetCompanyDataSource>()) {
    instance.registerLazySingleton<GetCompanyDataSource>(
            () => GetCompanyDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetCompanyRepository>()) {
    instance.registerLazySingleton<GetCompanyRepository>(
            () => GetCompanyRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetCompanyUseCase>()) {
    instance.registerFactory<GetCompanyUseCase>(
            () => GetCompanyUseCase(instance<GetCompanyRepository>()));
  }
}

disposeGetCompanyRequest() {
  if (GetIt.I.isRegistered<GetCompanyDataSource>()) {
    instance.unregister<GetCompanyDataSource>();
  }

  if (GetIt.I.isRegistered<GetCompanyRepository>()) {
    instance.unregister<GetCompanyRepository>();
  }

  if (GetIt.I.isRegistered<GetCompanyUseCase>()) {
    instance.unregister<GetCompanyUseCase>();
  }
}

void initGetCompany() {
  initGetCompanyRequest();
  // Get.put(CreateOfferProviderController(
  //   instance<CreateOfferProviderUseCase>(),
  // ));
}

void disposeGetCompany() {
  disposeGetCompanyRequest();
  // Get.delete<CreateOfferProviderController>();
}