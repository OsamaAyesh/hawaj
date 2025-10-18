import 'package:json_annotation/json_annotation.dart';

part 'real_estate_item_response.g.dart';

@JsonSerializable()
class RealEstateItemResponse {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "property_subject")
  String? propertySubject;

  @JsonKey(name: "property_type")
  String? propertyType;

  @JsonKey(name: "property_type_lable")
  String? propertyTypeLabel;

  @JsonKey(name: "operation_type")
  String? operationType;

  @JsonKey(name: "operation_type_lable")
  String? operationTypeLabel;

  @JsonKey(name: "advertiser_role")
  String? advertiserRole;

  @JsonKey(name: "advertiser_role_lable")
  String? advertiserRoleLabel;

  @JsonKey(name: "sale_type")
  String? saleType;

  @JsonKey(name: "sale_type_lable")
  String? saleTypeLabel;

  @JsonKey(name: "keywords")
  String? keywords;

  @JsonKey(name: "propertyowner_id")
  String? propertyOwnerId;

  @JsonKey(name: "propertyowner_id_lable")
  String? propertyOwnerIdLabel;

  @JsonKey(name: "lat")
  String? lat;

  @JsonKey(name: "lng")
  String? lng;

  @JsonKey(name: "property_detailed_address")
  String? propertyDetailedAddress;

  @JsonKey(name: "price")
  String? price;

  @JsonKey(name: "area_sqm")
  String? areaSqm;

  @JsonKey(name: "commission_percentage")
  String? commissionPercentage;

  @JsonKey(name: "usage_type")
  String? usageType;

  @JsonKey(name: "usage_type_lable")
  String? usageTypeLabel;

  @JsonKey(name: "property_description")
  String? propertyDescription;

  @JsonKey(name: "feature_ids")
  String? featureIds;

  @JsonKey(name: "facility_ids")
  String? facilityIds;

  @JsonKey(name: "visit_days")
  String? visitDays;

  @JsonKey(name: "visit_time_from")
  String? visitTimeFrom;

  @JsonKey(name: "visit_time_to")
  String? visitTimeTo;

  @JsonKey(name: "property_images")
  String? propertyImages;

  @JsonKey(name: "property_videos")
  String? propertyVideos;

  @JsonKey(name: "deed_document")
  String? deedDocument;

  RealEstateItemResponse({
    this.id,
    this.propertySubject,
    this.propertyType,
    this.propertyTypeLabel,
    this.operationType,
    this.operationTypeLabel,
    this.advertiserRole,
    this.advertiserRoleLabel,
    this.saleType,
    this.saleTypeLabel,
    this.keywords,
    this.propertyOwnerId,
    this.propertyOwnerIdLabel,
    this.lat,
    this.lng,
    this.propertyDetailedAddress,
    this.price,
    this.areaSqm,
    this.commissionPercentage,
    this.usageType,
    this.usageTypeLabel,
    this.propertyDescription,
    this.featureIds,
    this.facilityIds,
    this.visitDays,
    this.visitTimeFrom,
    this.visitTimeTo,
    this.propertyImages,
    this.propertyVideos,
    this.deedDocument,
  });

  factory RealEstateItemResponse.fromJson(Map<String, dynamic> json) =>
      _$RealEstateItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RealEstateItemResponseToJson(this);
}
