
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'plan_item_response.g.dart';

@JsonSerializable()
class PlanDataResponse {
  @JsonKey(name: ResponseConstants.data)
  List<PlanItemResponse>? data;


  PlanDataResponse({
    this.data,
  });

  factory PlanDataResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlanDataResponseToJson(this);
}
