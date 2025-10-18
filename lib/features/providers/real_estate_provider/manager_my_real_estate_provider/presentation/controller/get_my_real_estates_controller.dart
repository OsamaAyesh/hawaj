import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/model/real_estate_item_model.dart';
import '../../../../../../core/util/snack_bar.dart';
import '../../data/request/get_my_real_estates_request.dart';
import '../../domain/models/get_my_real_estates_model.dart';
import '../../domain/use_cases/get_my_real_estates_use_cases.dart';

class GetMyRealEstatesController extends GetxController {
  final GetMyRealEstatesUseCases _getMyRealEstatesUseCases;

  GetMyRealEstatesController(this._getMyRealEstatesUseCases);

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Position? currentPosition;

  final realEstates = <RealEstateItemModel>[].obs;

  bool _isFetched = false;

  @override
  void onInit() {
    super.onInit();
    fetchMyRealEstates();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        AppSnackbar.error("يرجى تفعيل صلاحية الموقع");
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      AppSnackbar.error("حدث خطأ أثناء تحديد الموقع");
    }
  }

  Future<void> fetchMyRealEstates() async {
    if (_isFetched) return;
    isLoading.value = true;

    await _loadCurrentLocation();
    if (currentPosition == null) {
      isLoading.value = false;
      return;
    }

    final request = GetMyRealEstatesRequest(
      lat: currentPosition!.latitude.toString(),
      lng: currentPosition!.longitude.toString(),
      language: AppLanguage().getCurrentLocale(),
    );

    final result = await _getMyRealEstatesUseCases.execute(request);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        AppSnackbar.error(failure.message);
      },
      (GetMyRealEstatesModel model) {
        realEstates.assignAll(model.data);
        _isFetched = true;
      },
    );

    isLoading.value = false;
  }

  Future<void> refreshEstates() async {
    _isFetched = false;
    await fetchMyRealEstates();
  }
}
