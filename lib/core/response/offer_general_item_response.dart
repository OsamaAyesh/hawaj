import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';
import 'organization_min_response.dart';

part 'offer_general_item_response.g.dart';

@JsonSerializable()
class OfferGeneralItemResponse {
  @JsonKey(name: ResponseConstants.offerId)
  int? offerId;

  @JsonKey(name: ResponseConstants.offerName)
  String? offerName;

  @JsonKey(name: ResponseConstants.offerPrice)
  double? offerPrice;

  @JsonKey(name: ResponseConstants.offerDescription)
  String? offerDescription;

  @JsonKey(name: ResponseConstants.offerImage)
  String? offerImage;
  @JsonKey(name: ResponseConstants.offerPercentage)
  double? offerPercentage;

  @JsonKey(name: ResponseConstants.offerType)
  int? offerType;
  @JsonKey(name: ResponseConstants.offerTypeLabel)
  String? offerTypeLabel;

  @JsonKey(name: ResponseConstants.offerStartDate)
  String? offerStartDate;
  @JsonKey(name: ResponseConstants.offerEndDate)
  String? offerEndDate;
  @JsonKey(name: ResponseConstants.offerStatus)
  int? offerStatus;
  @JsonKey(name: ResponseConstants.offerStatusLabel)
  String? offerStatusLabel;

  @JsonKey(name: ResponseConstants.organization)
  OrganizationMinResponse? organization;

  OfferGeneralItemResponse(
      {this.offerId, this.offerName, this.offerPrice, this.offerDescription});

  factory OfferGeneralItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferGeneralItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferGeneralItemResponseToJson(this);
}
