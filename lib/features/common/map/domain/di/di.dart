import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:get/get.dart';

import '../../../../users/offer_user/list_offers/domain/di/di.dart';
import '../../../profile/domain/di/di.dart';
import '../../../profile/domain/use_case/get_profile_use_case.dart';
import '../../data/data_sourcce/location_service.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../presenation/controller/drawer_controller.dart';
import '../../presenation/controller/map_controller.dart';
import '../../presenation/controller/map_sections_controller.dart';

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
    // Controller الـ Drawer
    Get.lazyPut<MapDrawerController>(
      () => MapDrawerController(instance<GetProfileUseCase>()),
    );
  }
}
