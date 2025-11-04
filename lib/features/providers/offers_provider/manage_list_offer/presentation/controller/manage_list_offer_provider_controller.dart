import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/request/get_company_request.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/use_case/get_company_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/offer_new_item_model.dart';

class ManageListOfferProviderController extends GetxController {
  final GetCompanyUseCase _getCompanyUseCase;

  ManageListOfferProviderController(this._getCompanyUseCase);

  /// الحالة
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

  /// البيانات
  final company = Rxn<GetCompanyModel>();

  /// العروض
  List<OfferNewItemModel> get offers =>
      company.value?.data.offers ?? <OfferNewItemModel>[];

  bool get hasOffers => offers.isNotEmpty;

  /// تحميل العروض عبر ID الشركة
  Future<void> fetchOffersByCompanyId(String companyId,
      {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }
      errorMessage.value = '';

      final Either<Failure, GetCompanyModel> result =
          await _getCompanyUseCase.execute(GetCompanyRequest(id: companyId));

      result.fold(
        (failure) {
          errorMessage.value =
              failure.message ?? "حدث خطأ أثناء تحميل البيانات";
          company.value = null;
          if (kDebugMode) print("❌ Fetch Offers Error: ${failure.message}");
        },
        (success) {
          company.value = success;
          if (kDebugMode) print("✅ Offers Loaded: ${offers.length}");
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      if (kDebugMode) print("💥 Exception: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  @override
  void onClose() {
    company.value = null;
    super.onClose();
  }
}
