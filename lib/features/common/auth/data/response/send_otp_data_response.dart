
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'send_otp_data_response.g.dart';

@JsonSerializable()
class SendOtpDataResponse {
  @JsonKey(name: ResponseConstants.code)
  String? code;


  SendOtpDataResponse({
    this.code,
  });

  factory SendOtpDataResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpDataResponseToJson(this);
}
