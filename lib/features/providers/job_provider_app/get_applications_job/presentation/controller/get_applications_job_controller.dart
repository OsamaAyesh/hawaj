import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:get/get.dart';

import '../../data/request/get_job_applications_request.dart';
import '../../domain/models/get_job_applications_model.dart';
import '../../domain/use_cases/get_job_applications_use_case.dart';

class GetJobApplicationsController extends GetxController {
  final GetJobApplicationsUseCase _getJobApplicationsUseCase;

  GetJobApplicationsController(this._getJobApplicationsUseCase);

  /// 🌀 حالة التحميل
  final isLoading = false.obs;

  /// 📦 بيانات الوظيفة والطلبات
  final jobApplications = Rxn<GetJobApplicationsModel>();

  /// 📍 معرف الوظيفة الحالي
  late final String jobId;

  /// 📡 تحميل البيانات
  Future<void> fetchJobApplications(String id) async {
    jobId = id;
    isLoading.value = true;

    final request = GetJobApplicationRequest(jobId: jobId);
    final result = await _getJobApplicationsUseCase.execute(request);

    result.fold(
      (failure) => AppSnackbar.error("حدث خطأ أثناء تحميل الطلبات"),
      (data) => jobApplications.value = data,
    );

    isLoading.value = false;
  }

  /// 🔁 لتحديث الصفحة بالسحب
  Future<void> refreshData() async {
    await fetchJobApplications(jobId);
  }

  /// 🧹 إغلاق الموارد عند مغادرة الصفحة
  @override
  void onClose() {
    jobApplications.value = null;
    super.onClose();
  }
}
