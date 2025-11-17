import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/get_organization_item_with_offer_response.dart';

part 'get_my_organization_details_response.g.dart';

@JsonSerializable()
class GetMyOrganizationDetailsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  GetOrganizationItemWithOfferResponse? data;

  GetMyOrganizationDetailsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetMyOrganizationDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GetMyOrganizationDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetMyOrganizationDetailsResponseToJson(this);
}
