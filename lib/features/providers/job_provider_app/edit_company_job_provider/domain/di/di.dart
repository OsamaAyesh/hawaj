import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/data_source/edit_company_jobs_provider_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/repository/edit_company_jobs_provider_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/domain/use_cases/edit_company_jobs_provider_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/edit_company_job_provider_controller.dart';

final instance = GetIt.instance;

initEditCompanyJobsProviderRequest() {
  if (!GetIt.I.isRegistered<EditCompanyJobsProviderDataSource>()) {
    instance.registerLazySingleton<EditCompanyJobsProviderDataSource>(() =>
        EditCompanyJobsProviderDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<EditCompanyJobsProviderRepository>()) {
    instance.registerLazySingleton<EditCompanyJobsProviderRepository>(() =>
        EditCompanyJobsProviderRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<EditCompanyJobsProviderUseCase>()) {
    instance.registerFactory<EditCompanyJobsProviderUseCase>(() =>
        EditCompanyJobsProviderUseCase(
            instance<EditCompanyJobsProviderRepository>()));
  }
}

disposeEditCompanyJobsProviderRequest() {
  if (GetIt.I.isRegistered<EditCompanyJobsProviderDataSource>()) {
    instance.unregister<EditCompanyJobsProviderDataSource>();
  }

  if (GetIt.I.isRegistered<EditCompanyJobsProviderRepository>()) {
    instance.unregister<EditCompanyJobsProviderRepository>();
  }

  if (GetIt.I.isRegistered<EditCompanyJobsProviderUseCase>()) {
    instance.unregister<EditCompanyJobsProviderUseCase>();
  }
}

void initEditCompanyJobsProvider() {
  initEditCompanyJobsProviderRequest();
  Get.put(EditCompanyJobProviderController(
    instance<EditCompanyJobsProviderUseCase>(),
  ));
}

void disposeEditCompanyJobsProvider() {
  disposeEditCompanyJobsProviderRequest();
  Get.delete<EditCompanyJobProviderController>();
}
