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

  // ✅ قيم افتراضية صحيحة
  final offerType = "2".obs; // Default: عرض عادي
  final offerStatus = "5".obs; // Default: قيد المراجعة

  final isLoading = false.obs; // Loading for fetching companies
  final isSubmitting = false.obs; // Loading for submitting offer

  final companies = <GetOrganizationItemWithOfferModel>[].obs;
  final selectedCompany = Rxn<GetOrganizationItemWithOfferModel>();

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _fetchCompanies();
  }

  // ==================== Get Companies ====================
  /// Fetch user's companies/organizations
  Future<void> _fetchCompanies() async {
    try {
      isLoading.value = true;

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

          if (companies.isEmpty) {
            AppSnackbar.warning(
              'لا توجد مؤسسات متاحة',
              englishMessage: 'No organizations available',
            );
          } else {
            // Auto-select first company
            selectedCompany.value = companies.first;
          }

          if (kDebugMode) {
            debugPrint('✅ [AddOfferNew] Loaded ${companies.length} companies');
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
    _fetchCompanies();
  }

  // ==================== Submit Offer ====================
  /// Submit new offer
  Future<void> submitOffer() async {
    // Check if company is selected
    if (selectedCompany.value == null) {
      AppSnackbar.warning(
        'يرجى اختيار مؤسسة قبل المتابعة',
        englishMessage: 'Please select an organization first',
      );
      return;
    }

    // Validate form
    if (!_validateForm()) return;

    try {
      isSubmitting.value = true;

      // Create request
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

      // Execute request
      final Either<Failure, WithOutDataModel> result =
          await _addOfferUseCase.execute(request);

      // Handle result
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

            // Clear form after success
            _clearForm();

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
  /// Validate form fields
  bool _validateForm() {
    // Product Name
    if (productNameController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال اسم المنتج',
        englishMessage: 'Please enter product name',
      );
      return false;
    }

    // Product Description
    if (productDescriptionController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال وصف المنتج',
        englishMessage: 'Please enter product description',
      );
      return false;
    }

    // Product Image
    if (pickedImage.value == null) {
      AppSnackbar.warning(
        'يرجى رفع صورة المنتج',
        englishMessage: 'Please upload product image',
      );
      return false;
    }

    // Product Price
    if (productPriceController.text.trim().isEmpty) {
      AppSnackbar.warning(
        'يرجى إدخال السعر',
        englishMessage: 'Please enter price',
      );
      return false;
    }

    // Validate price is a number
    if (double.tryParse(productPriceController.text.trim()) == null) {
      AppSnackbar.warning(
        'يرجى إدخال سعر صحيح',
        englishMessage: 'Please enter a valid price',
      );
      return false;
    }

    // Offer Type
    if (offerType.value.isEmpty) {
      AppSnackbar.warning(
        'اختر نوع العرض',
        englishMessage: 'Select offer type',
      );
      return false;
    }

    // Discount-specific validation
    if (offerType.value == "1") {
      // Discount percentage
      if (offerPriceController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى إدخال نسبة الخصم',
          englishMessage: 'Please enter discount percentage',
        );
        return false;
      }

      // Validate discount is a number
      final discount = double.tryParse(offerPriceController.text.trim());
      if (discount == null || discount <= 0 || discount > 100) {
        AppSnackbar.warning(
          'يرجى إدخال نسبة خصم صحيحة (1-100)',
          englishMessage: 'Please enter valid discount (1-100)',
        );
        return false;
      }

      // Start Date
      if (offerStartDateController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى اختيار تاريخ بداية العرض',
          englishMessage: 'Please select offer start date',
        );
        return false;
      }

      // End Date
      if (offerEndDateController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى اختيار تاريخ نهاية العرض',
          englishMessage: 'Please select offer end date',
        );
        return false;
      }

      // Offer Description
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
  /// Clear all form fields
  void _clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    offerPriceController.clear();
    offerStartDateController.clear();
    offerEndDateController.clear();
    offerDescriptionController.clear();

    pickedImage.value = null;
    offerType.value = '2'; // Reset to default
    offerStatus.value = '5'; // Reset to default

    // Keep selected company
  }

  /// Manually clear form (public method)
  void clearForm() {
    _clearForm();
  }

  // ==================== Cleanup ====================
  @override
  void onClose() {
    // Dispose text controllers
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
