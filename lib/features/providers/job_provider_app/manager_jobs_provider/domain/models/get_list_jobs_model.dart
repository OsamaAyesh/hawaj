import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/models/get_list_jobs_data_model.dart';

class GetListJobsModel {
  bool error;
  String message;
  GetListJobsDataModel data;

  GetListJobsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
