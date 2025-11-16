import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/get_organization_item_with_out_offer_response.dart';

part 'get_my_organization_response.g.dart';

@JsonSerializable()
class GetMyOrganizationResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.data)
  List<GetOrganizationItemWithOutOfferResponse>? data;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  GetMyOrganizationResponse({
    this.error,
    this.data,
    this.message,
  });

  factory GetMyOrganizationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyOrganizationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyOrganizationResponseToJson(this);
}
