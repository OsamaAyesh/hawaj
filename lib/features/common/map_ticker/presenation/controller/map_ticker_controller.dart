import 'package:get/get.dart';

import '../../domain/entities/location_ticker_entity.dart';
import '../../domain/usecases/get_current_location_ticker_usecase.dart';

class MapTickerController extends GetxController {
  final GetCurrentLocationTickerUsecase getCurrentLocationUseCase;

  MapTickerController(this.getCurrentLocationUseCase);

  final Rx<LocationTickerEntity?> currentLocation =
      Rx<LocationTickerEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadCurrentLocation() async {
    try {
      isLoading.value = true;
      final location = await getCurrentLocationUseCase();
      currentLocation.value = location;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedLocation(double lat, double lng) {
    currentLocation.value = LocationTickerEntity(latitude: lat, longitude: lng);
  }
}
