import 'package:get/get.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/request/get_company_request.dart';

import '../../domain/use_case/get_company_use_case.dart';

class GetCompanyController extends GetxController {
  final GetCompanyUseCase _getCompanyUseCase;

  GetCompanyController(this._getCompanyUseCase);

  /// الحالة
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// بيانات الشركة
  var companyModel = Rxn<GetCompanyModel>();

  /// تحميل بيانات الشركة
  Future<void> fetchCompany(int companyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getCompanyUseCase.execute(
        GetCompanyRequest(idOrg: companyId),
      );

      result.fold(
            (Failure failure) {
          errorMessage.value = failure.message ?? "Something went wrong";
        },
            (GetCompanyModel model) {
          companyModel.value = model;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// تحديث البيانات
  void refreshCompany() {
    if (companyModel.value != null) {
      fetchCompany(companyModel.value!.data.data.id);
    }
  }
}
