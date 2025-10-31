import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/mapper/get_list_company_jobs_data_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/models/get_list_company_jobs_model.dart';

import '../response/get_list_company_jobs_response.dart';

extension GetListCompanyJobsMapper on GetListCompanyJobsResponse {
  GetListCompanyJobsModel toDomain() {
    return GetListCompanyJobsModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
