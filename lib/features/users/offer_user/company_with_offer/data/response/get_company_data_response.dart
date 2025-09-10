
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_offer_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'get_organization_item_response.dart';

part 'get_company_data_response.g.dart';

@JsonSerializable()
class GetCompanyDataResponse {
  @JsonKey(name: ResponseConstants.data)
  GetOrganizationItemResponse? data;
  @JsonKey(name: ResponseConstants.offers)
  List<GetOfferItemResponse>? offers;



  GetCompanyDataResponse({
    this.data,
    this.offers,
  });

  factory GetCompanyDataResponse.fromJson(
      Map<String, dynamic> json) =>
      _$GetCompanyDataResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCompanyDataResponseToJson(this);
}
