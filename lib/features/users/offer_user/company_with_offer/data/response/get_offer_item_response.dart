
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'get_offer_item_response.g.dart';

@JsonSerializable()
class GetOfferItemResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.productName)
  String? productName;
  @JsonKey(name: ResponseConstants.productDescription)
  String? productDescription;
  @JsonKey(name: ResponseConstants.productImages)
  String? productImages;
  @JsonKey(name: ResponseConstants.productPrice)
  double? productPrice;
  @JsonKey(name: ResponseConstants.offerType)
  int? offerType;
  @JsonKey(name: ResponseConstants.offerPrice)
  double? offerPrice;
  @JsonKey(name: ResponseConstants.offerStartDate)
  String? offerStartDate;
  @JsonKey(name: ResponseConstants.offerEndDate)
  String? offerEndDate;
  @JsonKey(name: ResponseConstants.offerDescription)
  String? offerDescription;
  @JsonKey(name: ResponseConstants.organizationId)
  int? organizationId;
  @JsonKey(name: ResponseConstants.offerStatus)
  int? offerStatus;


  GetOfferItemResponse({
    this.id,
    this.productName,
    this.productDescription,
    this.productImages,
    this.productPrice,
    this.offerType,
    this.offerPrice,
    this.offerStartDate,
    this.offerEndDate,
    this.offerDescription,
    this.organizationId,
    this.offerStatus,
  });

  factory GetOfferItemResponse.fromJson(
      Map<String, dynamic> json) =>
      _$GetOfferItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetOfferItemResponseToJson(this);
}
