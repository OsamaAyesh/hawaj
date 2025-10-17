import 'package:json_annotation/json_annotation.dart';

part 'organization_type_item_response.g.dart';

@JsonSerializable()
class OrganizationTypeItemResponse {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'organization_type')
  String? organizationType;

  OrganizationTypeItemResponse({this.id, this.organizationType});

  factory OrganizationTypeItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTypeItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationTypeItemResponseToJson(this);
}
