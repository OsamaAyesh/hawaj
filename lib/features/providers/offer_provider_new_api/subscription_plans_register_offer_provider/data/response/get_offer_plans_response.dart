import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';
import 'offer_plan_response.dart';

part 'get_offer_plans_response.g.dart';

@JsonSerializable()
class GetOfferPlansResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.data)
  List<OfferPlanResponse>? data;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  GetOfferPlansResponse({
    this.error,
    this.data,
    this.message,
  });

  factory GetOfferPlansResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOfferPlansResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOfferPlansResponseToJson(this);
}
