

import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';
import 'on_boarding_data_response.dart';

part 'on_boarding_response.g.dart';

@JsonSerializable()
class OnBoardingResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  OnBoardingDataResponse? data;

  OnBoardingResponse({
    this.error,
    this.message,
    this.data,
  });

  factory OnBoardingResponse.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnBoardingResponseToJson(this);
}
