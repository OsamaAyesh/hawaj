import 'package:app_mobile/features/common/auth/data/response/send_otp_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'send_otp_response.g.dart';

@JsonSerializable()
class SendOtpResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.data)
  SendOtpDataResponse? data;
  @JsonKey(name: ResponseConstants.message)
  String? message;

  SendOtpResponse({
    this.error,
    this.data,
    this.message,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}
