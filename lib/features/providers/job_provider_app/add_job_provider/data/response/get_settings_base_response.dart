// /
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/job_settings_response.dart';

part 'get_settings_base_response.g.dart';

@JsonSerializable()
class GetSettingsBaseResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  @JsonKey(name: ResponseConstants.data)
  JobSettingsResponse? data;

  GetSettingsBaseResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetSettingsBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSettingsBaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetSettingsBaseResponseToJson(this);
}
