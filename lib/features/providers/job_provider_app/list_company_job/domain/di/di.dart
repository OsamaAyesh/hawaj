import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/data_source/add_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/repository/add_company_jobs_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/domain/use_cases/add_company_jobs_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';

final instance = GetIt.instance;

initGetListCompanyJobsRequest() {
  if (!GetIt.I.isRegistered<AddCompanyJobsDataSource>()) {
    instance.registerLazySingleton<AddCompanyJobsDataSource>(
        () => AddCompanyJobsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddCompanyJobsRepository>()) {
    instance.registerLazySingleton<AddCompanyJobsRepository>(
        () => AddCompanyJobsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddCompanyJobsUseCase>()) {
    instance.registerFactory<AddCompanyJobsUseCase>(
        () => AddCompanyJobsUseCase(instance<AddCompanyJobsRepository>()));
  }
}

disposeGetListCompanyJobsRequest() {
  if (GetIt.I.isRegistered<AddCompanyJobsDataSource>()) {
    instance.unregister<AddCompanyJobsDataSource>();
  }

  if (GetIt.I.isRegistered<AddCompanyJobsRepository>()) {
    instance.unregister<AddCompanyJobsRepository>();
  }

  if (GetIt.I.isRegistered<AddCompanyJobsUseCase>()) {
    instance.unregister<AddCompanyJobsUseCase>();
  }
}

void initGetListCompanyJobs() {
  initGetListCompanyJobsRequest();
  // Get.put(AddCompanyJobsController(
  //   instance<AddCompanyJobsUseCase>(),
  // ));
}

void disposeGetListCompanyJobs() {
  disposeGetListCompanyJobsRequest();
  // Get.delete<AddCompanyJobsController>();
}
