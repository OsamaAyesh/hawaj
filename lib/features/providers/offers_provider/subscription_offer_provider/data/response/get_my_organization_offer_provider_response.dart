
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_data_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'get_my_organization_offer_provider_data_response.dart';

part 'get_my_organization_offer_provider_response.g.dart';

@JsonSerializable()
class  GetMyOrganizationOfferProviderResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  GetMyOrganizationOfferProviderDataResponse? data;


  GetMyOrganizationOfferProviderResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetMyOrganizationOfferProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyOrganizationOfferProviderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyOrganizationOfferProviderResponseToJson(this);
}
