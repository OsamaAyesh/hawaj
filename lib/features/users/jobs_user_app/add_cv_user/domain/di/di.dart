import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/data_source/add_cv_data_source.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/repository/add_cv_repository.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/domain/use_cases/add_cv_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/network/app_api.dart';

final instance = GetIt.instance;

initAddCvRequest() {
  if (!GetIt.I.isRegistered<AddCvDataSource>()) {
    instance.registerLazySingleton<AddCvDataSource>(
        () => AddCvDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddCvRepository>()) {
    instance.registerLazySingleton<AddCvRepository>(
        () => AddCvRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddCvUseCase>()) {
    instance.registerFactory<AddCvUseCase>(
        () => AddCvUseCase(instance<AddCvRepository>()));
  }
}

disposeAddCvRequest() {
  if (GetIt.I.isRegistered<AddCvDataSource>()) {
    instance.unregister<AddCvDataSource>();
  }

  if (GetIt.I.isRegistered<AddCvRepository>()) {
    instance.unregister<AddCvRepository>();
  }

  if (GetIt.I.isRegistered<AddCvUseCase>()) {
    instance.unregister<AddCvUseCase>();
  }
}

void initAddCv() {
  initAddCvRequest();
  // Get.put(AddCompanyJobsController(
  //   instance<AddCompanyJobsUseCase>(),
  // ));
}

void disposeAddCv() {
  disposeAddCvRequest();
  // Get.delete<AddCompanyJobsController>();
}
