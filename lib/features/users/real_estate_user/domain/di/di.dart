import 'package:app_mobile/features/users/real_estate_user/data/data_source/add_visit_data_source.dart';
import 'package:app_mobile/features/users/real_estate_user/data/data_source/get_real_estate_user_data_source.dart';
import 'package:app_mobile/features/users/real_estate_user/data/repository/add_visit_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/data/repository/get_real_estate_user_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/domain/use_cases/add_visit_use_case.dart';
import 'package:app_mobile/features/users/real_estate_user/domain/use_cases/get_real_estate_user_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants/di/dependency_injection.dart';
import '../../../../../core/network/app_api.dart';
import '../../show_real_state_details_user/controller/add_visit_controller.dart';
import '../../show_real_state_details_user/controller/show_real_estate_details_user_controller.dart';

initGetRealEstateUserRequest() {
  if (!GetIt.I.isRegistered<GetRealEstateUserDataSource>()) {
    instance.registerLazySingleton<GetRealEstateUserDataSource>(
        () => GetRealEstateUserDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetRealEstateUserRepository>()) {
    instance.registerLazySingleton<GetRealEstateUserRepository>(
        () => GetRealEstateUserRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetRealEstateUserUseCase>()) {
    instance.registerFactory<GetRealEstateUserUseCase>(() =>
        GetRealEstateUserUseCase(instance<GetRealEstateUserRepository>()));
  }
}

disposeGetRealEstateUserRequest() {
  if (GetIt.I.isRegistered<GetRealEstateUserDataSource>()) {
    instance.unregister<GetRealEstateUserDataSource>();
  }

  if (GetIt.I.isRegistered<GetRealEstateUserRepository>()) {
    instance.unregister<GetRealEstateUserRepository>();
  }

  if (GetIt.I.isRegistered<GetRealEstateUserUseCase>()) {
    instance.unregister<GetRealEstateUserUseCase>();
  }
}

void initGetRealEstateUser() {
  initGetRealEstateUserRequest();
  initAddVisit();
  Get.put(GetRealEstateUserController(
    instance<GetRealEstateUserUseCase>(),
  ));
}

void disposeGetRealEstateUser() {
  disposeGetRealEstateUserRequest();
  disposeAddVisit();
  Get.delete<GetRealEstateUserController>();
}

initAddVisitRequest() {
  if (!GetIt.I.isRegistered<AddVisitDataSource>()) {
    instance.registerLazySingleton<AddVisitDataSource>(
        () => AddVisitDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<AddVisitRepository>()) {
    instance.registerLazySingleton<AddVisitRepository>(
        () => AddVisitRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<AddVisitUseCase>()) {
    instance.registerFactory<AddVisitUseCase>(
        () => AddVisitUseCase(instance<AddVisitRepository>()));
  }
}

disposeAddVisitRequest() {
  if (GetIt.I.isRegistered<AddVisitDataSource>()) {
    instance.unregister<AddVisitDataSource>();
  }

  if (GetIt.I.isRegistered<AddVisitRepository>()) {
    instance.unregister<AddVisitRepository>();
  }

  if (GetIt.I.isRegistered<AddVisitUseCase>()) {
    instance.unregister<AddVisitUseCase>();
  }
}

void initAddVisit() {
  initAddVisitRequest();
  Get.put(AddVisitController(
    instance<AddVisitUseCase>(),
  ));
}

void disposeAddVisit() {
  disposeAddVisitRequest();
  Get.delete<AddVisitController>();
}
