import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/organization_company_daily_offer_item_response.dart';

part 'get_organizations_response.g.dart';

@JsonSerializable()
class GetOrganizationsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  List<OrganizationCompanyDailyOfferItemResponse>? data;

  GetOrganizationsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetOrganizationsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOrganizationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrganizationsResponseToJson(this);
}
