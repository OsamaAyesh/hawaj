import 'package:json_annotation/json_annotation.dart';

part 'property_plan_item_response.g.dart';

@JsonSerializable()
class PropertyPlanItemResponse {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'plan_price')
  String? planPrice;
  @JsonKey(name: 'plan_duration_days')
  String? planDurationDays;
  @JsonKey(name: 'plan_properties_limit')
  String? planPropertiesLimit;
  @JsonKey(name: 'plan_description')
  String? planDescription;
  @JsonKey(name: 'plan_status')
  String? planStatus;
  @JsonKey(name: 'plan_status_lable')
  String? planStatusLable;

  PropertyPlanItemResponse({
    this.id,
    this.planName,
    this.planPrice,
    this.planDescription,
    this.planDurationDays,
    this.planPropertiesLimit,
    this.planStatus,
    this.planStatusLable,
  });

  factory PropertyPlanItemResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyPlanItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyPlanItemResponseToJson(this);
}
