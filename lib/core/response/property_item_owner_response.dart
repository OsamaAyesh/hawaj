import 'package:json_annotation/json_annotation.dart';

part 'property_item_owner_response.g.dart';

@JsonSerializable()
class PropertyItemOwnerResponse {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "owner_name")
  String? ownerName;

  @JsonKey(name: "mobile_number")
  String? mobileNumber;

  @JsonKey(name: "whatsapp_number")
  String? whatsappNumber;

  @JsonKey(name: "location_lat")
  String? locationLat;

  @JsonKey(name: "location_lng")
  String? locationLng;

  @JsonKey(name: "detailed_address")
  String? detailedAddress;

  @JsonKey(name: "account_type")
  String? accountType;

  @JsonKey(name: "account_type_lable")
  String? accountTypeLabel;

  @JsonKey(name: "owner_status")
  String? ownerStatus;

  @JsonKey(name: "owner_status_lable")
  String? ownerStatusLabel;

  @JsonKey(name: "member_id")
  String? memberId;

  @JsonKey(name: "member_id_lable")
  String? memberIdLabel;

  @JsonKey(name: "company_name")
  String? companyName;

  @JsonKey(name: "company_logo")
  String? companyLogo;

  @JsonKey(name: "company_brief")
  String? companyBrief;

  @JsonKey(name: "brokerage_certificate")
  String? brokerageCertificate;

  @JsonKey(name: "commercial_register")
  String? commercialRegister;

  PropertyItemOwnerResponse({
    this.id,
    this.ownerName,
    this.mobileNumber,
    this.whatsappNumber,
    this.locationLat,
    this.locationLng,
    this.detailedAddress,
    this.accountType,
    this.accountTypeLabel,
    this.ownerStatus,
    this.ownerStatusLabel,
    this.memberId,
    this.memberIdLabel,
    this.companyName,
    this.companyLogo,
    this.companyBrief,
    this.brokerageCertificate,
    this.commercialRegister,
  });

  factory PropertyItemOwnerResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyItemOwnerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyItemOwnerResponseToJson(this);
}
