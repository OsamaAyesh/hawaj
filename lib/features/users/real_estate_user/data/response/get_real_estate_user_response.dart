import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../core/response/real_estate_item_response.dart';

part 'get_real_estate_user_response.g.dart';

@JsonSerializable()
class GetRealEstateUserResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  RealEstateItemResponse? data;

  GetRealEstateUserResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetRealEstateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRealEstateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetRealEstateUserResponseToJson(this);
}
