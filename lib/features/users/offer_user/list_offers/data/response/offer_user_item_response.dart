
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'offer_user_item_response.g.dart';

@JsonSerializable()
class OfferUserItemResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.productName)
  String? productName;
  @JsonKey(name: ResponseConstants.productDescription)
  String? productDescription;
  @JsonKey(name: ResponseConstants.productImages)
  List<String>? productImages;
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


  OfferUserItemResponse({
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

  factory OfferUserItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferUserItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferUserItemResponseToJson(this);
}
