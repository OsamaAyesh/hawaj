import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/delete_my_real_estate_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/edit_my_real_estate_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/get_my_real_estates_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/delete_my_real_estate_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/edit_my_real_estate_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/get_my_real_estates_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/delete_my_real_estate_use_case.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/edit_my_real_estate_use_case.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/get_my_real_estates_use_cases.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../../../../../core/network/app_api.dart';
import '../../presentation/controller/delete_my_real_estate_controller.dart';
import '../../presentation/controller/edit_my_real_estate_controller.dart';
import '../../presentation/controller/get_my_real_estates_controller.dart';

initGetMyRealEstatesRequest() {
  if (!GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
    instance.registerLazySingleton<GetMyRealEstatesDataSource>(
        () => GetMyRealEstatesDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
    instance.registerLazySingleton<GetMyRealEstatesRepository>(
        () => GetMyRealEstatesRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
    instance.registerFactory<GetMyRealEstatesUseCases>(
        () => GetMyRealEstatesUseCases(instance<GetMyRealEstatesRepository>()));
  }
}

disposeGetMyRealEstatesRequest() {
  if (GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
    instance.unregister<GetMyRealEstatesDataSource>();
  }

  if (GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
    instance.unregister<GetMyRealEstatesRepository>();
  }

  if (GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
    instance.unregister<GetMyRealEstatesUseCases>();
  }
}

void initGetMyRealEstates() {
  initGetMyRealEstatesRequest();
  Get.put(GetMyRealEstatesController(
    instance<GetMyRealEstatesUseCases>(),
  ));
}

void disposeGetMyRealEstates() {
  disposeGetMyRealEstatesRequest();
  Get.delete<GetMyRealEstatesController>();
}

initEditMyRealEstateRequest() {
  if (!GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
    instance.registerLazySingleton<EditMyRealEstateDataSource>(
        () => EditMyRealEstateDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
    instance.registerLazySingleton<EditMyRealEstateRepository>(
        () => EditMyRealEstateRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
    instance.registerFactory<EditMyRealEstateUseCase>(
        () => EditMyRealEstateUseCase(instance<EditMyRealEstateRepository>()));
  }
}

disposeEditMyRealEstateRequest() {
  if (GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
    instance.unregister<EditMyRealEstateDataSource>();
  }

  if (GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
    instance.unregister<EditMyRealEstateRepository>();
  }

  if (GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
    instance.unregister<EditMyRealEstateUseCase>();
  }
}

void initEditMyRealEstate() {
  initEditMyRealEstateRequest();
  Get.put(EditMyRealEstateController(
    instance<EditMyRealEstateUseCase>(),
  ));
}

void disposeEditMyRealEstate() {
  disposeEditMyRealEstateRequest();
  Get.delete<EditMyRealEstateController>();
}

initDeleteMyRealEstateRequest() {
  if (!GetIt.I.isRegistered<DeleteMyRealEstateDataSource>()) {
    instance.registerLazySingleton<DeleteMyRealEstateDataSource>(
        () => DeleteMyRealEstateDataSourceImplement(instance<AppService>()));
  }

  if (!GetIt.I.isRegistered<DeleteMyRealEstateRepository>()) {
    instance.registerLazySingleton<DeleteMyRealEstateRepository>(
        () => DeleteMyRealEstateRepositoryImplement(instance(), instance()));
  }

  if (!GetIt.I.isRegistered<DeleteMyRealEstateUseCase>()) {
    instance.registerFactory<DeleteMyRealEstateUseCase>(() =>
        DeleteMyRealEstateUseCase(instance<DeleteMyRealEstateRepository>()));
  }
}

disposeDeleteMyRealEstateRequest() {
  if (GetIt.I.isRegistered<DeleteMyRealEstateDataSource>()) {
    instance.unregister<DeleteMyRealEstateDataSource>();
  }

  if (GetIt.I.isRegistered<DeleteMyRealEstateRepository>()) {
    instance.unregister<DeleteMyRealEstateRepository>();
  }

  if (GetIt.I.isRegistered<DeleteMyRealEstateUseCase>()) {
    instance.unregister<DeleteMyRealEstateUseCase>();
  }
}

void initDeleteMyRealEstate() {
  initDeleteMyRealEstateRequest();
  Get.put(DeleteMyRealEstateController(
    instance<DeleteMyRealEstateUseCase>(),
  ));
}

void disposeDeleteMyRealEstate() {
  disposeDeleteMyRealEstateRequest();
  Get.delete<DeleteMyRealEstateController>();
}
