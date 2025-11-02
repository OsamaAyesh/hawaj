import 'package:json_annotation/json_annotation.dart';

import '../../../../../../core/response/job_item_response.dart';

part 'get_list_jobs_data_response.g.dart';

@JsonSerializable()
class GetListJobsDataResponse {
  @JsonKey(name: "data")
  final List<JobItemResponse>? data;

  GetListJobsDataResponse({
    this.data,
  });

  factory GetListJobsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListJobsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListJobsDataResponseToJson(this);
}
