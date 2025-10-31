import 'package:get/get.dart';

import '../../../../../../core/model/job_company_item_model.dart';
import '../../domain/use_cases/get_list_company_jobs_use_case.dart';

class GetListCompanyJobsController extends GetxController {
  final GetListCompanyJobsUseCase _useCase;

  GetListCompanyJobsController(this._useCase);

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxList<JobCompanyItemModel> companies = <JobCompanyItemModel>[].obs;

  Future<void> fetchCompanies({bool isRefresh = false}) async {
    if (!isRefresh) isLoading.value = true;
    errorMessage.value = '';

    final result = await _useCase.execute();

    result.fold(
      (failure) => errorMessage.value = failure.message,
      (data) {
        companies.value = data.data.data;
      },
    );

    isLoading.value = false;
  }

  Future<void> refreshCompanies() async {
    await fetchCompanies(isRefresh: true);
  }

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }
}
