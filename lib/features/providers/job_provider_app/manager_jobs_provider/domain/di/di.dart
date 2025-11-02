import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/data_source/get_list_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/repository/get_list_jobs_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/use_cases/get_list_jobs_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/get_list_jobs_controller.dart';

final instance = GetIt.instance;

initGetListJobsRequest() {
  if (!GetIt.I.isRegistered<GetListJobsDataSource>()) {
    instance.registerLazySingleton<GetListJobsDataSource>(
        () => GetListJobsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetListJobsRepository>()) {
    instance.registerLazySingleton<GetListJobsRepository>(
        () => GetListJobsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetListJobsUseCase>()) {
    instance.registerFactory<GetListJobsUseCase>(
        () => GetListJobsUseCase(instance<GetListJobsRepository>()));
  }
}

disposeGetListJobsRequest() {
  if (GetIt.I.isRegistered<GetListJobsDataSource>()) {
    instance.unregister<GetListJobsDataSource>();
  }

  if (GetIt.I.isRegistered<GetListJobsRepository>()) {
    instance.unregister<GetListJobsRepository>();
  }

  if (GetIt.I.isRegistered<GetListJobsUseCase>()) {
    instance.unregister<GetListJobsUseCase>();
  }
}

void initGetListJobs() {
  initGetListJobsRequest();
  Get.put(ManagerJobsController(
    instance<GetListJobsUseCase>(),
  ));
}

void disposeGetListJobs() {
  disposeGetListJobsRequest();
  Get.delete<ManagerJobsController>();
}
