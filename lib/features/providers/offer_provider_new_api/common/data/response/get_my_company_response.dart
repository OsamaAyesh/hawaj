import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/get_organization_item_with_offer_response.dart';

part 'get_my_company_response.g.dart';

@JsonSerializable()
class GetMyCompanyResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  List<GetOrganizationItemWithOfferResponse>? data;

  GetMyCompanyResponse({this.error, this.message, this.data});

  factory GetMyCompanyResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyCompanyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyCompanyResponseToJson(this);
}
