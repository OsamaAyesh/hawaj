import 'package:json_annotation/json_annotation.dart';

part 'offer_new_item_response.g.dart';

/// Represents a single product offer with detailed information
/// including product details, offer details, and organization linkage.
@JsonSerializable()
class OfferNewItemResponse {
  final String? id;

  @JsonKey(name: 'product_name')
  final String? productName;

  @JsonKey(name: 'product_description')
  final String? productDescription;

  @JsonKey(name: 'product_images')
  final String? productImages;

  @JsonKey(name: 'product_price')
  final String? productPrice;

  @JsonKey(name: 'offer_type')
  final String? offerType;

  @JsonKey(name: 'offer_type_lable')
  final String? offerTypeLabel;

  @JsonKey(name: 'offer_price')
  final String? offerPrice;

  @JsonKey(name: 'offer_start_date')
  final String? offerStartDate;

  @JsonKey(name: 'offer_end_date')
  final String? offerEndDate;

  @JsonKey(name: 'offer_description')
  final String? offerDescription;

  @JsonKey(name: 'organization_id')
  final String? organizationId;

  @JsonKey(name: 'organization_id_lable')
  final String? organizationIdLabel;

  @JsonKey(name: 'offer_status')
  final String? offerStatus;

  @JsonKey(name: 'offer_status_lable')
  final String? offerStatusLabel;

  final String? images;
  final String? keywords;

  OfferNewItemResponse({
    this.id,
    this.productName,
    this.productDescription,
    this.productImages,
    this.productPrice,
    this.offerType,
    this.offerTypeLabel,
    this.offerPrice,
    this.offerStartDate,
    this.offerEndDate,
    this.offerDescription,
    this.organizationId,
    this.organizationIdLabel,
    this.offerStatus,
    this.offerStatusLabel,
    this.images,
    this.keywords,
  });

  factory OfferNewItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferNewItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferNewItemResponseToJson(this);
}
