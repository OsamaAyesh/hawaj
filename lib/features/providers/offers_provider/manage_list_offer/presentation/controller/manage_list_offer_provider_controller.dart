import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/offer_general_item_model.dart';
import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../add_offer/data/request/get_my_company_set_offer_request.dart';
import '../../../add_offer/domain/use_case/get_my_company_set_offer_use_case.dart';

class ManageListOfferProviderController extends GetxController {
  final GetMyCompanySetOfferUseCase _getMyCompanySetOfferUseCase;

  ManageListOfferProviderController(this._getMyCompanySetOfferUseCase);

  // ========== State ==========
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var errorMessage = ''.obs;

  // ========== Data ==========
  Rxn<OrganizationCompanyDailyOfferItemModel> myCompany =
      Rxn<OrganizationCompanyDailyOfferItemModel>();

  // ========== Getters ==========
  List<OfferGeneralItemModel> get offers => myCompany.value?.offers ?? [];

  bool get hasOffers => offers.isNotEmpty;

  bool get hasCompany => myCompany.value != null;

  // ========== Statistics ==========
  int get publishedCount => offers.where((o) => o.offerStatus == 1).length;

  int get unpublishedCount => offers.where((o) => o.offerStatus == 2).length;

  int get expiredCount => offers.where((o) => o.offerStatus == 3).length;

  // ========== API Call ==========
  Future<void> fetchOffers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }
      errorMessage.value = '';

      final request = GetMyOrganizationSetOfferRequest(my: true);
      final result = await _getMyCompanySetOfferUseCase.execute(request);

      result.fold(
        (Failure failure) {
          errorMessage.value = failure.message;
          if (!isRefresh) myCompany.value = null;
          if (kDebugMode) print('❌ Error: ${failure.message}');
        },
        (success) {
          myCompany.value = success.data;
          errorMessage.value = '';
          if (kDebugMode) {
            print('✅ Success: ${offers.length} offers loaded');
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      if (kDebugMode) print('💥 Exception: $e');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  // ========== Lifecycle ==========
  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }
}
