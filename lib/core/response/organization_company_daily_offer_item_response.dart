import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';
import '../resources/manager_strings.dart';

part 'organization_company_daily_offer_item_response.g.dart';

@JsonSerializable()
class OrganizationCompanyDailyOfferItemResponse {
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

  @JsonKey(name: ResponseConstants.organizationStatus)
  int? organizationStatus;

  OrganizationCompanyDailyOfferItemResponse({
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
    this.organizationStatus,
  });

  factory OrganizationCompanyDailyOfferItemResponse.fromJson(
      Map<String, dynamic> json) =>
      _$OrganizationCompanyDailyOfferItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrganizationCompanyDailyOfferItemResponseToJson(this);
}
