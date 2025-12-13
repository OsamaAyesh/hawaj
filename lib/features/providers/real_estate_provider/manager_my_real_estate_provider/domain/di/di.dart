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
// ===== Common Lists =====
import '../../../../../common/lists/data/data_source/get_lists_data_source.dart';
import '../../../../../common/lists/data/repository/get_lists_repository.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
// ===== Get Property Owners =====
import '../../../edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
import '../../../edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
import '../../../edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
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

// initEditMyRealEstateRequest() {
//   // ===== Get Lists =====
//   if (!GetIt.I.isRegistered<GetListsDataSource>()) {
//     instance.registerLazySingleton<GetListsDataSource>(
//         () => GetListsDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<GetListsRepository>()) {
//     instance.registerLazySingleton<GetListsRepository>(
//         () => GetListsRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<GetListsUseCase>()) {
//     instance.registerFactory<GetListsUseCase>(
//         () => GetListsUseCase(instance<GetListsRepository>()));
//   }
//
//   // ===== Get Property Owners =====
//   if (!GetIt.I.isRegistered<GetPropertyOwnersDataSource>()) {
//     instance.registerLazySingleton<GetPropertyOwnersDataSource>(
//         () => GetPropertyOwnersDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<GetPropertyOwnersRepository>()) {
//     instance.registerLazySingleton<GetPropertyOwnersRepository>(
//         () => GetPropertyOwnersRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<GetPropertyOwnersUseCases>()) {
//     instance.registerFactory<GetPropertyOwnersUseCases>(() =>
//         GetPropertyOwnersUseCases(instance<GetPropertyOwnersRepository>()));
//   }
//
//   // ===== Edit Real Estate =====
//   if (!GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
//     instance.registerLazySingleton<EditMyRealEstateDataSource>(
//         () => EditMyRealEstateDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
//     instance.registerLazySingleton<EditMyRealEstateRepository>(
//         () => EditMyRealEstateRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
//     instance.registerFactory<EditMyRealEstateUseCase>(
//         () => EditMyRealEstateUseCase(instance<EditMyRealEstateRepository>()));
//   }
// }
void initEditMyRealEstateModule() {
  final instance = GetIt.I;

  /// ======== Get Lists ========
  if (!instance.isRegistered<GetListsDataSource>()) {
    instance.registerLazySingleton<GetListsDataSource>(
      () => GetListsDataSourceImplement(instance<AppService>()),
    );
  }

  if (!instance.isRegistered<GetListsRepository>()) {
    instance.registerLazySingleton<GetListsRepository>(
      () => GetListsRepositoryImplement(instance(), instance()),
    );
  }

  if (!instance.isRegistered<GetListsUseCase>()) {
    instance.registerFactory<GetListsUseCase>(
      () => GetListsUseCase(instance<GetListsRepository>()),
    );
  }

  /// ======== Get Property Owners ========
  if (!instance.isRegistered<GetPropertyOwnersDataSource>()) {
    instance.registerLazySingleton<GetPropertyOwnersDataSource>(
      () => GetPropertyOwnersDataSourceImplement(instance<AppService>()),
    );
  }

  if (!instance.isRegistered<GetPropertyOwnersRepository>()) {
    instance.registerLazySingleton<GetPropertyOwnersRepository>(
      () => GetPropertyOwnersRepositoryImplement(instance(), instance()),
    );
  }

  if (!instance.isRegistered<GetPropertyOwnersUseCases>()) {
    instance.registerFactory<GetPropertyOwnersUseCases>(
      () => GetPropertyOwnersUseCases(
        instance<GetPropertyOwnersRepository>(),
      ),
    );
  }

  /// ======== Edit Real Estate ========
  if (!instance.isRegistered<EditMyRealEstateDataSource>()) {
    instance.registerLazySingleton<EditMyRealEstateDataSource>(
      () => EditMyRealEstateDataSourceImplement(instance<AppService>()),
    );
  }

  if (!instance.isRegistered<EditMyRealEstateRepository>()) {
    instance.registerLazySingleton<EditMyRealEstateRepository>(
      () => EditMyRealEstateRepositoryImplement(instance(), instance()),
    );
  }

  if (!instance.isRegistered<EditMyRealEstateUseCase>()) {
    instance.registerFactory<EditMyRealEstateUseCase>(
      () => EditMyRealEstateUseCase(
        instance<EditMyRealEstateRepository>(),
      ),
    );
  }

  /// ======== Controller ========
  if (!Get.isRegistered<EditMyRealEstateController>()) {
    Get.put(
      EditMyRealEstateController(
        instance<EditMyRealEstateUseCase>(),
        instance<GetListsUseCase>(),
        instance<GetPropertyOwnersUseCases>(),
      ),
    );
  }
}

