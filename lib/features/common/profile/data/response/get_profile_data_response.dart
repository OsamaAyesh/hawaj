
import 'package:json_annotation/json_annotation.dart';
import '../../../../../constants/response_constants/response_constants.dart';

part 'get_profile_data_response.g.dart';

@JsonSerializable()
class GetProfileDataResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;
  @JsonKey(name: ResponseConstants.name)
  String? name;
  @JsonKey(name: ResponseConstants.avatar)
  String? avatar;
  @JsonKey(name: ResponseConstants.phone)
  String? phone;
  @JsonKey(name: ResponseConstants.createdAt)
  String? createdAt;
  @JsonKey(name: ResponseConstants.updatedAt)
  String? updatedAt;

  GetProfileDataResponse({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory GetProfileDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileDataResponseToJson(this);
}
