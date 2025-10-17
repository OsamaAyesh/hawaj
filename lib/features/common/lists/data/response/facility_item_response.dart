import 'package:json_annotation/json_annotation.dart';

part 'facility_item_response.g.dart';

@JsonSerializable()
class FacilityItemResponse {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'facility_name')
  String? facilityName;
  @JsonKey(name: 'facility_icon')
  String? facilityIcon;
  @JsonKey(name: 'facility_image')
  String? facilityImage;
  @JsonKey(name: 'facility_display_order')
  String? facilityDisplayOrder;

  FacilityItemResponse({
    this.id,
    this.facilityName,
    this.facilityIcon,
    this.facilityImage,
    this.facilityDisplayOrder,
  });

  factory FacilityItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FacilityItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityItemResponseToJson(this);
}
