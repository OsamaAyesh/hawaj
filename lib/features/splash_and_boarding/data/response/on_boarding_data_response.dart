
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';
import 'on_boarding_item_response.dart';

part 'on_boarding_data_response.g.dart';

@JsonSerializable()
class OnBoardingDataResponse {
  @JsonKey(name: ResponseConstants.data)
  List<OnBoardingItemResponse>? data;


  OnBoardingDataResponse({
    this.data,
  });

  factory OnBoardingDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnBoardingDataResponseToJson(this);
}
