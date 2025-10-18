import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import '../../../../../../core/response/real_estate_item_response.dart';

part 'get_my_real_estates_response.g.dart';

@JsonSerializable()
class GetMyRealEstatesResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  List<RealEstateItemResponse>? data;

  GetMyRealEstatesResponse({
    this.error,
    this.message,
  });

  factory GetMyRealEstatesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyRealEstatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyRealEstatesResponseToJson(this);
}
