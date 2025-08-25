
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'verfiy_otp_data_response.g.dart';

@JsonSerializable()
class VerfiyOtpDataResponse {
  @JsonKey(name: ResponseConstants.token)
  String? token;


  VerfiyOtpDataResponse({
    this.token,
  });

  factory VerfiyOtpDataResponse.fromJson(Map<String, dynamic> json) =>
      _$VerfiyOtpDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerfiyOtpDataResponseToJson(this);
}
