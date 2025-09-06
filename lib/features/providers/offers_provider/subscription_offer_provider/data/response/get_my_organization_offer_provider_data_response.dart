
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/orgnization_company_daily_offer_item_response.dart';

part 'get_my_organization_offer_provider_data_response.g.dart';

@JsonSerializable()
class GetMyOrganizationOfferProviderDataResponse {
  @JsonKey(name: ResponseConstants.data)
  List<OrganizationCompanyDailyOfferItemResponse>? data;


  GetMyOrganizationOfferProviderDataResponse({
    this.data,
  });

  factory GetMyOrganizationOfferProviderDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyOrganizationOfferProviderDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyOrganizationOfferProviderDataResponseToJson(this);
}
