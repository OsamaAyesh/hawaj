import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/models/get_property_owners_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GetRealEstateMyOwnersController extends GetxController {
  final GetPropertyOwnersUseCases _getPropertyOwnersUseCases;

  GetRealEstateMyOwnersController(this._getPropertyOwnersUseCases);

  /// List of owners
  RxList<PropertyItemOwnerModel> owners = <PropertyItemOwnerModel>[].obs;

  /// Loading state
  RxBool isLoading = false.obs;

  /// Error message
  RxString errorMessage = ''.obs;

  /// Fetch user's current location (latitude & longitude)
  Future<Position?> _getUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Location services are disabled.';
        return null;
      }

      // Check for permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Location permission denied.';
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Location permission permanently denied.';
        return null;
      }

      // Get current location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      errorMessage.value = 'Error retrieving location.';
      return null;
    }
  }

  /// Fetch property owners using user's location
  Future<void> fetchMyOwners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get user's current location
      final position = await _getUserLocation();
      if (position == null) {
        isLoading.value = false;
        return;
      }

      // Create request with location data
      final request = GetPropertyOwnersRequest(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      );

      // Execute use case
      final result = await _getPropertyOwnersUseCases.execute(request);

      // Handle response
      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message ?? 'Unexpected error occurred';
        },
        (GetPropertyOwnersModel data) {
          if (data.data != null && data.data!.isNotEmpty) {
            owners.assignAll(data.data!);
          } else {
            errorMessage.value = 'No ownership records found.';
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Error fetching data.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchMyOwners();
  }
}
