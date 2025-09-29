import 'package:get/get.dart';

import '../../data/data_sourcce/location_ticker_service.dart';
import '../../domain/repositories/location_ticker_repository.dart';
import '../../domain/usecases/get_current_location_ticker_usecase.dart';
import '../../presenation/controller/map_ticker_controller.dart';

class MapTickerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationTickerService>(() => LocationTickerService());

    Get.lazyPut<LocationTickerRepository>(
      () => LocationTickerRepositoryImpl(Get.find()),
    );

    Get.lazyPut<GetCurrentLocationTickerUsecase>(
      () => GetCurrentLocationTickerUsecase(Get.find()),
    );

    Get.lazyPut<MapTickerController>(
      () => MapTickerController(Get.find()),
    );
  }
}
