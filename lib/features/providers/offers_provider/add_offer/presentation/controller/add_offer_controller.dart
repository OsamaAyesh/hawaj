import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/request/create_offer_provider_request.dart';
import '../../data/request/get_my_company_set_offer_request.dart';
import '../../domain/model/get_my_company_set_offer_model.dart';
import '../../domain/use_case/create_offer_provider_use_case.dart';
import '../../domain/use_case/get_my_company_set_offer_use_case.dart';

class AddOfferController extends GetxController {
  final CreateOfferProviderUseCase _createOfferProviderUseCase;
  final GetMyCompanySetOfferUseCase _getMyCompanySetOfferUseCase;

  AddOfferController(
    this._createOfferProviderUseCase,
    this._getMyCompanySetOfferUseCase,
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
  final offerType = "".obs; // 1 = خصم بالمئة , 2 = عادي
  final offerStatus = "".obs; // 1..5
  final pickedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final company = Rxn<OrganizationCompanyDailyOfferItemModel>();
  final companyError = ''.obs;

  // ===== Lifecycle =====
  @override
  void onReady() {
    super.onReady();
    fetchCompany();
  }

  // ===== Fetch Company =====
  Future<void> fetchCompany() async {
    isLoading.value = true;
    companyError.value = '';
    if (kDebugMode) print('[AddOffer] Fetching company info...');

    try {
      final request = GetMyOrganizationSetOfferRequest(my: true);
      final Either<Failure, GetMyCompanySetOfferModel> result =
          await _getMyCompanySetOfferUseCase.execute(request);

      result.fold(
        (failure) {
          companyError.value = failure.message;
          if (kDebugMode) print('[AddOffer] Error: ${failure.message}');
        },
        (success) {
          company.value = success.data;
          if (kDebugMode) {
            print('[AddOffer] Company loaded: ${success.data?.organization}');
          }
        },
      );
    } catch (e) {
      companyError.value = 'حدث خطأ: $e';
      if (kDebugMode) print('[AddOffer] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===== Submit Offer =====
  Future<void> submitOffer() async {
    if (company.value == null) {
      AppSnackbar.error('لم يتم جلب بيانات الشركة',
          englishMessage: 'Company information not loaded');
      return;
    }
    if (!_validateForm()) return;

    isSubmitting.value = true;

    try {
      final request = CreateOfferProviderRequest(
        productName: productNameController.text,
        productDescription: productDescriptionController.text,
        productImage: pickedImage.value,
        productPrice: productPriceController.text,
        offerType: offerType.value,
        offerPrice: offerPriceController.text,
        offerStartDate: offerStartDateController.text,
        offerEndDate: offerEndDateController.text,
        offerDescription: offerDescriptionController.text,
        organizationId: company.value!.id,
        offerStatus: offerStatus.value.isNotEmpty ? offerStatus.value : '5',
      );

      final Either<Failure, WithOutDataModel> result =
          await _createOfferProviderUseCase.execute(request);

      result.fold(
        (failure) => AppSnackbar.error(failure.message,
            englishMessage: 'Server error: ${failure.message}'),
        (success) {
          AppSnackbar.success('تمت إضافة العرض بنجاح',
              englishMessage: 'Offer added successfully');
          clearForm();
          Get.back();
        },
      );
    } catch (e) {
      AppSnackbar.error('حدث خطأ غير متوقع',
          englishMessage: 'Unexpected error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ===== Helpers =====
  bool _validateForm() {
    if (productNameController.text.isEmpty) {
      AppSnackbar.warning('يرجى إدخال اسم المنتج',
          englishMessage: 'Please enter product name');
      return false;
    }
    if (productDescriptionController.text.isEmpty) {
      AppSnackbar.warning('يرجى إدخال وصف المنتج',
          englishMessage: 'Please enter product description');
      return false;
    }
    if (pickedImage.value == null) {
      AppSnackbar.warning('يرجى رفع صورة',
          englishMessage: 'Please upload product image');
      return false;
    }
    if (productPriceController.text.isEmpty) {
      AppSnackbar.warning('يرجى إدخال السعر',
          englishMessage: 'Please enter product price');
      return false;
    }
    if (offerType.value.isEmpty) {
      AppSnackbar.warning('اختر نوع العرض',
          englishMessage: 'Please select offer type');
      return false;
    }
    if (offerType.value == '1') {
      if (offerPriceController.text.isEmpty ||
          offerStartDateController.text.isEmpty ||
          offerEndDateController.text.isEmpty) {
        AppSnackbar.warning('أكمل بيانات الخصم',
            englishMessage: 'Complete discount details');
        return false;
      }
    }
    return true;
  }

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
    offerStatus.value = '';
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
