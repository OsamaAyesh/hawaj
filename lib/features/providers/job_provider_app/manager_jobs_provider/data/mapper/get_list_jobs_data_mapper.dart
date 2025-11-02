import 'package:app_mobile/core/mapper/job_item_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/response/get_list_jobs_data_response.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/models/get_list_jobs_data_model.dart';

extension GetListJobsDataMapper on GetListJobsDataResponse {
  GetListJobsDataModel toDomain() {
    return GetListJobsDataModel(
      data: data?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
