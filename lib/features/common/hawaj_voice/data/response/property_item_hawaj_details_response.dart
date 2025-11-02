import 'package:json_annotation/json_annotation.dart';

part 'property_item_hawaj_details_response.g.dart';

@JsonSerializable()
class PropertyItemHawajDetailsResponse {
  final String id;

  @JsonKey(name: 'property_subject')
  final String propertySubject;

  @JsonKey(name: 'property_type')
  final String propertyType;

  @JsonKey(name: 'property_type_lable')
  final String propertyTypeLabel;

  @JsonKey(name: 'operation_type')
  final String operationType;

  @JsonKey(name: 'operation_type_lable')
  final String operationTypeLabel;

  @JsonKey(name: 'advertiser_role')
  final String advertiserRole;

  @JsonKey(name: 'advertiser_role_lable')
  final String advertiserRoleLabel;

  @JsonKey(name: 'sale_type')
  final String saleType;

  @JsonKey(name: 'sale_type_lable')
  final String saleTypeLabel;

  final String keywords;

  @JsonKey(name: 'propertyowner_id')
  final String propertyOwnerId;

  @JsonKey(name: 'propertyowner_id_lable')
  final String propertyOwnerName;

  final String lat;
  final String lng;

  @JsonKey(name: 'property_detailed_address')
  final String propertyDetailedAddress;

  final String price;

  @JsonKey(name: 'area_sqm')
  final String areaSqm;

  @JsonKey(name: 'commission_percentage')
  final String commissionPercentage;

  @JsonKey(name: 'usage_type')
  final String usageType;

  @JsonKey(name: 'usage_type_lable')
  final String usageTypeLabel;

  @JsonKey(name: 'property_description')
  final String propertyDescription;

  @JsonKey(name: 'feature_ids')
  final String featureIds;

  @JsonKey(name: 'facility_ids')
  final String facilityIds;

  @JsonKey(name: 'visit_days')
  final String visitDays;

  @JsonKey(name: 'visit_time_from')
  final String visitTimeFrom;

  @JsonKey(name: 'visit_time_to')
  final String visitTimeTo;

  @JsonKey(name: 'property_images')
  final String propertyImages;

  @JsonKey(name: 'property_videos')
  final String propertyVideos;

  @JsonKey(name: 'deed_document')
  final String deedDocument;

  final String images;

  @JsonKey(name: 'property_status')
  final String propertyStatus;

  @JsonKey(name: 'property_status_lable')
  final String propertyStatusLabel;

  PropertyItemHawajDetailsResponse({
    required this.id,
    required this.propertySubject,
    required this.propertyType,
    required this.propertyTypeLabel,
    required this.operationType,
    required this.operationTypeLabel,
    required this.advertiserRole,
    required this.advertiserRoleLabel,
    required this.saleType,
    required this.saleTypeLabel,
    required this.keywords,
    required this.propertyOwnerId,
    required this.propertyOwnerName,
    required this.lat,
    required this.lng,
    required this.propertyDetailedAddress,
    required this.price,
    required this.areaSqm,
    required this.commissionPercentage,
    required this.usageType,
    required this.usageTypeLabel,
    required this.propertyDescription,
    required this.featureIds,
    required this.facilityIds,
    required this.visitDays,
    required this.visitTimeFrom,
    required this.visitTimeTo,
    required this.propertyImages,
    required this.propertyVideos,
    required this.deedDocument,
    required this.images,
    required this.propertyStatus,
    required this.propertyStatusLabel,
  });

  factory PropertyItemHawajDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$PropertyItemHawajDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PropertyItemHawajDetailsResponseToJson(this);
}
