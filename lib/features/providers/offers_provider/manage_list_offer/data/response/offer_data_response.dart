
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'offer_data_response.g.dart';

@JsonSerializable()
class OfferDataResponse {
  @JsonKey(name: ResponseConstants.data)
  List<OfferItemResponse>? data;



  OfferDataResponse({
    this.data,
  });

  factory OfferDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OfferDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferDataResponseToJson(this);
}
