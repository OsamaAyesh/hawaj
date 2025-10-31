import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/data_source/get_list_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/repository/get_list_company_jobs_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/list_company_jobs_controller.dart';
import '../use_cases/get_list_company_jobs_use_case.dart';

final instance = GetIt.instance;

initGetListCompanyJobsRequest() {
  if (!GetIt.I.isRegistered<GetListCompanyJobsDataSource>()) {
    instance.registerLazySingleton<GetListCompanyJobsDataSource>(
        () => GetListCompanyJobsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetListCompanyJobsRepository>()) {
    instance.registerLazySingleton<GetListCompanyJobsRepository>(
        () => GetListCompanyJobsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetListCompanyJobsUseCase>()) {
    instance.registerFactory<GetListCompanyJobsUseCase>(() =>
        GetListCompanyJobsUseCase(instance<GetListCompanyJobsRepository>()));
  }
}

disposeGetListCompanyJobsRequest() {
  if (GetIt.I.isRegistered<GetListCompanyJobsDataSource>()) {
    instance.unregister<GetListCompanyJobsDataSource>();
  }

  if (GetIt.I.isRegistered<GetListCompanyJobsRepository>()) {
    instance.unregister<GetListCompanyJobsRepository>();
  }

  if (GetIt.I.isRegistered<GetListCompanyJobsUseCase>()) {
    instance.unregister<GetListCompanyJobsUseCase>();
  }
}

void initGetListCompanyJobs() {
  initGetListCompanyJobsRequest();
  Get.put(GetListCompanyJobsController(
    instance<GetListCompanyJobsUseCase>(),
  ));
}

void disposeGetListCompanyJobs() {
  disposeGetListCompanyJobsRequest();
  Get.delete<GetListCompanyJobsController>();
}
