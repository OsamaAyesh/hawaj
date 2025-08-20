import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'on_boarding_item_response.g.dart';

@JsonSerializable()
class OnBoardingItemResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.mainTitle)
  String? mainTitle;
  @JsonKey(name: ResponseConstants.screenName)
  String? screenName;
  @JsonKey(name: ResponseConstants.screenOrder)
  String? screenOrder;
  @JsonKey(name: ResponseConstants.screenImage)
  String? screenImage;
  @JsonKey(name: ResponseConstants.screenDescription)
  String? screenDescription;

  OnBoardingItemResponse({
    this.id,
    this.mainTitle,
    this.screenName,
    this.screenOrder,
    this.screenImage,
    this.screenDescription,
  });

  factory OnBoardingItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnBoardingItemResponseToJson(this);
}
