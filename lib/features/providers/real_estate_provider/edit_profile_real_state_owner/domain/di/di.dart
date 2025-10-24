import 'package:app_mobile/core/network/app_api.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../constants/di/dependency_injection.dart';
import '../../data/data_source/edit_profile_real_estate_owner_data_source.dart';
import '../../data/repository/edit_profile_real_estate_owner_repository.dart';
import '../../domain/use_cases/edit_profile_my_property_owner_use_case.dart';
import '../../presentation/controller/edit_profile_my_property_owner_controller.dart';

void initEditProfileMyPropertyOwnerModule(String ownerId) {
  /// ======== Edit Profile Owner ========
  if (!GetIt.I.isRegistered<EditProfileRealEstateOwnerDataSource>()) {
    instance.registerLazySingleton<EditProfileRealEstateOwnerDataSource>(
      () =>
          EditProfileRealEstateOwnerDataSourceImplement(instance<AppService>()),
    );
  }

  if (!GetIt.I.isRegistered<EditProfileRealEstateOwnerRepository>()) {
    instance.registerLazySingleton<EditProfileRealEstateOwnerRepository>(
      () =>
          EditProfileRealEstateOwnerRepositoryImplement(instance(), instance()),
    );
  }

  if (!GetIt.I.isRegistered<EditProfileMyPropertyOwnerUseCase>()) {
    instance.registerFactory<EditProfileMyPropertyOwnerUseCase>(
      () => EditProfileMyPropertyOwnerUseCase(
        instance<EditProfileRealEstateOwnerRepository>(),
      ),
    );
  }

  /// ======== Controller ========
  if (!Get.isRegistered<EditProfileMyPropertyOwnerController>()) {
    Get.put(
      EditProfileMyPropertyOwnerController(
        instance<EditProfileMyPropertyOwnerUseCase>(),
        ownerId,
      ),
    );
  }
}

void disposeEditProfileMyPropertyOwnerModule() {
  if (Get.isRegistered<EditProfileMyPropertyOwnerController>()) {
    Get.delete<EditProfileMyPropertyOwnerController>();
  }
}

// import 'package:app_mobile/core/network/app_api.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/data_source/edit_profile_real_estate_owner_data_source.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/repository/edit_profile_real_estate_owner_repository.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/use_cases/edit_profile_my_property_owner_use_case.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/presentation/controller/edit_profile_my_property_owner_controller.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
//
// import '../../../../../../constants/di/dependency_injection.dart';
//
// void initEditProfileMyPropertyOwnerModule() {
//   /// ======== Get Property Owners ========
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
//   /// ======== Edit Profile Owner ========
//   if (!GetIt.I.isRegistered<EditProfileRealEstateOwnerDataSource>()) {
//     instance.registerLazySingleton<EditProfileRealEstateOwnerDataSource>(() =>
//         EditProfileRealEstateOwnerDataSourceImplement(instance<AppService>()));
//   }
//
//   if (!GetIt.I.isRegistered<EditProfileRealEstateOwnerRepository>()) {
//     instance.registerLazySingleton<EditProfileRealEstateOwnerRepository>(() =>
//         EditProfileRealEstateOwnerRepositoryImplement(instance(), instance()));
//   }
//
//   if (!GetIt.I.isRegistered<EditProfileMyPropertyOwnerUseCase>()) {
//     instance.registerFactory<EditProfileMyPropertyOwnerUseCase>(() =>
//         EditProfileMyPropertyOwnerUseCase(
//             instance<EditProfileRealEstateOwnerRepository>()));
//   }
//
//   /// ======== Controller ========
//   if (!Get.isRegistered<EditProfileMyPropertyOwnerController>()) {
//     Get.put(EditProfileMyPropertyOwnerController(
//       instance<EditProfileMyPropertyOwnerUseCase>(),
//       instance<GetPropertyOwnersUseCases>(),
//     ));
//   }
// }
//
// void disposeEditProfileMyPropertyOwnerModule() {
//   if (Get.isRegistered<EditProfileMyPropertyOwnerController>()) {
//     Get.delete<EditProfileMyPropertyOwnerController>();
//   }
// }
