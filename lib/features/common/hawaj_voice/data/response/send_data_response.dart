import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';
import 'send_data_data_response.dart';

part 'send_data_response.g.dart';

@JsonSerializable()
class SendDataResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.data)
  SendDataDataResponse? data;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  SendDataResponse({
    this.error,
    this.data,
    this.message,
  });

  factory SendDataResponse.fromJson(Map<String, dynamic> json) =>
      _$SendDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendDataResponseToJson(this);
}
