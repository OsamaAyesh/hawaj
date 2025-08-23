import 'package:get/get.dart';

import '../../data/data_sourcce/location_service.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../presenation/controller/map_controller.dart';

class MapBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());

    Get.lazyPut<LocationRepository>(
          () => LocationRepositoryImpl(Get.find()),
    );

    Get.lazyPut<GetCurrentLocationUseCase>(
          () => GetCurrentLocationUseCase(Get.find()),
    );

    Get.lazyPut<MapController>(
          () => MapController(Get.find()),
    );
  }
}
