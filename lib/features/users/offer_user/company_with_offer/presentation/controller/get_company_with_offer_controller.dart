import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/request/get_company_request.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../domain/use_case/get_company_use_case.dart';

class GetCompanyController extends GetxController {
  final GetCompanyUseCase _getCompanyUseCase;

  GetCompanyController(this._getCompanyUseCase);

  /// الحالة
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// بيانات الشركة
  var companyModel = Rxn<GetCompanyModel>();

  /// الموقع الحالي
  var currentPosition = Rxn<Position>();

  /// ✅ متغير للتحقق من أول تحميل
  var _isFirstLoad = true;

  /// الحصول على موقع المستخدم
  Future<Position?> _getUserLocation() async {
    try {
      // التحقق من صلاحيات الموقع
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Location permissions are denied';
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Location permissions are permanently denied';
        return null;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      return position;
    } catch (e) {
      errorMessage.value = 'Error getting location: ${e.toString()}';
      return null;
    }
  }

  /// ✅ تحميل بيانات الشركة (مع التحقق من أول تحميل)
  Future<void> fetchCompany(int companyId, {bool forceRefresh = false}) async {
    // ✅ منع التحميل إذا لم يكن refresh صريح
    if (!_isFirstLoad && !forceRefresh) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // الحصول على الموقع أولاً
      Position? position = await _getUserLocation();

      if (position == null) {
        errorMessage.value = 'Unable to get location';
        isLoading.value = false;
        return;
      }

      final result = await _getCompanyUseCase.execute(
        GetCompanyRequest(
          id: companyId.toDouble(),
          language: AppLanguage().getCurrentLocale(),
          lat: position.latitude.toString(),
          lng: position.longitude.toString(),
        ),
      );

      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message ?? "Something went wrong";
        },
        (GetCompanyModel model) {
          companyModel.value = model;
          _isFirstLoad = false; // ✅ تم التحميل الأول
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// تحديث البيانات (للـ RefreshIndicator)
  Future<void> refreshCompany(int companyId) async {
    await fetchCompany(companyId, forceRefresh: true);
  }

  /// ✅ إعادة تعيين عند إغلاق الـ Controller
  @override
  void onClose() {
    _isFirstLoad = true;
    super.onClose();
  }
}
