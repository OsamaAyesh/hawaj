
import 'package:app_mobile/features/common/auth/data/response/verfiy_otp_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'verfiy_otp_response.g.dart';

@JsonSerializable()
class VerfiyOtpResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  VerfiyOtpDataResponse? data;

  VerfiyOtpResponse({
    this.error,
    this.message,
    this.data,
  });

  factory VerfiyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerfiyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerfiyOtpResponseToJson(this);
}
