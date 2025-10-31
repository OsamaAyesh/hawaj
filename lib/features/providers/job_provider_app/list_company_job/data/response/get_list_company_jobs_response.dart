import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'get_list_company_jobs_data_response.dart';

part 'get_list_company_jobs_response.g.dart';

@JsonSerializable()
class GetListCompanyJobsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  @JsonKey(name: ResponseConstants.data)
  GetListCompanyJobsDataResponse? data;

  GetListCompanyJobsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetListCompanyJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListCompanyJobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListCompanyJobsResponseToJson(this);
}
