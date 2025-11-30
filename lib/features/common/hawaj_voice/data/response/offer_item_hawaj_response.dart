import 'package:json_annotation/json_annotation.dart';

part 'offer_item_hawaj_response.g.dart';

@JsonSerializable()
class OfferItemHawajResponse {
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

  @JsonKey(name: 'offer_price')
  final String? offerPrice;

  @JsonKey(name: 'offer_start_date')
  final String? offerStartDate;

  @JsonKey(name: 'offer_end_date')
  final String? offerEndDate;

  @JsonKey(name: 'offer_description')
  final String? offerDescription;

  final String? images;

  OfferItemHawajResponse({
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
    this.images,
  });

  factory OfferItemHawajResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferItemHawajResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferItemHawajResponseToJson(this);
}
