import 'package:json_annotation/json_annotation.dart';

import 'offer_item_hawaj_response.dart';

part 'organization_item_hawaj_details_response.g.dart';

@JsonSerializable()
class OrganizationItemHawajDetailsResponse {
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
  final List<OfferItemHawajResponse>? offers;

  OrganizationItemHawajDetailsResponse({
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
    this.offers,
  });

  factory OrganizationItemHawajDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$OrganizationItemHawajDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrganizationItemHawajDetailsResponseToJson(this);
}
// import 'package:json_annotation/json_annotation.dart';
//
// part 'organization_item_hawaj_details_response.g.dart';
//
// @JsonSerializable()
// class OrganizationItemHawajDetailsResponse {
//   final String id;
//   @JsonKey(name: 'organization_name')
//   final String organizationName;
//   @JsonKey(name: 'organization_services')
//   final String organizationServices;
//   @JsonKey(name: 'organization_type')
//   final String organizationType;
//   @JsonKey(name: 'organization_type_lable')
//   final String organizationTypeLabel;
//   @JsonKey(name: 'organization_location_lat')
//   final String organizationLocationLat;
//   @JsonKey(name: 'organization_location_lng')
//   final String organizationLocationLng;
//   @JsonKey(name: 'organization_detailed_address')
//   final String organizationDetailedAddress;
//   @JsonKey(name: 'manager_name')
//   final String managerName;
//   @JsonKey(name: 'phone_number')
//   final String phoneNumber;
//   @JsonKey(name: 'working_hours')
//   final String workingHours;
//   @JsonKey(name: 'organization_logo')
//   final String organizationLogo;
//   @JsonKey(name: 'organization_banner')
//   final String organizationBanner;
//   @JsonKey(name: 'commercial_registration_number')
//   final String commercialRegistrationNumber;
//   @JsonKey(name: 'commercial_registration')
//   final String commercialRegistration;
//   @JsonKey(name: 'organization_status')
//   final String organizationStatus;
//   @JsonKey(name: 'organization_status_lable')
//   final String organizationStatusLabel;
//   @JsonKey(name: 'member_id')
//   final String memberId;
//   @JsonKey(name: 'member_id_lable')
//   final String memberIdLabel;
//
//   OrganizationItemHawajDetailsResponse({
//     required this.id,
//     required this.organizationName,
//     required this.organizationServices,
//     required this.organizationType,
//     required this.organizationTypeLabel,
//     required this.organizationLocationLat,
//     required this.organizationLocationLng,
//     required this.organizationDetailedAddress,
//     required this.managerName,
//     required this.phoneNumber,
//     required this.workingHours,
//     required this.organizationLogo,
//     required this.organizationBanner,
//     required this.commercialRegistrationNumber,
//     required this.commercialRegistration,
//     required this.organizationStatus,
//     required this.organizationStatusLabel,
//     required this.memberId,
//     required this.memberIdLabel,
//   });
//
//   factory OrganizationItemHawajDetailsResponse.fromJson(
//           Map<String, dynamic> json) =>
//       _$OrganizationItemHawajDetailsResponseFromJson(json);
//
//   Map<String, dynamic> toJson() =>
//       _$OrganizationItemHawajDetailsResponseToJson(this);
// }
