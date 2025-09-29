//
// import 'package:json_annotation/json_annotation.dart';
//
// import '../../../../../../constants/response_constants/response_constants.dart';
// import 'offer_user_data_response.dart';
//
// part 'offer_user_response.g.dart';
//
// @JsonSerializable()
// class OfferUserResponse {
//   @JsonKey(name: ResponseConstants.error)
//   bool? error;
//   @JsonKey(name: ResponseConstants.message)
//   String? message;
//   @JsonKey(name: ResponseConstants.data)
//   OfferUserDataResponse? data;
//
//
//
//   OfferUserResponse({
//     this.error,
//     this.message,
//     this.data,
//   });
//
//   factory OfferUserResponse.fromJson(Map<String, dynamic> json) =>
//       _$OfferUserResponseFromJson(json);
//
//   Map<String, dynamic> toJson() => _$OfferUserResponseToJson(this);
// }
