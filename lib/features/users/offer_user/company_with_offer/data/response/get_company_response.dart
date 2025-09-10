
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_offer_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'get_company_data_response.dart';
import 'get_organization_item_response.dart';

part 'get_company_response.g.dart';

@JsonSerializable()
class GetCompanyResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  GetCompanyDataResponse? data;



  GetCompanyResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetCompanyResponse.fromJson(
      Map<String, dynamic> json) =>
      _$GetCompanyResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCompanyResponseToJson(this);
}
