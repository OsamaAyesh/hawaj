import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/data_source/register_my_company_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/repository/register_my_company_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/domain/use_case/register_my_company_offer_provider_use_case.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/presentation/controller/register_my_company_offer_provider_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';

initRegisterMyCompanyOfferProviderRequest() {
  if (!GetIt.I.isRegistered<RegisterMyCompanyOfferProviderDataSource>()) {
    instance.registerLazySingleton<RegisterMyCompanyOfferProviderDataSource>(
            () => RegisterMyCompanyOfferProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<RegisterMyCompanyOfferProviderRepository>()) {
    instance.registerLazySingleton<RegisterMyCompanyOfferProviderRepository>(
            () => RegisterMyCompanyOfferProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<RegisterMyCompanyOfferProviderUseCase>()) {
    instance.registerFactory<RegisterMyCompanyOfferProviderUseCase>(
            () => RegisterMyCompanyOfferProviderUseCase(instance<RegisterMyCompanyOfferProviderRepository>()));
  }
}

disposeRegisterMyCompanyOfferProviderRequest() {
  if (GetIt.I.isRegistered<RegisterMyCompanyOfferProviderDataSource>()) {
    instance.unregister<RegisterMyCompanyOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<RegisterMyCompanyOfferProviderRepository>()) {
    instance.unregister<RegisterMyCompanyOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<RegisterMyCompanyOfferProviderUseCase>()) {
    instance.unregister<RegisterMyCompanyOfferProviderUseCase>();
  }
}

void initRegisterMyCompanyOfferProvider() {
  initRegisterMyCompanyOfferProviderRequest();
  Get.put(RegisterMyCompanyOfferProviderController(
    instance<RegisterMyCompanyOfferProviderUseCase>(),
  ));
}

void disposeRegisterMyCompanyOfferProvider() {
  disposeRegisterMyCompanyOfferProviderRequest();
  Get.delete<RegisterMyCompanyOfferProviderController>();
}