import 'package:app_mobile/core/response/job_company_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'get_list_company_jobs_data_response.g.dart';

@JsonSerializable()
class GetListCompanyJobsDataResponse {
  @JsonKey(name: ResponseConstants.data)
  List<JobCompanyItemResponse>? data;

  GetListCompanyJobsDataResponse({
    this.data,
  });

  factory GetListCompanyJobsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListCompanyJobsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListCompanyJobsDataResponseToJson(this);
}
