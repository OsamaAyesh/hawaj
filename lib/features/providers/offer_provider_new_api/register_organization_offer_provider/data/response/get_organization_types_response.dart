import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'organization_types_data_response.dart';

part 'get_organization_types_response.g.dart';

@JsonSerializable()
class GetOrganizationTypesResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.data)
  OrganizationTypesDataResponse? data;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  GetOrganizationTypesResponse({
    this.error,
    this.data,
    this.message,
  });

  factory GetOrganizationTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOrganizationTypesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrganizationTypesResponseToJson(this);
}
