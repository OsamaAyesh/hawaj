import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/organization_company_daily_offer_item_response.dart';

part 'get_company_response.g.dart';

@JsonSerializable()
class GetCompanyResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  OrganizationCompanyDailyOfferItemResponse? data;

  GetCompanyResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetCompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCompanyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCompanyResponseToJson(this);
}
