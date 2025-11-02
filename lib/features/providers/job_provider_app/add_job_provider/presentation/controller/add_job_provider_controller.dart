import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/add_job_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/use_cases/job_settings_use_case.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/use_cases/get_list_company_jobs_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJobsController extends GetxController {
  final AddJobUseCase _addJobUseCase;
  final JobSettingsUseCase _jobSettingsUseCase;
  final GetListCompanyJobsUseCase _getListCompanyJobsUseCase;

  AddJobsController(
    this._addJobUseCase,
    this._jobSettingsUseCase,
    this._getListCompanyJobsUseCase,
  );

  /// Loaders
  final isPageLoading = false.obs;
  final isActionLoading = false.obs;

  /// Dropdown Data
  final companies = <Map<String, String>>[].obs;
  final jobTypes = <Map<String, String>>[].obs;
  final workLocations = <Map<String, String>>[].obs;
  final jobStatuses = <Map<String, String>>[].obs;
  final educationDegrees = <Map<String, String>>[].obs;
  final languages = <Map<String, String>>[].obs;
  final skills = <Map<String, String>>[].obs;
  final qualifications = <Map<String, String>>[].obs;

  /// Selected
  final selectedCompanyId = RxnString();
  final selectedJobType = RxnString();
  final selectedWorkLocation = RxnString();
  final selectedJobStatus = RxnString();
  final selectedEducation = RxnString();
  final selectedLanguage = RxnString();
  final selectedSkill = RxnString();
  final selectedQualification = RxnString();

  /// Text Controllers
  final jobTitleController = TextEditingController();
  final shortDescController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final deadlineController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isPageLoading.value = true;
    await Future.wait([
      _fetchJobSettings(),
      _fetchCompanyList(),
    ]);
    isPageLoading.value = false;
  }

  /// ✅ Fetch Job Settings
  Future<void> _fetchJobSettings() async {
    final result = await _jobSettingsUseCase.execute();

    result.fold(
      (failure) => AppSnackbar.error('فشل في تحميل إعدادات الوظائف'),
      (settings) {
        // ⚙️ تعبئة القوائم بعد المابر
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

        languages.assignAll(settings.data.languages
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());

        skills.assignAll(settings.data.skills
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());

        qualifications.assignAll(settings.data.qualifications
            .map((e) => {'id': e.id.toString(), 'label': e.name})
            .toList());
      },
    );
  }

  /// ✅ Fetch Companies
  Future<void> _fetchCompanyList() async {
    final result = await _getListCompanyJobsUseCase.execute();

    result.fold(
      (failure) => AppSnackbar.error('فشل في تحميل الشركات'),
      (response) {
        companies.assignAll(
          response.data.data
              .map((e) => {'id': e.id, 'label': e.companyName})
              .toList(),
        );
      },
    );
  }

  /// ✅ Validate Fields
  bool validateFields() {
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
    return true;
  }

  /// ✅ Add Job Action
  Future<void> addJob() async {
    if (!validateFields()) return;
    isActionLoading.value = true;

    // ⬇️ إرسال البيانات إلى السيرفر
    // TODO: build AddJobRequest here (كما في كودك السابق)

    isActionLoading.value = false;
  }

  @override
  void onClose() {
    jobTitleController.dispose();
    shortDescController.dispose();
    experienceController.dispose();
    salaryController.dispose();
    deadlineController.dispose();
    super.onClose();
  }
}
