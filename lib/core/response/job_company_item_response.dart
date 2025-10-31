import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';

part 'job_company_item_response.g.dart';

@JsonSerializable()
class JobCompanyItemResponse {
  @JsonKey(name: ResponseConstants.id)
  String? id;

  @JsonKey(name: ResponseConstants.companyName)
  String? companyName;

  @JsonKey(name: ResponseConstants.industry)
  String? industry;

  @JsonKey(name: ResponseConstants.mobileNumber)
  String? mobileNumber;

  @JsonKey(name: ResponseConstants.locationLat)
  String? locationLat;

  @JsonKey(name: ResponseConstants.locationLng)
  String? locationLng;

  @JsonKey(name: ResponseConstants.detailedAddress)
  String? detailedAddress;

  @JsonKey(name: ResponseConstants.companyDescription)
  String? companyDescription;

  @JsonKey(name: ResponseConstants.companyShortDescription)
  String? companyShortDescription;

  @JsonKey(name: ResponseConstants.companyLogo)
  String? companyLogo;

  @JsonKey(name: ResponseConstants.contactPersonName)
  String? contactPersonName;

  @JsonKey(name: ResponseConstants.contactPersonEmail)
  String? contactPersonEmail;

  @JsonKey(name: ResponseConstants.commercialRegister)
  String? commercialRegister;

  @JsonKey(name: ResponseConstants.activityLicense)
  String? activityLicense;

  @JsonKey(name: ResponseConstants.memberId)
  String? memberId;

  @JsonKey(name: ResponseConstants.memberIdLable)
  String? memberIdLable;

  JobCompanyItemResponse({
    this.id,
    this.companyName,
    this.industry,
    this.mobileNumber,
    this.locationLat,
    this.locationLng,
    this.detailedAddress,
    this.companyDescription,
    this.companyShortDescription,
    this.companyLogo,
    this.contactPersonName,
    this.contactPersonEmail,
    this.commercialRegister,
    this.activityLicense,
    this.memberId,
    this.memberIdLable,
  });

  factory JobCompanyItemResponse.fromJson(Map<String, dynamic> json) =>
      _$JobCompanyItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobCompanyItemResponseToJson(this);
}
