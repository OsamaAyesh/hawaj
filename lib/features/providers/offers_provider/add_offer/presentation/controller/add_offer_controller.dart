import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../../offer_provider_new_api/common/domain/models/get_my_company_model.dart';
import '../../../../offer_provider_new_api/common/domain/use_cases/get_my_company_use_case.dart';
import '../../../manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
import '../../data/request/create_offer_provider_request.dart';
import '../../domain/use_case/create_offer_provider_use_case.dart';

class AddOfferController extends GetxController {
  final CreateOfferProviderUseCase _createOfferProviderUseCase;
  final GetMyCompanyUseCase _getMyCompanyUseCase;

  AddOfferController(
    this._createOfferProviderUseCase,
    this._getMyCompanyUseCase,
  );

  // ===== Text Controllers =====
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final offerStartDateController = TextEditingController();
  final offerEndDateController = TextEditingController();
  final offerDescriptionController = TextEditingController();

  // ===== Reactive State =====
  final offerType = "".obs;
  final offerStatus = "5".obs;
  final pickedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // ===== Companies =====
  final companiesList = <GetOrganizationItemWithOfferModel>[].obs;
  final selectedCompany = Rxn<GetOrganizationItemWithOfferModel>();

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  // ===== Fetch All Companies =====
  Future<void> fetchCompanies() async {
    isLoading.value = true;
    companiesList.clear();
    selectedCompany.value = null;
    errorMessage.value = '';

    if (kDebugMode) print('[AddOffer] Fetching companies...');

    try {
      final Either<Failure, GetMyCompanyModel> result =
          await _getMyCompanyUseCase.execute();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          AppSnackbar.error(failure.message);
          if (kDebugMode) print('[AddOffer] ❌ Error: ${failure.message}');
        },
        (success) {
          if (success.data.isNotEmpty) {
            companiesList.assignAll(success.data);
            selectedCompany.value = companiesList.first;
            if (kDebugMode) {
              print('[AddOffer] ✅ Loaded ${companiesList.length} companies');
            }
          } else {
            errorMessage.value = 'لا توجد شركات متاحة';
            AppSnackbar.warning(errorMessage.value);
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل الشركات';
      AppSnackbar.error(errorMessage.value);
      if (kDebugMode) print('[AddOffer] 💥 Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===== Submit Offer =====
  Future<void> submitOffer() async {
    if (selectedCompany.value == null) {
      AppSnackbar.warning('يرجى اختيار الشركة قبل إرسال العرض');
      return;
    }

    if (!_validateForm()) return;

    isSubmitting.value = true;

    try {
      final request = CreateOfferProviderRequest(
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
        // ✅ Fix: id is String → int
        offerStatus: offerStatus.value.isNotEmpty ? offerStatus.value : '5',
      );

      final Either<Failure, WithOutDataModel> result =
          await _createOfferProviderUseCase.execute(request);

      result.fold(
        (failure) => AppSnackbar.error(failure.message),
        (success) {
          AppSnackbar.success('تمت إضافة العرض بنجاح');
          clearForm();
          Get.offAll(() => const ManagerProductsOfferProviderScreen());
        },
      );
    } catch (e) {
      AppSnackbar.error('حدث خطأ غير متوقع أثناء الإرسال');
      if (kDebugMode) print('[AddOffer] 💥 Exception: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ===== Validation =====
  bool _validateForm() {
    if (productNameController.text.trim().isEmpty) {
      AppSnackbar.warning('يرجى إدخال اسم المنتج');
      return false;
    }
    if (productDescriptionController.text.trim().isEmpty) {
      AppSnackbar.warning('يرجى إدخال وصف المنتج');
      return false;
    }
    if (pickedImage.value == null) {
      AppSnackbar.warning('يرجى رفع صورة المنتج');
      return false;
    }
    if (productPriceController.text.trim().isEmpty) {
      AppSnackbar.warning('يرجى إدخال السعر');
      return false;
    }
    if (offerType.value.isEmpty) {
      AppSnackbar.warning('يرجى اختيار نوع العرض');
      return false;
    }
    if (offerType.value == '1') {
      if (offerPriceController.text.trim().isEmpty) {
        AppSnackbar.warning('يرجى إدخال نسبة الخصم');
        return false;
      }
      if (offerStartDateController.text.trim().isEmpty ||
          offerEndDateController.text.trim().isEmpty) {
        AppSnackbar.warning('يرجى تحديد تاريخ البداية والنهاية');
        return false;
      }
    }
    return true;
  }

  // ===== Clear Form =====
  void clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    offerPriceController.clear();
    offerStartDateController.clear();
    offerEndDateController.clear();
    offerDescriptionController.clear();
    pickedImage.value = null;
    offerType.value = '';
    offerStatus.value = '5';
  }

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
