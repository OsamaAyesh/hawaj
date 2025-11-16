import 'dart:io';

import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/providers/offer_provider_new/common/domain/models/get_my_company_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/model/get_organization_item_with_offer_model.dart';
import '../../../../offer_provider_new/common/domain/use_cases/get_my_company_use_case.dart';
import '../../data/request/add_offer_new_request.dart';
import '../../domain/use_cases/add_offer_new_use_case.dart';

class AddOfferNewController extends GetxController {
  final AddOfferNewUseCase _addOfferUseCase;
  final GetMyCompanyUseCase _getMyCompanyUseCase;

  AddOfferNewController(
    this._addOfferUseCase,
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
  final pickedImage = Rx<File?>(null);
  final offerType = "".obs;
  final offerStatus = "5".obs;

  final isLoading = false.obs; // لجلب الشركات
  final isSubmitting = false.obs; // لإرسال الطلب

  final companies = <GetOrganizationItemWithOfferModel>[].obs;
  final selectedCompany = Rxn<GetOrganizationItemWithOfferModel>();

  // ===== Lifecycle =====
  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }

  // ===== Get Companies =====
  Future<void> getCompanies() async {
    isLoading.value = true;
    try {
      final Either<Failure, GetMyCompanyModel> result =
          await _getMyCompanyUseCase.execute();

      result.fold(
        (failure) {
          AppSnackbar.error(failure.message);
          if (kDebugMode)
            print('[AddOfferNew] ❌ فشل جلب الشركات: ${failure.message}');
        },
        (data) {
          companies.value = data.data;
          if (companies.isEmpty) {
            AppSnackbar.warning("لا توجد مؤسسات حالياً");
          } else {
            selectedCompany.value = companies.first;
          }
          if (kDebugMode)
            print('[AddOfferNew] ✅ تم جلب ${companies.length} مؤسسة');
        },
      );
    } catch (e) {
      AppSnackbar.error('حدث خطأ غير متوقع أثناء جلب المؤسسات');
      if (kDebugMode) print('[AddOfferNew] 💥 Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===== Submit Offer =====
  Future<void> submitOffer() async {
    if (selectedCompany.value == null) {
      AppSnackbar.warning('يرجى اختيار مؤسسة قبل المتابعة');
      return;
    }

    if (!_validateForm()) return;

    isSubmitting.value = true;

    try {
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
          AppSnackbar.error(failure.message);
          if (kDebugMode)
            print('[AddOfferNew] ❌ فشل الإرسال: ${failure.message}');
        },
        (success) {
          AppSnackbar.success('تمت إضافة العرض بنجاح');
          clearForm();
          if (kDebugMode) print('[AddOfferNew] ✅ العرض أُضيف بنجاح');
        },
      );
    } catch (e) {
      AppSnackbar.error('حدث خطأ غير متوقع أثناء الإرسال');
      if (kDebugMode) print('[AddOfferNew] 💥 Exception: $e');
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
      AppSnackbar.warning('اختر نوع العرض');
      return false;
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