// disposeEditMyRealEstateRequest() {
//   if (GetIt.I.isRegistered<GetListsDataSource>()) {
//     instance.unregister<GetListsDataSource>();
//   }
//   if (GetIt.I.isRegistered<GetListsRepository>()) {
//     instance.unregister<GetListsRepository>();
//   }
//   if (GetIt.I.isRegistered<GetListsUseCase>()) {
//     instance.unregister<GetListsUseCase>();
//   }
//
//   if (GetIt.I.isRegistered<GetPropertyOwnersDataSource>()) {
//     instance.unregister<GetPropertyOwnersDataSource>();
//   }
//   if (GetIt.I.isRegistered<GetPropertyOwnersRepository>()) {
//     instance.unregister<GetPropertyOwnersRepository>();
//   }
//   if (GetIt.I.isRegistered<GetPropertyOwnersUseCases>()) {
//     instance.unregister<GetPropertyOwnersUseCases>();
//   }
//
//   if (GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
//     instance.unregister<EditMyRealEstateDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
//     instance.unregister<EditMyRealEstateRepository>();
//   }
//
//   if (GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
//     instance.unregister<EditMyRealEstateUseCase>();
//   }
// }
void disposeEditMyRealEstateModule() {
  final instance = GetIt.I;

  if (instance.isRegistered<GetListsDataSource>())
    instance.unregister<GetListsDataSource>();
  if (instance.isRegistered<GetListsRepository>())
    instance.unregister<GetListsRepository>();
  if (instance.isRegistered<GetListsUseCase>())
    instance.unregister<GetListsUseCase>();

  if (instance.isRegistered<GetPropertyOwnersDataSource>())
    instance.unregister<GetPropertyOwnersDataSource>();
  if (instance.isRegistered<GetPropertyOwnersRepository>())
    instance.unregister<GetPropertyOwnersRepository>();
  if (instance.isRegistered<GetPropertyOwnersUseCases>())
    instance.unregister<GetPropertyOwnersUseCases>();

  if (instance.isRegistered<EditMyRealEstateDataSource>())
    instance.unregister<EditMyRealEstateDataSource>();
  if (instance.isRegistered<EditMyRealEstateRepository>())
    instance.unregister<EditMyRealEstateRepository>();
  if (instance.isRegistered<EditMyRealEstateUseCase>())
    instance.unregister<EditMyRealEstateUseCase>();

  if (Get.isRegistered<EditMyRealEstateController>())
    Get.delete<EditMyRealEstateController>();
}
// void initEditMyRealEstate() {
//   initEditMyRealEstateRequest();
//   Get.put(EditMyRealEstateController(
//     instance<EditMyRealEstateUseCase>(),
//     instance<GetListsUseCase>(),
//     instance<GetPropertyOwnersUseCases>(),
//   ));
// }

