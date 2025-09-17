import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/request/create_offer_provider_request.dart';
import '../../data/request/get_my_company_set_offer_request.dart';
import '../../domain/model/get_my_company_set_offer_model.dart';
import '../../domain/use_case/create_offer_provider_use_case.dart';
import '../../domain/use_case/get_my_company_set_offer_use_case.dart';

class CreateOfferProviderController extends GetxController {
  final CreateOfferProviderUseCase _createOfferProviderUseCase;
  final GetMyCompanySetOfferUseCase _getMyCompanySetOfferUseCase;

  CreateOfferProviderController(
    this._createOfferProviderUseCase,
    this._getMyCompanySetOfferUseCase,
  );

  /// ===== Text Controllers =====
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final offerPriceController = TextEditingController(); // نسبة الخصم
  final offerStartDateController = TextEditingController();
  final offerEndDateController = TextEditingController();
  final offerDescriptionController = TextEditingController();

  /// ===== Reactive Fields =====
  var offerType = "".obs; // "1" = خصم بالمئة, "2" = عادي
  var offerStatus = "".obs; // 1..5
  var pickedImage = Rx<File?>(null);
  var isLoading = false.obs;

  /// ===== Company Info =====
  var company = Rxn<OrganizationCompanyDailyOfferItemModel>();
  var companyError = ''.obs;

  /// ===== Init =====
  @override
  void onInit() {
    super.onInit();
    fetchCompany(); // جلب بيانات الشركة عند فتح الشاشة
  }

  /// ===== Fetch Company =====
  Future<void> fetchCompany() async {
    isLoading.value = true;
    companyError.value = '';
    try {
      final request = GetMyOrganizationSetOfferRequest(
        my: true,
      );
      final Either<Failure, GetMyCompanySetOfferModel> result =
          await _getMyCompanySetOfferUseCase.execute(request);

      result.fold(
        (failure) => companyError.value = failure.message,
        (success) => company.value = success.data,
      );
    } catch (e) {
      companyError.value = "خطأ في جلب بيانات الشركة: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Submit Offer =====
  Future<void> submitOffer() async {
    // تحقق من وجود الشركة أولاً
    if (company.value == null) {
      AppSnackbar.error("لم يتم جلب بيانات الشركة بعد",
          englishMessage: "Company information not loaded yet");
      return;
    }

    // تحقق من الحقول الأساسية
    if (productPriceController.text.isEmpty || offerType.value.isEmpty) {
      AppSnackbar.warning("يرجى تعبئة الحقول المطلوبة",
          englishMessage: "Please fill in the required fields");
      return;
    }

    // تحقق من نسبة الخصم عند اختيار خصم بالمئة
    if (offerType.value == "1" && offerPriceController.text.isEmpty) {
      AppSnackbar.warning("يرجى إدخال نسبة الخصم",
          englishMessage: "Please enter discount percentage");
      return;
    }

    isLoading.value = true;

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
        // استخدام ID الشركة الفعلي
        offerStatus: offerStatus.value.isNotEmpty ? offerStatus.value : null,
      );

      final Either<Failure, WithOutDataModel> result =
          await _createOfferProviderUseCase.execute(request);

      result.fold(
        (failure) => AppSnackbar.error(
          failure.message,
          englishMessage: "Server error: ${failure.message}",
        ),
        (success) {
          AppSnackbar.success("تمت إضافة العرض بنجاح",
              englishMessage: "Offer has been added successfully");
          clearForm();
        },
      );
    } catch (e) {
      AppSnackbar.error(
        "حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.",
        englishMessage: "Unexpected error: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ===== Clear Form =====
  void clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    offerPriceController.clear();
    offerStartDateController.clear();
    offerEndDateController.clear();
    offerDescriptionController.clear();
    pickedImage.value = null;
    offerType.value = "";
    offerStatus.value = "";
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
