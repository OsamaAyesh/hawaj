import 'package:app_mobile/features/common/auth/data/response/send_otp_data_response.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'with_out_data_response.g.dart';

@JsonSerializable()
class WithOutDataResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;

  WithOutDataResponse({
    this.error,
    this.message,
  });

  factory WithOutDataResponse.fromJson(Map<String, dynamic> json) =>
      _$WithOutDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithOutDataResponseToJson(this);
}
