import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';

part 'organization_min_response.g.dart';

@JsonSerializable()
class OrganizationMinResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;

  @JsonKey(name: ResponseConstants.organization)
  String? organization;

  @JsonKey(name: ResponseConstants.organizationServices)
  String? organizationServices;

  @JsonKey(name: ResponseConstants.lat)
  String? lat;

  @JsonKey(name: ResponseConstants.lng)
  String? lng;

  @JsonKey(name: ResponseConstants.address)
  String? address;

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

  OrganizationMinResponse({
    this.id,
    this.organization,
    this.organizationServices,
    this.lat,
    this.lng,
    this.address,
    this.managerName,
    this.workingHours,
    this.organizationLogo,
    this.organizationBanner,
  });

  factory OrganizationMinResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationMinResponseToJson(this);
}
