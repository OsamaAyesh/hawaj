// lib/features/common/map/domain/di/di.dart

import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/network/app_api.dart';
import '../../../../users/offer_user/list_offers/domain/di/di.dart';
import '../../../profile/domain/di/di.dart';
import '../../../profile/domain/use_case/get_profile_use_case.dart';
import '../../data/data_sourcce/drawer_menu_data_source.dart';
import '../../data/data_sourcce/location_service.dart';
import '../../data/repository/drawer_menu_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../presenation/controller/drawer_controller.dart';
import '../../presenation/controller/drawer_menu_controller.dart';
import '../../presenation/controller/map_controller.dart';
import '../../presenation/controller/map_sections_controller.dart';
import '../usecases/drawer_menu_use_case.dart';

class MapBindings extends Bindings {
  @override
  void dependencies() {
    // ===== Data Layer =====
    Get.lazyPut<LocationService>(() => LocationService());

    Get.lazyPut<LocationRepository>(
      () => LocationRepositoryImpl(Get.find()),
    );

    // ===== Domain Layer =====
    Get.lazyPut<GetCurrentLocationUseCase>(
      () => GetCurrentLocationUseCase(Get.find()),
    );

    // ===== Presentation Layer =====

    // Controller الموقع
    Get.lazyPut<MapController>(
      () => MapController(Get.find()),
    );

    // Controller الأقسام
    Get.lazyPut<MapSectionsController>(
      () => MapSectionsController(),
    );

    initGetProfile();
    initGetOrganizationsProvider();

    // 🔥 تهيئة Drawer Menu
    initDrawerMenu();

    // Controller الـ Drawer
    Get.lazyPut<MapDrawerController>(
      () => MapDrawerController(instance<GetProfileUseCase>()),
    );

    // ✅ Controller الـ Drawer Menu - استخدام GetIt
    Get.lazyPut<DrawerMenuController>(
      () => DrawerMenuController(instance<DrawerMenuUseCase>()),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 🎯 تهيئة Drawer Menu في GetIt
/// ═══════════════════════════════════════════════════════════
void initDrawerMenu() {
  if (!GetIt.I.isRegistered<DrawerMenuDataSource>()) {
    instance.registerLazySingleton<DrawerMenuDataSource>(
      () => DrawerMenuDataSourceImplement(instance<AppService>()),
    );
  }

  if (!GetIt.I.isRegistered<DrawerMenuRepository>()) {
    instance.registerLazySingleton<DrawerMenuRepository>(
      () => DrawerMenuRepositoryImplement(instance(), instance()),
    );
  }

  if (!GetIt.I.isRegistered<DrawerMenuUseCase>()) {
    instance.registerLazySingleton<DrawerMenuUseCase>(
      () => DrawerMenuUseCase(instance<DrawerMenuRepository>()),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// 🧹 تنظيف Drawer Menu من GetIt
/// ═══════════════════════════════════════════════════════════
void disposeDrawerMenu() {
  if (GetIt.I.isRegistered<DrawerMenuUseCase>()) {
    instance.unregister<DrawerMenuUseCase>();
  }

  if (GetIt.I.isRegistered<DrawerMenuRepository>()) {
    instance.unregister<DrawerMenuRepository>();
  }

  if (GetIt.I.isRegistered<DrawerMenuDataSource>()) {
    instance.unregister<DrawerMenuDataSource>();
  }
}
// import 'package:app_mobile/constants/di/dependency_injection.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
//
// import '../../../../../core/network/app_api.dart';
// import '../../../../users/offer_user/list_offers/domain/di/di.dart';
// import '../../../profile/domain/di/di.dart';
// import '../../../profile/domain/use_case/get_profile_use_case.dart';
// import '../../data/data_sourcce/drawer_menu_data_source.dart';
// import '../../data/data_sourcce/location_service.dart';
// import '../../data/repository/drawer_menu_repository.dart';
// import '../../domain/repositories/location_repository.dart';
// import '../../domain/usecases/get_current_location_usecase.dart';
// import '../../presenation/controller/drawer_controller.dart';
// import '../../presenation/controller/map_controller.dart';
// import '../../presenation/controller/map_sections_controller.dart';
// import '../usecases/drawer_menu_use_case.dart';
//
// class MapBindings extends Bindings {
//   @override
//   void dependencies() {
//     // ===== Data Layer =====
//     Get.lazyPut<LocationService>(() => LocationService());
//
//     Get.lazyPut<LocationRepository>(
//       () => LocationRepositoryImpl(Get.find()),
//     );
//
//     // ===== Domain Layer =====
//     Get.lazyPut<GetCurrentLocationUseCase>(
//       () => GetCurrentLocationUseCase(Get.find()),
//     );
//
//     // ===== Presentation Layer =====
//
//     // Controller الموقع
//     Get.lazyPut<MapController>(
//       () => MapController(Get.find()),
//     );
//
//     // Controller الأقسام
//     Get.lazyPut<MapSectionsController>(
//       () => MapSectionsController(),
//     );
//     initGetProfile();
//     initGetOrganizationsProvider();
//     // Controller الـ Drawer
//     Get.lazyPut<MapDrawerController>(
//       () => MapDrawerController(instance<GetProfileUseCase>()),
//     );
//   }
// }
//
// initDrawerMenu() {
//   if (!GetIt.I.isRegistered<DrawerMenuDataSource>()) {
//     instance.registerLazySingleton<DrawerMenuDataSource>(
//       () => DrawerMenuDataSourceImplement(instance<AppService>()),
//     );
//   }
//
//   if (!GetIt.I.isRegistered<DrawerMenuRepository>()) {
//     instance.registerLazySingleton<DrawerMenuRepository>(
//       () => DrawerMenuRepositoryImplement(instance(), instance()),
//     );
//   }
//
//   if (!GetIt.I.isRegistered<DrawerMenuUseCase>()) {
//     instance.registerFactory<DrawerMenuUseCase>(
//       () => DrawerMenuUseCase(instance<DrawerMenuRepository>()),
//     );
//   }
// }
//
// disposeDrawerMenu() {
//   if (GetIt.I.isRegistered<DrawerMenuDataSource>()) {
//     instance.unregister<DrawerMenuDataSource>();
//   }
//
//   if (GetIt.I.isRegistered<DrawerMenuRepository>()) {
//     instance.unregister<DrawerMenuRepository>();
//   }
//
//   if (GetIt.I.isRegistered<DrawerMenuUseCase>()) {
//     instance.unregister<DrawerMenuUseCase>();
//   }
// }
