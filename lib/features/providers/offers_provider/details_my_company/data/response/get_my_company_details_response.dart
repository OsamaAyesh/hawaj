import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/organization_company_daily_offer_item_response.dart';

part 'get_my_company_details_response.g.dart';

@JsonSerializable()
class GetMyCompanyDetailsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  OrganizationCompanyDailyOfferItemResponse? data;

  GetMyCompanyDetailsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetMyCompanyDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyCompanyDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyCompanyDetailsResponseToJson(this);
}
