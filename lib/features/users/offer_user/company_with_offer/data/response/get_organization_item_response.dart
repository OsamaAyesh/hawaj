
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'get_organization_item_response.g.dart';

@JsonSerializable()
class GetOrganizationItemResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;

  @JsonKey(name: ResponseConstants.organizationName)
  String? organizationName;

  @JsonKey(name: ResponseConstants.organizationServices)
  String? organizationServices;

  @JsonKey(name: ResponseConstants.organizationType)
  int? organizationType;

  @JsonKey(name: ResponseConstants.organizationLocation)
  String? organizationLocation;

  @JsonKey(name: ResponseConstants.organizationDetailedAddress)
  String? organizationDetailedAddress;

  @JsonKey(name: ResponseConstants.managerName)
  String? managerName;

  @JsonKey(name: ResponseConstants.phoneNumber)
  String? phoneNumber;

  @JsonKey(name: ResponseConstants.workingHours)
  String? workingHours;

  @JsonKey(name: ResponseConstants.organizationLogo)
  String? organizationLogo;

  @JsonKey(name: ResponseConstants.organizationBanner)
  String? organizationBanner;

  @JsonKey(name: ResponseConstants.commercialRegistrationNumber)
  String? commercialRegistrationNumber;

  @JsonKey(name: ResponseConstants.commercialRegistration)
  String? commercialRegistration;


  GetOrganizationItemResponse({
    this.id,
    this.organizationName,
    this.organizationServices,
    this.organizationType,
    this.organizationLocation,
    this.organizationDetailedAddress,
    this.managerName,
    this.phoneNumber,
    this.workingHours,
    this.organizationLogo,
    this.organizationBanner,
    this.commercialRegistrationNumber,
    this.commercialRegistration,
  });

  factory GetOrganizationItemResponse.fromJson(
      Map<String, dynamic> json) =>
      _$GetOrganizationItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetOrganizationItemResponseToJson(this);
}
