// update_offer_controller.dart
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
import '../../data/request/update_offer_request.dart';
import '../../domain/use_cases/update_offer_use_case.dart';

class UpdateOfferController extends GetxController {
  final UpdateOfferUseCase _updateOfferUseCase;
  final GetMyCompanyUseCase _getMyCompanyUseCase;
  final dynamic initialOfferData; // Store the offer model

  UpdateOfferController(
    this._updateOfferUseCase,
    this._getMyCompanyUseCase,
    this.initialOfferData,
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
  final existingImageUrl = ''.obs; // Store existing image URL

  final offerType = "2".obs;
  final offerStatus = "5".obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final companies = <GetOrganizationItemWithOfferModel>[].obs;
  final selectedCompany = Rxn<GetOrganizationItemWithOfferModel>();

  String offerId = ''; // Store offer ID

  // ==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    _fetchCompanies();
    _initializeFormWithOfferData();
  }

  // ==================== Initialize Form ====================
  /// Initialize form fields with existing offer data
  void _initializeFormWithOfferData() {
    if (initialOfferData == null) return;

    try {
      // Extract data from offer model
      offerId = initialOfferData.id?.toString() ?? '';
      productNameController.text = initialOfferData.offerName ?? '';
      productDescriptionController.text =
          initialOfferData.productDescription ?? '';
      productPriceController.text = initialOfferData.productPrice ?? '';
      offerPriceController.text = initialOfferData.offerPrice ?? '';
      offerStartDateController.text = initialOfferData.offerStartDate ?? '';
      offerEndDateController.text = initialOfferData.offerEndDate ?? '';
      offerDescriptionController.text = initialOfferData.offerDescription ?? '';

      // Set offer type and status
      offerType.value = initialOfferData.offerType ?? '2';
      offerStatus.value = initialOfferData.offerStatus ?? '5';

      // Store existing image URL
      existingImageUrl.value = initialOfferData.productImages ?? '';

      if (kDebugMode) {
        debugPrint('✅ [UpdateOffer] Form initialized with offer data');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ [UpdateOffer] Failed to initialize form: $e');
      }
    }
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
                '❌ [UpdateOffer] Failed to fetch companies: ${failure.message}');
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
            // Try to find and select the company associated with this offer
            if (initialOfferData?.organizationId != null) {
              final matchingCompany = companies.firstWhereOrNull(
                (company) =>
                    company.id == initialOfferData.organizationId.toString(),
              );
              selectedCompany.value = matchingCompany ?? companies.first;
            } else {
              selectedCompany.value = companies.first;
            }
          }

          if (kDebugMode) {
            debugPrint('✅ [UpdateOffer] Loaded ${companies.length} companies');
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع أثناء جلب المؤسسات',
        englishMessage: 'Unexpected error loading organizations',
      );

      if (kDebugMode) {
        debugPrint('💥 [UpdateOffer] Exception: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry fetching companies
  void retryFetchCompanies() {
    _fetchCompanies();
  }

  // ==================== Update Offer ====================
  /// Submit offer update
  Future<void> updateOffer() async {
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
      final request = UpdateOfferRequest(
        offerId: offerId,
        productName: productNameController.text.trim(),
        productDescription: productDescriptionController.text.trim(),
        productImage: pickedImage.value,
        // Only if new image selected
        productPrice: productPriceController.text.trim(),
        offerType: offerType.value,
        offerPrice: offerPriceController.text.trim().isNotEmpty
            ? offerPriceController.text.trim()
            : null,
        offerStartDate: offerStartDateController.text.trim().isNotEmpty
            ? offerStartDateController.text.trim()
            : null,
        offerEndDate: offerEndDateController.text.trim().isNotEmpty
            ? offerEndDateController.text.trim()
            : null,
        offerDescription: offerDescriptionController.text.trim().isNotEmpty
            ? offerDescriptionController.text.trim()
            : null,
        organizationId: int.parse(selectedCompany.value!.id),
        offerStatus: offerStatus.value,
      );

      // Execute request
      final Either<Failure, WithOutDataModel> result =
          await _updateOfferUseCase.execute(request);

      // Handle result
      result.fold(
        (failure) {
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Failed to update offer',
          );

          if (kDebugMode) {
            debugPrint('❌ [UpdateOffer] Failed to update: ${failure.message}');
          }
        },
        (success) {
          if (!success.error) {
            AppSnackbar.success(
              'تم تحديث العرض بنجاح',
              englishMessage: 'Offer updated successfully',
            );

            // Navigate back
            Get.back(result: true); // Pass true to indicate success

            if (kDebugMode) {
              debugPrint('✅ [UpdateOffer] Offer updated successfully');
            }
          } else {
            AppSnackbar.error(success.message);
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع أثناء التحديث',
        englishMessage: 'Unexpected error during update',
      );

      if (kDebugMode) {
        debugPrint('💥 [UpdateOffer] Exception: $e');
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
