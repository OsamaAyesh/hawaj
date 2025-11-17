import 'dart:io';

import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../common/domain/models/get_my_company_model.dart';
import '../../../common/domain/use_cases/get_my_company_use_case.dart';
import '../../data/request/add_offer_new_request.dart';
import '../../domain/use_cases/add_offer_new_use_case.dart';

// add_offer_new_controller.dart

class AddOfferNewController extends GetxController {
  final AddOfferNewUseCase _addOfferUseCase;
  final GetMyCompanyUseCase _getMyCompanyUseCase;

  AddOfferNewController(
    this._addOfferUseCase,
    this._getMyCompanyUseCase,
  );

  // ==================== Text Controllers ====================
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final offerStartDateController = TextEditingController();
  final offerEndDateController = TextEditingController();
  final offerDescriptionController = TextEditingController();

  // ==================== Reactive State ====================
  final pickedImage = Rx<File?>(null);

  final offerType = "2".obs;
  final offerStatus = "5".obs;

  final isLoading = true.obs; // ✅ Start with true
  final isSubmitting = false.obs;

  final companies = <GetOrganizationItemWithOfferModel>[].obs;
  final selectedCompany = Rxn<GetOrganizationItemWithOfferModel>();

  // ✅ Add flag to track if data was fetched
  final hasAttemptedFetch = false.obs;

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    // Don't fetch here - fetch in screen's initState
  }

  // ==================== Get Companies ====================
  /// Fetch user's companies/organizations
  Future<void> fetchCompanies() async {
    try {
      isLoading.value = true;
      hasAttemptedFetch.value = true;

      final Either<Failure, GetMyCompanyModel> result =
          await _getMyCompanyUseCase.execute();

      result.fold(
        (failure) {
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Failed to load organizations',
          );

          if (kDebugMode) {
            debugPrint(
                '❌ [AddOfferNew] Failed to fetch companies: ${failure.message}');
          }
        },
        (data) {
          companies.value = data.data;

          if (companies.isNotEmpty) {
            // Auto-select first company
            selectedCompany.value = companies.first;

            if (kDebugMode) {
              debugPrint(
                  '✅ [AddOfferNew] Loaded ${companies.length} companies');
            }
          } else {
            if (kDebugMode) {
              debugPrint('⚠️ [AddOfferNew] No companies found');
            }
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع أثناء جلب المؤسسات',
        englishMessage: 'Unexpected error loading organizations',
      );

      if (kDebugMode) {
        debugPrint('💥 [AddOfferNew] Exception: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry fetching companies
  void retryFetchCompanies() {
    fetchCompanies();
  }

  // ==================== Submit Offer ====================
  Future<void> submitOffer() async {
    if (selectedCompany.value == null) {
      AppSnackbar.warning(
        'يرجى اختيار مؤسسة قبل المتابعة',
        englishMessage: 'Please select an organization first',
      );
      return;
    }

    if (!_validateForm()) return;

    try {
      isSubmitting.value = true;

      final request = AddOfferNewRequest(
        productName: productNameController.text.trim(),
        productDescription: productDescriptionController.text.trim(),
        productImage: pickedImage.value,
        productPrice: productPriceController.text.trim(),
        offerType: offerType.value,
        offerPrice: offerPriceController.text.trim(),
        offerStartDate: offerStartDateController.text.trim(),
        offerEndDate: offerEndDateController.text.trim(),
        offerDescription: offerDescriptionController.text.trim(),
        organizationId: int.parse(selectedCompany.value!.id),
        offerStatus: offerStatus.value,
      );

      final Either<Failure, WithOutDataModel> result =
          await _addOfferUseCase.execute(request);

      result.fold(
        (failure) {
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Failed to add offer',
          );

          if (kDebugMode) {
            debugPrint('❌ [AddOfferNew] Failed to submit: ${failure.message}');
          }
        },
        (success) {
          if (!success.error) {
            AppSnackbar.success(
              'تمت إضافة العرض بنجاح',
              englishMessage: 'Offer added successfully',
            );

            _clearForm();

            // Navigate back after success
            Get.back(result: true);

            if (kDebugMode) {
              debugPrint('✅ [AddOfferNew] Offer added successfully');
            }
          } else {
            AppSnackbar.error(success.message);
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع أثناء الإرسال',
        englishMessage: 'Unexpected error during submission',
      );

      if (kDebugMode) {
        debugPrint('💥 [AddOfferNew] Exception: $e');
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== Validation ====================
  bool _validateForm() {
    if (productNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم المنتج',
        englishMessage: 'Please enter product name',
      );
      return false;
    }

    if (productDescriptionController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال وصف المنتج',
        englishMessage: 'Please enter product description',
      );
      return false;
    }

    if (pickedImage.value == null) {
      AppSnackbar.warning(
        'يرجى رفع صورة المنتج',
        englishMessage: 'Please upload product image',
      );
      return false;
    }

    if (productPriceController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال السعر',
        englishMessage: 'Please enter price',
      );
      return false;
    }

    if (double.tryParse(productPriceController.text.trim()) == null) {
      AppSnackbar.warning(
        'يرجى إدخال سعر صحيح',
        englishMessage: 'Please enter a valid price',
      );
      return false;
    }

    if (offerType.value.isEmpty) {
      AppSnackbar.warning(
        'اختر نوع العرض',
        englishMessage: 'Select offer type',
      );
      return false;
    }

    if (offerType.value == "1") {
      if (offerPriceController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى إدخال نسبة الخصم',
          englishMessage: 'Please enter discount percentage',
        );
        return false;
      }

      final discount = double.tryParse(offerPriceController.text.trim());
      if (discount == null || discount <= 0 || discount > 100) {
        AppSnackbar.warning(
          'يرجى إدخال نسبة خصم صحيحة (1-100)',
          englishMessage: 'Please enter valid discount (1-100)',
        );
        return false;
      }

      if (offerStartDateController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى اختيار تاريخ بداية العرض',
          englishMessage: 'Please select offer start date',
        );
        return false;
      }

      if (offerEndDateController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى اختيار تاريخ نهاية العرض',
          englishMessage: 'Please select offer end date',
        );
        return false;
      }

      if (offerDescriptionController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى إدخال وصف العرض',
          englishMessage: 'Please enter offer description',
        );
        return false;
      }
    }

    return true;
  }

  // ==================== Clear Form ====================
  void _clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    offerPriceController.clear();
    offerStartDateController.clear();
    offerEndDateController.clear();
    offerDescriptionController.clear();

    pickedImage.value = null;
    offerType.value = '2';
    offerStatus.value = '5';
  }

  void clearForm() {
    _clearForm();
  }

  // ==================== Cleanup ====================
  @override
  void onClose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    offerPriceController.dispose();
    offerStartDateController.dispose();
    offerEndDateController.dispose();
    offerDescriptionController.dispose();

    super.onClose();
  }
}
