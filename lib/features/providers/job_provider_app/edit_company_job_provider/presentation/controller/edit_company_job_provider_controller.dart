import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/job_company_item_model.dart';
import '../../data/request/edit_company_jobs_provider_request.dart';
import '../../domain/use_cases/edit_company_jobs_provider_use_case.dart';

class EditCompanyJobProviderController extends GetxController {
  final EditCompanyJobsProviderUseCase editCompanyJobsUseCase;
  final JobCompanyItemModel? company; // ✅ Nullable model

  EditCompanyJobProviderController(
    this.editCompanyJobsUseCase, {
    this.company,
  });

  // ==== Text Controllers ====
  final companyNameController = TextEditingController();
  final industryController = TextEditingController();
  final mobileController = TextEditingController();
  final detailedAddressController = TextEditingController();
  final companyDescriptionController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final contactPersonNameController = TextEditingController();
  final contactPersonEmailController = TextEditingController();

  // ==== Location ====
  final locationController = TextEditingController();
  final locationLat = ''.obs;
  final locationLng = ''.obs;

  // ==== Files ====
  final companyLogo = Rx<File?>(null);
  final commercialRegister = Rx<File?>(null);
  final activityLicense = Rx<File?>(null);
  String? companyId;

  // ==== UI State ====
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (company != null) {
      _fillDataFromModel();
    }
  }

  /// تعبئة البيانات من الموديل إن وجد
  void _fillDataFromModel() {
    companyNameController.text = company?.companyName ?? '';
    industryController.text = company?.industry ?? '';
    mobileController.text = company?.mobileNumber ?? '';
    detailedAddressController.text = company?.detailedAddress ?? '';
    companyDescriptionController.text = company?.companyDescription ?? '';
    shortDescriptionController.text = company?.companyShortDescription ?? '';
    contactPersonNameController.text = company?.contactPersonName ?? '';
    contactPersonEmailController.text = company?.contactPersonEmail ?? '';
    locationController.text =
        "${company?.locationLat ?? ''}, ${company?.locationLng ?? ''}";
    locationLat.value = company?.locationLat ?? '';
    locationLng.value = company?.locationLng ?? '';
  }

  /// تحديث الموقع من خريطة الاختيار
  void updateCompanyLocation(double lat, double lng) {
    locationLat.value = lat.toString();
    locationLng.value = lng.toString();
    locationController.text = "$lat, $lng";
  }

  bool validateForm() {
    if (companyNameController.text.isEmpty ||
        industryController.text.isEmpty ||
        mobileController.text.isEmpty ||
        detailedAddressController.text.isEmpty ||
        companyDescriptionController.text.isEmpty ||
        contactPersonNameController.text.isEmpty ||
        contactPersonEmailController.text.isEmpty) {
      AppSnackbar.error("يرجى تعبئة جميع الحقول المطلوبة.");
      return false;
    }
    return true;
  }

  Future<void> updateCompany() async {
    if (!validateForm()) return;
    try {
      isLoading.value = true;

      final request = EditCompanyJobsProviderRequest(
        id: companyId,
        companyName: companyNameController.text.trim(),
        industry: industryController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        locationLat: locationLat.value,
        locationLng: locationLng.value,
        detailedAddress: detailedAddressController.text.trim(),
        companyDescription: companyDescriptionController.text.trim(),
        contactPersonName: contactPersonNameController.text.trim(),
        contactPersonEmail: contactPersonEmailController.text.trim(),
        companyLogo: companyLogo.value,
        commercialRegister: commercialRegister.value,
        activityLicense: activityLicense.value,
      );

      final result = await editCompanyJobsUseCase.execute(request);

      result.fold(
        (Failure failure) =>
            AppSnackbar.error(failure.message ?? "فشل تعديل بيانات الشركة."),
        (WithOutDataModel success) {
          AppSnackbar.success("تم تعديل بيانات الشركة بنجاح.");
          Get.back(result: true);
        },
      );
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    industryController.dispose();
    mobileController.dispose();
    detailedAddressController.dispose();
    companyDescriptionController.dispose();
    contactPersonNameController.dispose();
    contactPersonEmailController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
