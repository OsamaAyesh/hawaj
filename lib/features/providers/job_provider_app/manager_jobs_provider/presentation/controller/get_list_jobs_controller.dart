import 'package:get/get.dart';

import '../../../../../../core/model/job_item_model.dart';
import '../../../../../../core/util/snack_bar.dart';
import '../../domain/use_cases/get_list_jobs_use_case.dart';

class ManagerJobsController extends GetxController {
  final GetListJobsUseCase _getListJobsUseCase;

  ManagerJobsController(this._getListJobsUseCase);

  final isLoading = false.obs;

  final availableJobs = <JobItemModel>[].obs;
  final unavailableJobs = <JobItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await _getListJobsUseCase.execute();

    result.fold(
      (failure) {
        AppSnackbar.error("فشل في جلب الوظائف");
        isLoading.value = false;
      },
      (response) {
        availableJobs.clear();
        unavailableJobs.clear();

        for (var job in response.data.data) {
          if (job.status == "1") {
            availableJobs.add(job);
          } else {
            unavailableJobs.add(job);
          }
        }

        isLoading.value = false;
      },
    );
  }
}
