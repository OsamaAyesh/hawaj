import 'package:json_annotation/json_annotation.dart';

part 'job_item_response.g.dart';

@JsonSerializable()
class JobItemResponse {
  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "job_title")
  final String? jobTitle;

  @JsonKey(name: "job_type")
  final String? jobType;

  @JsonKey(name: "job_type_lable")
  final String? jobTypeLabel;

  @JsonKey(name: "job_short_description")
  final String? jobShortDescription;

  @JsonKey(name: "experience_years")
  final String? experienceYears;

  @JsonKey(name: "salary")
  final String? salary;

  @JsonKey(name: "application_deadline")
  final String? applicationDeadline;

  @JsonKey(name: "work_location")
  final String? workLocation;

  @JsonKey(name: "work_location_lable")
  final String? workLocationLabel;

  @JsonKey(name: "views_count")
  final String? viewsCount;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "status_lable")
  final String? statusLabel;

  @JsonKey(name: "company_id")
  final String? companyId;

  @JsonKey(name: "company_id_lable")
  final String? companyLabel;

  @JsonKey(name: "company")
  final JobItemSubResponse? company;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  JobItemResponse({
    this.id,
    this.jobTitle,
    this.jobType,
    this.jobTypeLabel,
    this.jobShortDescription,
    this.experienceYears,
    this.salary,
    this.applicationDeadline,
    this.workLocation,
    this.workLocationLabel,
    this.viewsCount,
    this.status,
    this.statusLabel,
    this.companyId,
    this.companyLabel,
    this.company,
    this.createdAt,
    this.updatedAt,
  });

  factory JobItemResponse.fromJson(Map<String, dynamic> json) =>
      _$JobItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobItemResponseToJson(this);
}

@JsonSerializable()
class JobItemSubResponse {
  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "industry")
  final String? industry;

  @JsonKey(name: "mobile_number")
  final String? mobileNumber;

  @JsonKey(name: "location_lat")
  final String? locationLat;

  @JsonKey(name: "location_lng")
  final String? locationLng;

  @JsonKey(name: "detailed_address")
  final String? detailedAddress;

  @JsonKey(name: "company_description")
  final String? companyDescription;

  @JsonKey(name: "company_short_description")
  final String? companyShortDescription;

  @JsonKey(name: "company_logo")
  final String? companyLogo;

  @JsonKey(name: "contact_person_name")
  final String? contactPersonName;

  @JsonKey(name: "contact_person_email")
  final String? contactPersonEmail;

  @JsonKey(name: "commercial_register")
  final String? commercialRegister;

  @JsonKey(name: "activity_license")
  final String? activityLicense;

  @JsonKey(name: "member_id")
  final String? memberId;

  @JsonKey(name: "member_id_lable")
  final String? memberLabel;

  JobItemSubResponse({
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
    this.memberLabel,
  });

  factory JobItemSubResponse.fromJson(Map<String, dynamic> json) =>
      _$JobItemSubResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobItemSubResponseToJson(this);
}
