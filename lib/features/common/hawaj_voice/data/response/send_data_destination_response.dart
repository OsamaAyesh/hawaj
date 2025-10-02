import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';

part 'send_data_destination_response.g.dart';

@JsonSerializable()
class SendDataDestinationResponse {
  @JsonKey(name: ResponseConstants.section)
  String? section;

  @JsonKey(name: ResponseConstants.screen)
  String? screen;

  // @JsonKey(name: ResponseConstants.parameters)
  // Map<String, dynamic>? parameters;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  @JsonKey(name: ResponseConstants.mp3)
  String? mp3;

  SendDataDestinationResponse({
    this.section,
    this.screen,
    // this.parameters,
    this.message,
    this.mp3,
  });

  factory SendDataDestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$SendDataDestinationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendDataDestinationResponseToJson(this);
}
