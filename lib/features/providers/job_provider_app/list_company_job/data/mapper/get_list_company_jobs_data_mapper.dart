import 'package:app_mobile/core/mapper/job_company_item_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/response/get_list_company_jobs_data_response.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/models/get_list_company_jobs_data_model.dart';

extension GetListCompanyJobsDataMapper on GetListCompanyJobsDataResponse {
  GetListCompanyJobsDataModel toDomain() {
    return GetListCompanyJobsDataModel(
      data: data!.map((e) => e.toDomain()).toList(),
    );
  }
}
