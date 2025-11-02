import 'package:json_annotation/json_annotation.dart';

import 'get_list_jobs_data_response.dart';

part 'get_list_jobs_response.g.dart';

@JsonSerializable()
class GetListJobsResponse {
  @JsonKey(name: "error")
  final bool? error;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final GetListJobsDataResponse? data;

  GetListJobsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetListJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListJobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListJobsResponseToJson(this);
}
