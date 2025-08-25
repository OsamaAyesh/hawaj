
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'plan_item_response.g.dart';

@JsonSerializable()
class PlanItemResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.planName)
  String? planName;
  @JsonKey(name: ResponseConstants.planPrice)
  double? planPrice;
  @JsonKey(name: ResponseConstants.planFeatures)
  String? planFeatures;
  @JsonKey(name: ResponseConstants.days)
  double? days;

  PlanItemResponse({
    this.id,
    this.planName,
    this.planPrice,
    this.planFeatures,
    this.days,
  });

  factory PlanItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlanItemResponseToJson(this);
}