void disposeEditMyRealEstate() {
  // disposeEditMyRealEstateRequest();
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

// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/delete_my_real_estate_data_source.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/edit_my_real_estate_data_source.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/get_my_real_estates_data_source.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/delete_my_real_estate_repository.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/edit_my_real_estate_repository.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/get_my_real_estates_repository.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/delete_my_real_estate_use_case.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/edit_my_real_estate_use_case.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/use_cases/get_my_real_estates_use_cases.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
//
// import '../../../../../../constants/di/dependency_injection.dart';
// import '../../../../../../core/network/app_api.dart';
// import '../../presentation/controller/delete_my_real_estate_controller.dart';
// import '../../presentation/controller/edit_my_real_estate_controller.dart';
// import '../../presentation/controller/get_my_real_estates_controller.dart';
//
// initGetMyRealEstatesRequest() {
//   if (!GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
//     instance.registerLazySingleton<GetMyRealEstatesDataSource>(
//         () => GetMyRealEstatesDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
//     instance.registerLazySingleton<GetMyRealEstatesRepository>(
//         () => GetMyRealEstatesRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
//     instance.registerFactory<GetMyRealEstatesUseCases>(
//         () => GetMyRealEstatesUseCases(instance<GetMyRealEstatesRepository>()));
//   }
// }
//
// disposeGetMyRealEstatesRequest() {
//   if (GetIt.I.isRegistered<GetMyRealEstatesDataSource>()) {
//     instance.unregister<GetMyRealEstatesDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<GetMyRealEstatesRepository>()) {
//     instance.unregister<GetMyRealEstatesRepository>();
//   }
//
//   if (GetIt.I.isRegistered<GetMyRealEstatesUseCases>()) {
//     instance.unregister<GetMyRealEstatesUseCases>();
//   }
// }
//
// void initGetMyRealEstates() {
//   initGetMyRealEstatesRequest();
//   Get.put(GetMyRealEstatesController(
//     instance<GetMyRealEstatesUseCases>(),
//   ));
// }
//
// void disposeGetMyRealEstates() {
//   disposeGetMyRealEstatesRequest();
//   Get.delete<GetMyRealEstatesController>();
// }
//
// initEditMyRealEstateRequest() {
//   if (!GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
//     instance.registerLazySingleton<EditMyRealEstateDataSource>(
//         () => EditMyRealEstateDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
//     instance.registerLazySingleton<EditMyRealEstateRepository>(
//         () => EditMyRealEstateRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
//     instance.registerFactory<EditMyRealEstateUseCase>(
//         () => EditMyRealEstateUseCase(instance<EditMyRealEstateRepository>()));
//   }
// }
//
// disposeEditMyRealEstateRequest() {
//   if (GetIt.I.isRegistered<EditMyRealEstateDataSource>()) {
//     instance.unregister<EditMyRealEstateDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<EditMyRealEstateRepository>()) {
//     instance.unregister<EditMyRealEstateRepository>();
//   }
//
//   if (GetIt.I.isRegistered<EditMyRealEstateUseCase>()) {
//     instance.unregister<EditMyRealEstateUseCase>();
//   }
// }
//
// void initEditMyRealEstate() {
//   initEditMyRealEstateRequest();
//   Get.put(EditMyRealEstateController(
//     instance<EditMyRealEstateUseCase>(),
//   ));
// }
//
// void disposeEditMyRealEstate() {
//   disposeEditMyRealEstateRequest();
//   Get.delete<EditMyRealEstateController>();
// }
//
// initDeleteMyRealEstateRequest() {
//   if (!GetIt.I.isRegistered<DeleteMyRealEstateDataSource>()) {
//     instance.registerLazySingleton<DeleteMyRealEstateDataSource>(
//         () => DeleteMyRealEstateDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<DeleteMyRealEstateRepository>()) {
//     instance.registerLazySingleton<DeleteMyRealEstateRepository>(
//         () => DeleteMyRealEstateRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<DeleteMyRealEstateUseCase>()) {
//     instance.registerFactory<DeleteMyRealEstateUseCase>(() =>
//         DeleteMyRealEstateUseCase(instance<DeleteMyRealEstateRepository>()));
//   }
// }
//
// disposeDeleteMyRealEstateRequest() {
//   if (GetIt.I.isRegistered<DeleteMyRealEstateDataSource>()) {
//     instance.unregister<DeleteMyRealEstateDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<DeleteMyRealEstateRepository>()) {
//     instance.unregister<DeleteMyRealEstateRepository>();
//   }
//
//   if (GetIt.I.isRegistered<DeleteMyRealEstateUseCase>()) {
//     instance.unregister<DeleteMyRealEstateUseCase>();
//   }
// }
//
// void initDeleteMyRealEstate() {
//   initDeleteMyRealEstateRequest();
//   Get.put(DeleteMyRealEstateController(
//     instance<DeleteMyRealEstateUseCase>(),
//   ));
// }
//
// void disposeDeleteMyRealEstate() {
//   disposeDeleteMyRealEstateRequest();
//   Get.delete<DeleteMyRealEstateController>();
// }
