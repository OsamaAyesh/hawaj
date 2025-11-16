import 'package:json_annotation/json_annotation.dart';

part 'organization_type_response.g.dart';

@JsonSerializable()
class OrganizationTypeResponse {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'organization_type')
  String? organizationType;

  OrganizationTypeResponse({
    this.id,
    this.organizationType,
  });

  factory OrganizationTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationTypeResponseToJson(this);
}
