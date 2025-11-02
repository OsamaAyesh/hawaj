import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/mapper/get_list_jobs_data_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/response/get_list_jobs_response.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/models/get_list_jobs_model.dart';

extension GetListJobsMapper on GetListJobsResponse {
  GetListJobsModel toDomain() {
    return GetListJobsModel(
      data: data!.toDomain(),
      error: error.onNull(),
      message: message.onNull(),
    );
  }
}
