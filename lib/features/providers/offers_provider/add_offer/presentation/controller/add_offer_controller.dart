import 'dart:io';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/request/create_offer_provider_request.dart';

import '../../domain/use_case/create_offer_provider_use_case.dart';

class CreateOfferProviderController extends GetxController {
  final CreateOfferProviderUseCase _createOfferProviderUseCase;

  CreateOfferProviderController(this._createOfferProviderUseCase);

  /// ======== Text Controllers =========
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final offerStartDateController = TextEditingController();
  final offerEndDateController = TextEditingController();
  final offerDescriptionController = TextEditingController();

  /// ======== Reactive Fields =========
  var offerType = "".obs; // normal | offer
  var offerStatus = "".obs; // (1,2,3,4,5)
  var pickedImage = Rx<File?>(null);

  var isLoading = false.obs;

  /// ======== Submit Offer =========
  Future<void> submitOffer({required String organizationId}) async {
    if (productPriceController.text.isEmpty || offerType.value.isEmpty) {
      AppSnackbar.warning( "يرجى تعبئة الحقول المطلوبة",
      englishMessage: "Please fill in the required fields");
      return;
    }

    isLoading.value = true;

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
      organizationId: organizationId,
      offerStatus: offerStatus.value.isNotEmpty ? offerStatus.value : null,
    );

    Either<Failure, WithOutDataModel> result =
    await _createOfferProviderUseCase.execute(request);

    result.fold(
          (failure) {
            AppSnackbar.error(failure.message,);
      },
          (success) {
       AppSnackbar.success("تمت إضافة العرض بنجاح",
       englishMessage: "Offer has been added successfully");
        clearForm();
      },
    );

    isLoading.value = false;
  }

  /// ======== Clear Form After Submit =========
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
