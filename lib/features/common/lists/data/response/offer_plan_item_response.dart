import 'package:json_annotation/json_annotation.dart';

part 'offer_plan_item_response.g.dart';

@JsonSerializable()
class OfferPlanItemResponse {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'plan_price')
  String? planPrice;
  @JsonKey(name: 'days')
  String? days;
  @JsonKey(name: 'plan_features')
  String? planFeatures;

  OfferPlanItemResponse({
    this.id,
    this.planName,
    this.planPrice,
    this.days,
    this.planFeatures,
  });

  factory OfferPlanItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferPlanItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPlanItemResponseToJson(this);
}
