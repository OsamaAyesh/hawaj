import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/models/get_list_company_jobs_data_model.dart';

class GetListCompanyJobsModel {
  bool error;

  String message;

  GetListCompanyJobsDataModel data;

  GetListCompanyJobsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
