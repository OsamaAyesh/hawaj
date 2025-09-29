import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
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
  final offerType = "".obs;
  final offerStatus = "5".obs;
  final pickedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final company = Rxn<OrganizationCompanyDailyOfferItemModel>();
  final hasCompany = false.obs;
  final errorMessage = ''.obs;

  // ===== Lifecycle =====
  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) print('[AddOffer] 🎬 onInit() called');
  }

  @override
  void onReady() {
    super.onReady();
    if (kDebugMode) print('[AddOffer] 🚀 onReady() called');
  }

  // يتم استدعاؤه في كل مرة يتم فيها إعادة بناء الشاشة
  void onScreenEnter() {
    if (kDebugMode) print('[AddOffer] 📍 Screen entered - fetching company...');
    fetchCompany();
  }

  // ===== Fetch Company =====
  Future<void> fetchCompany() async {
    isLoading.value = true;
    errorMessage.value = '';
    hasCompany.value = false;
    company.value = null;

    if (kDebugMode) print('[AddOffer] 🔄 جاري جلب بيانات الشركة...');

    try {
      final request = GetMyOrganizationSetOfferRequest(my: true);
      final Either<Failure, GetMyCompanySetOfferModel> result =
          await _getMyCompanySetOfferUseCase.execute(request);

      result.fold(
        (failure) {
          // التعامل مع الخطأ
          errorMessage.value = failure.message;
          hasCompany.value = false;
          company.value = null;

          if (kDebugMode) {
            print('[AddOffer] ❌ خطأ من السيرفر: ${failure.message}');
          }

          // التحقق من نوع الخطأ
          if (failure.message.toLowerCase().contains('not found') ||
              failure.message.toLowerCase().contains('لا توجد') ||
              failure.message == 'Unknown') {
            if (kDebugMode) print('[AddOffer] ⚠️ لم يتم العثور على شركة مسجلة');
          }
        },
        (success) {
          // التحقق من البيانات المرجعة
          if (success.data != null && success.data!.id != null) {
            company.value = success.data;
            hasCompany.value = true;
            errorMessage.value = '';

            if (kDebugMode) {
              print('[AddOffer] ✅ تم تحميل الشركة بنجاح');
              print('[AddOffer] 📋 ID: ${success.data!.id}');
              print('[AddOffer] 🏢 الاسم: ${success.data!.organization}');
            }
          } else {
            // البيانات فارغة أو null
            hasCompany.value = false;
            company.value = null;
            errorMessage.value = 'لم يتم العثور على شركة مسجلة';

            if (kDebugMode) {
              print('[AddOffer] ⚠️ البيانات المرجعة فارغة (data is null)');
            }
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'حدث خطأ غير متوقع';
      hasCompany.value = false;
      company.value = null;

      if (kDebugMode) {
        print('[AddOffer] 💥 Exception أثناء جلب البيانات: $e');
      }
    } finally {
      isLoading.value = false;

      if (kDebugMode) {
        print('[AddOffer] 🏁 انتهى التحميل - hasCompany: ${hasCompany.value}');
      }
    }
  }

  // ===== Submit Offer =====
  Future<void> submitOffer() async {
    if (!hasCompany.value || company.value == null) {
      AppSnackbar.error(
        'لم يتم جلب بيانات الشركة',
        englishMessage: 'Company information not loaded',
      );
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
        organizationId: company.value!.id,
        offerStatus: offerStatus.value.isNotEmpty ? offerStatus.value : '5',
      );

      if (kDebugMode) print('[AddOffer] 📤 جاري إرسال العرض...');

      final Either<Failure, WithOutDataModel> result =
          await _createOfferProviderUseCase.execute(request);

      result.fold(
        (failure) {
          AppSnackbar.error(
            failure.message,
            englishMessage: 'Server error: ${failure.message}',
          );
          if (kDebugMode) print('[AddOffer] ❌ فشل الإرسال: ${failure.message}');
        },
        (success) {
          AppSnackbar.success(
            'تمت إضافة العرض بنجاح',
            englishMessage: 'Offer added successfully',
          );
          if (kDebugMode) print('[AddOffer] ✅ تم إضافة العرض بنجاح');
          clearForm();
          Get.offAll(ManagerProductsOfferProviderScreen());
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'حدث خطأ غير متوقع',
        englishMessage: 'Unexpected error: $e',
      );
      if (kDebugMode) print('[AddOffer] 💥 Exception: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ===== Validation =====
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
        englishMessage: 'Please enter product price',
      );
      return false;
    }
    if (offerType.value.isEmpty) {
      AppSnackbar.warning(
        'اختر نوع العرض',
        englishMessage: 'Please select offer type',
      );
      return false;
    }
    if (offerType.value == '1') {
      if (offerPriceController.text.trim().isEmpty) {
        AppSnackbar.warning(
          'يرجى إدخال نسبة الخصم',
          englishMessage: 'Please enter discount percentage',
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

  // ===== Cleanup =====
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
