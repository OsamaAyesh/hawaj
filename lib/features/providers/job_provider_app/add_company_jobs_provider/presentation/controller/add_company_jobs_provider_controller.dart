import 'dart:io';

import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/request/add_company_jobs_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/use_cases/add_company_jobs_use_case.dart';

class AddCompanyJobsController extends GetxController {
  final AddCompanyJobsUseCase addCompanyJobsUseCase;

  AddCompanyJobsController(this.addCompanyJobsUseCase);

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
  final locationController = TextEditingController(); // For map field display
  final locationLat = ''.obs;
  final locationLng = ''.obs;

  // ==== Files ====
  final companyLogo = Rx<File?>(null);
  final commercialRegister = Rx<File?>(null);
  final activityLicense = Rx<File?>(null);

  // ==== UI States ====
  final isLoading = false.obs;

  /// Update company location from map picker
  void updateCompanyLocation(double lat, double lng) {
    locationLat.value = lat.toString();
    locationLng.value = lng.toString();
    locationController.text = "$lat, $lng";
  }

  /// Validate fields
  bool validateForm() {
    if (companyNameController.text.isEmpty ||
        industryController.text.isEmpty ||
        mobileController.text.isEmpty ||
        detailedAddressController.text.isEmpty ||
        companyDescriptionController.text.isEmpty ||
        contactPersonNameController.text.isEmpty ||
        contactPersonEmailController.text.isEmpty ||
        locationLat.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please fill all required fields and select company location.",
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  /// Submit company data
  Future<void> submitCompany() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final request = AddCompanyJobsRequest(
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

      final result = await addCompanyJobsUseCase.execute(request);

      result.fold(
        (Failure failure) {
          AppSnackbar.error(
            failure.message ?? "An unknown error occurred.",
          );
        },
        (WithOutDataModel success) {
          AppSnackbar.success(
            "Company registered successfully!",
          );
          clearForm();
        },
      );
    } catch (e) {
      AppSnackbar.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear inputs
  void clearForm() {
    companyNameController.clear();
    industryController.clear();
    mobileController.clear();
    detailedAddressController.clear();
    companyDescriptionController.clear();
    shortDescriptionController.clear();
    contactPersonNameController.clear();
    contactPersonEmailController.clear();
    locationController.clear();
    locationLat.value = '';
    locationLng.value = '';
    companyLogo.value = null;
    commercialRegister.value = null;
    activityLicense.value = null;
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
