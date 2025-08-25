
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_data_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'plan_response.g.dart';

@JsonSerializable()
class  PlanResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;
  @JsonKey(name: ResponseConstants.message)
  String? message;
  @JsonKey(name: ResponseConstants.data)
  PlanDataResponse? data;


  PlanResponse({
    this.error,
    this.message,
    this.data,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlanResponseToJson(this);
}
