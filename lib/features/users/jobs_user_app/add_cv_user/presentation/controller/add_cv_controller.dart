// import 'dart:io';
//
// import 'package:app_mobile/core/model/with_out_data_model.dart';
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/request/add_cv_request.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../providers/job_provider_app/add_job_provider/domain/use_cases/job_settings_use_case.dart';
// import '../../domain/use_cases/add_cv_use_case.dart';
//
// class AddCvUserController extends GetxController {
//   final AddCvUseCase _addCvUseCase;
//   final JobSettingsUseCase _jobSettingsUseCase;
//
//   AddCvUserController(this._addCvUseCase, this._jobSettingsUseCase);
//
//   /// ✅ Loading States
//   final isPageLoading = false.obs;
//   final isActionLoading = false.obs;
//
//   /// ✅ Dropdown Lists (from settings)
//   final skillsList = <Map<String, String>>[].obs;
//   final languagesList = <Map<String, String>>[].obs;
//   final educationList = <Map<String, String>>[].obs;
//
//   /// ✅ Selected IDs
//   final selectedSkills = <String>[].obs;
//   final selectedLanguages = <String>[].obs;
//   final selectedEducation = <String>[].obs;
//
//   /// ✅ Text Controllers
//   final jobTitleController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final lat = '36'.obs;
//   final lng = '36'.obs;
//
//   /// ✅ File Pickers
//   final pickedPhoto = Rx<File?>(null);
//
//   /// 🧩 Pick image using ImagePicker
//   Future<void> pickPhoto() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       pickedPhoto.value = File(picked.path);
//     }
//   }
//
//   /// 🧠 Fetch Settings
//   Future<void> loadJobSettings() async {
//     isPageLoading.value = true;
//     final result = await _jobSettingsUseCase.execute();
//
//     result.fold(
//       (failure) => AppSnackbar.error("فشل تحميل الإعدادات"),
//       (data) {
//         skillsList.assignAll(data.skillsList ?? []);
//         languagesList.assignAll(data.languagesList ?? []);
//         educationList.assignAll(data.educationList ?? []);
//       },
//     );
//
//     isPageLoading.value = false;
//   }
//
//   /// 📤 Send CV Request
//   Future<void> addCv() async {
//     if (jobTitleController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         addressController.text.isEmpty) {
//       AppSnackbar.warning("يرجى تعبئة جميع الحقول المطلوبة");
//       return;
//     }
//
//     isActionLoading.value = true;
//
//     final request = AddCvRequest(
//       jobTitlesSeeking: jobTitleController.text,
//       email: emailController.text,
//       mobileNumber: phoneController.text,
//       locationLat: lat.value,
//       locationLng: lng.value,
//       detailedAddress: addressController.text,
//       skills: selectedSkills.join(','),
//       languages: selectedLanguages,
//       education: selectedEducation,
//       personalPhoto: pickedPhoto.value,
//     );
//
//     final result = await _addCvUseCase.execute(request);
//
//     result.fold(
//       (failure) => AppSnackbar.error("فشل في إضافة السيرة الذاتية"),
//       (success) {
//         AppSnackbar.success("تمت إضافة السيرة الذاتية بنجاح");
//         Get.back();
//       },
//     );
//
//     isActionLoading.value = false;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadJobSettings();
//   }
// }
