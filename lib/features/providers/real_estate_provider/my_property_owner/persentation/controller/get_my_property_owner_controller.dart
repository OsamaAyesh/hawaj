import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/models/get_property_owners_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/use_cases/get_property_owners_use_cases.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GetMyPropertyOwnerController extends GetxController {
  final GetPropertyOwnersUseCases _getPropertyOwnersUseCases;

  GetMyPropertyOwnerController(this._getPropertyOwnersUseCases);

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

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'خدمات الموقع غير مفعلة';
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'تم رفض صلاحية الموقع';
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'صلاحية الموقع مرفوضة بشكل دائم';
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      errorMessage.value = 'خطأ في الحصول على الموقع';
      return null;
    }
  }

  /// Fetch property owners using user's location
  Future<void> fetchMyOwners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await _getUserLocation();
      if (position == null) {
        isLoading.value = false;
        return;
      }

      final request = GetPropertyOwnersRequest(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      );

      final result = await _getPropertyOwnersUseCases.execute(request);

      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message ?? 'حدث خطأ غير متوقع';
        },
        (GetPropertyOwnersModel data) {
          if (data.data != null && data.data!.isNotEmpty) {
            owners.assignAll(data.data!);
          } else {
            errorMessage.value = 'لا توجد سجلات ملكية';
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'خطأ في جلب البيانات';
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
