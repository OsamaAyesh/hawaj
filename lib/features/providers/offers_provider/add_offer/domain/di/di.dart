import 'package:app_mobile/features/providers/offers_provider/add_offer/data/data_source/create_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/data_source/get_my_company_set_offer_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/repository/create_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/repository/get_my_company_set_offer_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/domain/use_case/create_offer_provider_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../offer_provider_new/common/domain/di/di.dart'
    show disposeGetMyCompanyNew, initGetMyCompanyNew;
import '../../../../offer_provider_new/common/domain/use_cases/get_my_company_use_case.dart';
import '../../../manage_list_offer/presentation/controller/manage_list_offer_provider_controller.dart';
import '../../presentation/controller/add_offer_controller.dart';
import '../use_case/get_my_company_set_offer_use_case.dart';

initCreateOfferProviderRequest() {
  if (!GetIt.I.isRegistered<CreateOfferProviderDataSource>()) {
    instance.registerLazySingleton<CreateOfferProviderDataSource>(
        () => CreateOfferProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<CreateOfferProviderRepository>()) {
    instance.registerLazySingleton<CreateOfferProviderRepository>(
        () => CreateOfferProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<CreateOfferProviderUseCase>()) {
    instance.registerFactory<CreateOfferProviderUseCase>(() =>
        CreateOfferProviderUseCase(instance<CreateOfferProviderRepository>()));
  }
}

disposeCreateOfferProviderRequest() {
  if (GetIt.I.isRegistered<CreateOfferProviderDataSource>()) {
    instance.unregister<CreateOfferProviderDataSource>();
  }

  if (GetIt.I.isRegistered<CreateOfferProviderRepository>()) {
    instance.unregister<CreateOfferProviderRepository>();
  }

  if (GetIt.I.isRegistered<CreateOfferProviderUseCase>()) {
    instance.unregister<CreateOfferProviderUseCase>();
  }
}

void initCreateOfferProvider() {
  initCreateOfferProviderRequest();
  initGetMyCompanyNew();
  // initGetMyCompanySetOfferRequest();
  Get.put(AddOfferController(
    instance<CreateOfferProviderUseCase>(),
    instance<GetMyCompanyUseCase>(),
  ));
}

void disposeCreateOfferProvider() {
  disposeCreateOfferProviderRequest();
  disposeGetMyCompanyNew();
  // disposeGetMyCompanySetOfferRequest();
  Get.delete<AddOfferController>();
}

initGetMyCompanySetOfferRequest() {
  if (!GetIt.I.isRegistered<GetMyCompanySetOfferDataSource>()) {
    instance.registerLazySingleton<GetMyCompanySetOfferDataSource>(
        () => GetMyCompanySetOfferDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanySetOfferRepository>()) {
    instance.registerLazySingleton<GetMyCompanySetOfferRepository>(
        () => GetMyCompanySetOfferRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyCompanySetOfferUseCase>()) {
    instance.registerFactory<GetMyCompanySetOfferUseCase>(() =>
        GetMyCompanySetOfferUseCase(
            instance<GetMyCompanySetOfferRepository>()));
  }
}

disposeGetMyCompanySetOfferRequest() {
  if (GetIt.I.isRegistered<GetMyCompanySetOfferDataSource>()) {
    instance.unregister<GetMyCompanySetOfferDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyCompanySetOfferRepository>()) {
    instance.unregister<GetMyCompanySetOfferRepository>();
  }

  if (GetIt.I.isRegistered<GetMyCompanySetOfferUseCase>()) {
    instance.unregister<GetMyCompanySetOfferUseCase>();
  }
}

void initGetMyCompany() {
  initGetMyCompanySetOfferRequest();
  Get.put(ManageListOfferProviderController(
    instance<GetMyCompanySetOfferUseCase>(),
  ));
}

void disposeGetMyCompany() {
  disposeGetMyCompanySetOfferRequest();
  Get.delete<ManageListOfferProviderController>();
}
