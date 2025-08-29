
import 'package:app_mobile/features/common/profile/data/response/get_profile_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'get_profile_response.g.dart';

@JsonSerializable()
class GetProfileResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  GetProfileDataResponse? data;

  GetProfileResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);
}
