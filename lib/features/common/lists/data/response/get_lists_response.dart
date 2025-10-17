import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';
import 'get_lists_data_response.dart';

part 'get_lists_response.g.dart';

@JsonSerializable()
class GetListsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  @JsonKey(name: ResponseConstants.data)
  GetListsDataResponse? data;

  GetListsResponse({this.error, this.message, this.data});

  factory GetListsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetListsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetListsResponseToJson(this);
}
