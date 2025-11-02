import 'package:app_mobile/features/providers/job_provider_app/get_applications_job/domain/use_cases/get_job_applications_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';
import '../../data/data_source/get_job_applications_data_source.dart';
import '../../data/repository/get_job_applications_repository.dart';
import '../../presentation/controller/get_applications_job_controller.dart';

final instance = GetIt.instance;

initGetJobApplicationsRequest() {
  if (!GetIt.I.isRegistered<GetJobApplicationsDataSource>()) {
    instance.registerLazySingleton<GetJobApplicationsDataSource>(
        () => GetJobApplicationsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetJobApplicationsRepository>()) {
    instance.registerLazySingleton<GetJobApplicationsRepository>(
        () => GetJobApplicationsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetJobApplicationsUseCase>()) {
    instance.registerFactory<GetJobApplicationsUseCase>(() =>
        GetJobApplicationsUseCase(instance<GetJobApplicationsRepository>()));
  }
}

disposeGetJobApplicationsRequest() {
  if (GetIt.I.isRegistered<GetJobApplicationsDataSource>()) {
    instance.unregister<GetJobApplicationsDataSource>();
  }

  if (GetIt.I.isRegistered<GetJobApplicationsRepository>()) {
    instance.unregister<GetJobApplicationsRepository>();
  }

  if (GetIt.I.isRegistered<GetJobApplicationsUseCase>()) {
    instance.unregister<GetJobApplicationsUseCase>();
  }
}

void initGetJobApplications() {
  initGetJobApplicationsRequest();
  Get.put(GetJobApplicationsController(
    instance<GetJobApplicationsUseCase>(),
  ));
}

void disposeGetJobApplications() {
  disposeGetJobApplicationsRequest();
  Get.delete<GetJobApplicationsController>();
}
