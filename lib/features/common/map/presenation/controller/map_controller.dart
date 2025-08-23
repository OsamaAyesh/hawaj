import 'package:get/get.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/get_current_location_usecase.dart';

class MapController extends GetxController {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  MapController(this.getCurrentLocationUseCase);

  final Rx<LocationEntity?> currentLocation = Rx<LocationEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentLocation(); // يشتغل أول ما ينعمل Init للـ Controller
  }

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
    currentLocation.value = LocationEntity(latitude: lat, longitude: lng);
  }
}
