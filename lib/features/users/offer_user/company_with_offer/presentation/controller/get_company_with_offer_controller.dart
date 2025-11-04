import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/request/get_company_request.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../domain/use_case/get_company_use_case.dart';

class GetCompanyController extends GetxController {
  final GetCompanyUseCase _getCompanyUseCase;

  GetCompanyController(this._getCompanyUseCase);

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final companyModel = Rxn<GetCompanyModel>();
  final currentPosition = Rxn<Position>();

  bool _firstLoad = true;

  Future<void> fetchCompany(String companyId, {bool force = false}) async {
    if (!_firstLoad && !force) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final pos = await _getUserLocation();
      if (pos == null) {
        errorMessage.value = "لم يتمكن التطبيق من تحديد موقعك";
        return;
      }

      final result =
          await _getCompanyUseCase.execute(GetCompanyRequest(id: companyId));
      result.fold(
        (Failure f) => errorMessage.value = f.message ?? "حدث خطأ",
        (GetCompanyModel data) {
          companyModel.value = data;
          _firstLoad = false;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCompany(String id) async {
    _firstLoad = true;
    await fetchCompany(id, force: true);
  }

  Future<Position?> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      currentPosition.value = pos;
      return pos;
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    _firstLoad = true;
    super.onClose();
  }
}
