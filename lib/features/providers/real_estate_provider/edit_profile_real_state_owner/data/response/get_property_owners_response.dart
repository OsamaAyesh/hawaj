import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/property_item_owner_response.dart';

part 'get_property_owners_response.g.dart';

@JsonSerializable()
class GetPropertyOwnersResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  List<PropertyItemOwnerResponse>? data;

  GetPropertyOwnersResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetPropertyOwnersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPropertyOwnersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetPropertyOwnersResponseToJson(this);
}
