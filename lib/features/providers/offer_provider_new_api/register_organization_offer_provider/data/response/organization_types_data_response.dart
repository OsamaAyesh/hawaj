import 'package:json_annotation/json_annotation.dart';

import 'organization_type_response.dart';

part 'organization_types_data_response.g.dart';

@JsonSerializable()
class OrganizationTypesDataResponse {
  @JsonKey(name: 'organization_types')
  List<OrganizationTypeResponse>? organizationTypes;

  OrganizationTypesDataResponse({
    this.organizationTypes,
  });

  factory OrganizationTypesDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTypesDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationTypesDataResponseToJson(this);
}
