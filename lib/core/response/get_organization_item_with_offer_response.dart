import 'package:json_annotation/json_annotation.dart';

import 'offer_new_item_response.dart';

part 'get_organization_item_with_offer_response.g.dart';

/// Represents an organization with its related offers.
@JsonSerializable()
class GetOrganizationItemWithOfferResponse {
  final String? id;

  @JsonKey(name: 'organization_name')
  final String? organizationName;

  @JsonKey(name: 'organization_services')
  final String? organizationServices;

  @JsonKey(name: 'organization_type')
  final String? organizationType;

  @JsonKey(name: 'organization_type_lable')
  final String? organizationTypeLabel;

  @JsonKey(name: 'organization_location_lat')
  final String? organizationLocationLat;

  @JsonKey(name: 'organization_location_lng')
  final String? organizationLocationLng;

  @JsonKey(name: 'organization_detailed_address')
  final String? organizationDetailedAddress;

  @JsonKey(name: 'manager_name')
  final String? managerName;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'working_hours')
  final String? workingHours;

  @JsonKey(name: 'organization_logo')
  final String? organizationLogo;

  @JsonKey(name: 'organization_banner')
  final String? organizationBanner;

  @JsonKey(name: 'commercial_registration_number')
  final String? commercialRegistrationNumber;

  @JsonKey(name: 'commercial_registration')
  final String? commercialRegistration;

  @JsonKey(name: 'organization_status')
  final String? organizationStatus;

  @JsonKey(name: 'organization_status_lable')
  final String? organizationStatusLabel;

  @JsonKey(name: 'member_id')
  final String? memberId;

  @JsonKey(name: 'member_id_lable')
  final String? memberIdLabel;

  @JsonKey(name: 'offers')
  final List<OfferNewItemResponse>? offers;

  GetOrganizationItemWithOfferResponse({
    this.id,
    this.organizationName,
    this.organizationServices,
    this.organizationType,
    this.organizationTypeLabel,
    this.organizationLocationLat,
    this.organizationLocationLng,
    this.organizationDetailedAddress,
    this.managerName,
    this.phoneNumber,
    this.workingHours,
    this.organizationLogo,
    this.organizationBanner,
    this.commercialRegistrationNumber,
    this.commercialRegistration,
    this.organizationStatus,
    this.organizationStatusLabel,
    this.memberId,
    this.memberIdLabel,
    this.offers,
  });

  factory GetOrganizationItemWithOfferResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GetOrganizationItemWithOfferResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetOrganizationItemWithOfferResponseToJson(this);
}
