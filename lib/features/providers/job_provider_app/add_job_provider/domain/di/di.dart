import 'package:app_mobile/core/network/app_api.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/data_source/add_job_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/data_source/job_settings_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/repository/add_job_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/repository/job_settings_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/add_job_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/job_settings_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/data_source/get_list_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/repository/get_list_company_jobs_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/use_cases/get_list_company_jobs_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../presentation/controller/add_job_provider_controller.dart';

final instance = GetIt.instance;

/// 🔹 إعداد طلبات إعدادات الوظائف
initJobSettingsRequest() {
  if (!instance.isRegistered<JobSettingsDataSource>()) {
    instance.registerLazySingleton<JobSettingsDataSource>(
        () => JobSettingsDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<JobSettingsRepository>()) {
    instance.registerLazySingleton<JobSettingsRepository>(
        () => JobSettingsRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<JobSettingsUseCase>()) {
    instance.registerFactory<JobSettingsUseCase>(
        () => JobSettingsUseCase(instance<JobSettingsRepository>()));
  }
}

/// 🔹 إعداد طلبات إضافة وظيفة
initAddJobRequest() {
  if (!instance.isRegistered<AddJobDataSource>()) {
    instance.registerLazySingleton<AddJobDataSource>(
        () => AddJobDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<AddJobRepository>()) {
    instance.registerLazySingleton<AddJobRepository>(
        () => AddJobRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<AddJobUseCase>()) {
    instance.registerFactory<AddJobUseCase>(
        () => AddJobUseCase(instance<AddJobRepository>()));
  }
}

/// 🔹 إعداد قائمة الشركات (للاختيار)
initGetListCompanyJobsRequest() {
  if (!instance.isRegistered<GetListCompanyJobsDataSource>()) {
    instance.registerLazySingleton<GetListCompanyJobsDataSource>(
        () => GetListCompanyJobsDataSourceImplement(instance<AppService>()));
  }

  if (!instance.isRegistered<GetListCompanyJobsRepository>()) {
    instance.registerLazySingleton<GetListCompanyJobsRepository>(
        () => GetListCompanyJobsRepositoryImplement(instance(), instance()));
  }

  if (!instance.isRegistered<GetListCompanyJobsUseCase>()) {
    instance.registerFactory<GetListCompanyJobsUseCase>(() =>
        GetListCompanyJobsUseCase(instance<GetListCompanyJobsRepository>()));
  }
}

/// 🔹 تهيئة كل ما يلزم لشاشة إضافة وظيفة
void initAddJobsModule() {
  initAddJobRequest();
  initJobSettingsRequest();
  initGetListCompanyJobsRequest();

  Get.put(AddJobsController(
    instance<AddJobUseCase>(),
    instance<JobSettingsUseCase>(),
    instance<GetListCompanyJobsUseCase>(),
  ));
}

/// 🔹 تفريغ الموارد بعد الخروج
void disposeAddJobsModule() {
  if (Get.isRegistered<AddJobsController>()) Get.delete<AddJobsController>();
}
