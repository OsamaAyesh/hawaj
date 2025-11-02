import 'package:app_mobile/features/common/hawaj_voice/data/response/send_data_destination_response.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/response/send_data_results_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';

part 'send_data_data_response.g.dart';

@JsonSerializable()
class SendDataDataResponse {
  @JsonKey(name: ResponseConstants.q)
  String? q;

  @JsonKey(name: ResponseConstants.s)
  String? s;

  @JsonKey(name: ResponseConstants.d)
  SendDataResultsResponse? d;

  @JsonKey(name: "ai_response")
  SendDataDestinationResponse? aiResponse;

  SendDataDataResponse({
    this.q,
    this.s,
    this.d,
  });

  factory SendDataDataResponse.fromJson(Map<String, dynamic> json) =>
      _$SendDataDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendDataDataResponseToJson(this);
}
