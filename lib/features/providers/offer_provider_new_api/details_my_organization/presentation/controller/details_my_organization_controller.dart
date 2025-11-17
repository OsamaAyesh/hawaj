// details_my_organization_controller.dart
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../data/request/delete_my_offer_request.dart';
import '../../data/request/get_my_organization_details_request.dart';
import '../../domain/models/get_my_organization_details_model.dart';
import '../../domain/use_cases/delete_offer_use_case.dart';
import '../../domain/use_cases/get_my_organization_details_use_case.dart';

class DetailsMyOrganizationController extends GetxController {
  final GetMyOrganizationDetailsUseCase _getMyCompanyDetailsUseCase;
  final DeleteOfferUseCase _deleteOfferUseCase;

  DetailsMyOrganizationController(
    this._getMyCompanyDetailsUseCase,
    this._deleteOfferUseCase,
  );

  // State variables
  bool isLoading = false;
  bool isDeleting = false; // For delete operation loading
  GetMyOrganizationDetailsModel? companyDetailsData;
  String? errorMessage;
  bool hasError = false;
  String? currentCompanyId;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch company details by ID
  Future<void> getMyCompanyDetails(String id) async {
    currentCompanyId = id;
    isLoading = true;
    hasError = false;
    errorMessage = null;
    update();

    final request = GetMyOrganizationDetailsRequest(
      id: id,
    );

    final result = await _getMyCompanyDetailsUseCase.execute(request);

    result.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
        isLoading = false;
        update();
      },
      (data) {
        if (data.error == true) {
          hasError = true;
          errorMessage = data.message ?? "Organization not found";
        } else {
          companyDetailsData = data;
          hasError = false;
        }
        isLoading = false;
        update();
      },
    );
  }

  /// Delete offer by ID
  Future<void> deleteOffer(String offerId) async {
    try {
      isDeleting = true;
      update();

      final request = DeleteOfferRequest(id: offerId);

      final Either<Failure, WithOutDataModel> result =
          await _deleteOfferUseCase.execute(request);

      result.fold(
        (failure) {
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Failed to delete offer',
          );

          if (kDebugMode) {
            debugPrint('❌ [DeleteOffer] Failed to delete: ${failure.message}');
          }
        },
        (success) {
          if (!success.error) {
            AppSnackbar.success(
              'تم حذف العرض بنجاح',
              englishMessage: 'Offer deleted successfully',
            );

            // Refresh company details after successful delete
            if (currentCompanyId != null) {
              getMyCompanyDetails(currentCompanyId!);
            }

            if (kDebugMode) {
              debugPrint('✅ [DeleteOffer] Offer deleted successfully');
            }
          } else {
            AppSnackbar.error(
              success.message ?? 'فشل حذف العرض',
              englishMessage: 'Failed to delete offer',
            );
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع أثناء الحذف',
        englishMessage: 'Unexpected error during deletion',
      );

      if (kDebugMode) {
        debugPrint('💥 [DeleteOffer] Exception: $e');
      }
    } finally {
      isDeleting = false;
      update();
    }
  }

  /// Refresh company details
  Future<void> onRefresh() async {
    if (currentCompanyId != null) {
      await getMyCompanyDetails(currentCompanyId!);
    }
  }

  @override
  void onClose() {
    companyDetailsData = null;
    currentCompanyId = null;
    super.onClose();
  }
}
