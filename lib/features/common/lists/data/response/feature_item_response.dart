import 'package:json_annotation/json_annotation.dart';

part 'feature_item_response.g.dart';

@JsonSerializable()
class FeatureItemResponse {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'feature_name')
  String? featureName;
  @JsonKey(name: 'feature_icon')
  String? featureIcon;
  @JsonKey(name: 'feature_image')
  String? featureImage;
  @JsonKey(name: 'display_order')
  String? displayOrder;

  FeatureItemResponse({
    this.id,
    this.featureName,
    this.featureIcon,
    this.featureImage,
    this.displayOrder,
  });

  factory FeatureItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FeatureItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureItemResponseToJson(this);
}
