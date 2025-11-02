import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/add_job_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/job_settings_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/use_cases/get_list_company_jobs_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/request/add_job_request.dart';

class AddJobsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AddJobUseCase _addJobUseCase;
  final JobSettingsUseCase _jobSettingsUseCase;
  final GetListCompanyJobsUseCase _getListCompanyJobsUseCase;

  AddJobsController(
    this._addJobUseCase,
    this._jobSettingsUseCase,
    this._getListCompanyJobsUseCase,
  );

  /// 🌀 Loaders
  final isPageLoading = false.obs;
  final isActionLoading = false.obs;

  /// 📋 DropDown lists
  final companies = <Map<String, String>>[].obs;
  final jobTypes = <Map<String, String>>[].obs;
  final workLocations = <Map<String, String>>[].obs;
  final jobStatuses = <Map<String, String>>[].obs;
  final educationDegrees = <Map<String, String>>[].obs;
  final languagesList = <Map<String, String>>[].obs;
  final skillsList = <Map<String, String>>[].obs;
  final qualificationsList = <Map<String, String>>[].obs;

  /// 🎯 Selected
  final selectedCompanyId = RxnString();
  final selectedJobType = RxnString();
  final selectedWorkLocation = RxnString();
  final selectedJobStatus = RxnString();

  /// 🧠 Text Controllers
  final jobTitleController = TextEditingController();
  final shortDescController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final deadlineController = TextEditingController();

  /// 🎓 Multi selections
  final selectedLanguages = <String>[].obs;
  final selectedSkills = <String>[].obs;
  final selectedQualifications = <String>[].obs;

  /// 🚀 Init
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isPageLoading.value = true;
    await Future.wait([
      _fetchJobSettings(),
      _fetchCompanies(),
    ]);
    isPageLoading.value = false;
  }

  /// ⚙️ إعدادات الوظائف
  Future<void> _fetchJobSettings() async {
    final result = await _jobSettingsUseCase.execute();

    result.fold(
      (failure) => AppSnackbar.error("فشل في تحميل إعدادات الوظائف"),
      (settings) {
        jobTypes.assignAll(settings.data.jobTypes
            .map((e) => {'id': e.value, 'label': e.label})
            .toList());
        workLocations.assignAll(settings.data.workLocations
            .map((e) => {'id': e.value, 'label': e.label})
            .toList());
        jobStatuses.assignAll(settings.data.jobStatuses
            .map((e) => {'id': e.value, 'label': e.label})
            .toList());
        educationDegrees.assignAll(settings.data.educationDegrees
            .map((e) => {'id': e.value, 'label': e.label})
            .toList());
        languagesList.assignAll(settings.data.languages
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());
        skillsList.assignAll(settings.data.skills
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());
        qualificationsList.assignAll(settings.data.qualifications
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());
      },
    );
  }

  /// 🏢 الشركات
  Future<void> _fetchCompanies() async {
    final result = await _getListCompanyJobsUseCase.execute();

    result.fold(
      (failure) => AppSnackbar.error('فشل في تحميل الشركات'),
      (response) {
        companies.assignAll(response.data.data
            .map((e) => {'id': e.id, 'label': e.companyName})
            .toList());
      },
    );
  }

  /// ✅ تحقق من الحقول
  bool validate() {
    if (jobTitleController.text.isEmpty) {
      AppSnackbar.warning('يرجى إدخال عنوان الوظيفة');
      return false;
    }
    if (selectedCompanyId.value == null) {
      AppSnackbar.warning('يرجى اختيار الشركة');
      return false;
    }
    if (selectedJobType.value == null) {
      AppSnackbar.warning('يرجى اختيار نوع الوظيفة');
      return false;
    }
    if (selectedWorkLocation.value == null) {
      AppSnackbar.warning('يرجى اختيار مكان العمل');
      return false;
    }
    if (experienceController.text.isEmpty) {
      AppSnackbar.warning('يرجى إدخال عدد سنوات الخبرة');
      return false;
    }
    return true;
  }

  /// 🚀 إضافة وظيفة
  Future<void> addJob() async {
    if (!validate()) return;

    isActionLoading.value = true;

    final request = AddJobRequest(
      jobTitle: jobTitleController.text,
      jobType: selectedJobType.value!,
      jobShortDescription: shortDescController.text,
      experienceYears: experienceController.text,
      salary: salaryController.text,
      applicationDeadline: deadlineController.text,
      workLocation: selectedWorkLocation.value!,
      companyId: selectedCompanyId.value!,
      languages: selectedLanguages,
      skills: selectedSkills,
      qualifications: selectedQualifications,
      status: selectedJobStatus.value ?? "1",
    );

    final result = await _addJobUseCase.execute(request);

    result.fold(
      (failure) => AppSnackbar.error('فشل في إضافة الوظيفة'),
      (success) {
        AppSnackbar.success('✅ تمت إضافة الوظيفة بنجاح');
        clearForm();
      },
    );

    isActionLoading.value = false;
  }

  /// 🧹 إعادة تعيين
  void clearForm() {
    jobTitleController.clear();
    shortDescController.clear();
    experienceController.clear();
    salaryController.clear();
    deadlineController.clear();
    selectedCompanyId.value = null;
    selectedJobType.value = null;
    selectedWorkLocation.value = null;
    selectedJobStatus.value = null;
    selectedLanguages.clear();
    selectedSkills.clear();
    selectedQualifications.clear();
  }

  /// 🧩 التخلص من الموارد بأمان عند مغادرة الشاشة فقط
  @override
  void onClose() {
    try {
      jobTitleController.dispose();
      shortDescController.dispose();
      experienceController.dispose();
      salaryController.dispose();
      deadlineController.dispose();
    } catch (_) {}
    super.onClose();
  }
}
