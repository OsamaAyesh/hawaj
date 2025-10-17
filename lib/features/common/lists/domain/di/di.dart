import 'package:app_mobile/features/common/lists/data/data_source/get_lists_data_source.dart';
import 'package:app_mobile/features/common/lists/data/repository/get_lists_repository.dart';
import 'package:app_mobile/features/common/lists/domain/use_cases/get_lists_use_case.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';

initGetListsRequest() {
  if (!GetIt.I.isRegistered<GetListsDataSource>()) {
    instance.registerLazySingleton<GetListsDataSource>(
        () => GetListsDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetListsRepository>()) {
    instance.registerLazySingleton<GetListsRepository>(
        () => GetListsRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetListsUseCase>()) {
    instance.registerFactory<GetListsUseCase>(
        () => GetListsUseCase(instance<GetListsRepository>()));
  }
}

disposeGetListsRequest() {
  if (GetIt.I.isRegistered<GetListsDataSource>()) {
    instance.unregister<GetListsDataSource>();
  }

  if (GetIt.I.isRegistered<GetListsRepository>()) {
    instance.unregister<GetListsRepository>();
  }

  if (GetIt.I.isRegistered<GetListsUseCase>()) {
    instance.unregister<GetListsUseCase>();
  }
}

void initGetLists() {
  initGetListsRequest();
  // Get.put(SendOtpController(
  //   instance<SendOtpUseCase>(),
  //   instance<VerfiyOtpUseCase>(),
  // ));
}

void disposeGetLists() {
  disposeGetListsRequest();
  // Get.delete<SendOtpController>();
}
