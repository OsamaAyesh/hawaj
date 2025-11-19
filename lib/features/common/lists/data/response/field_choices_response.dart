import 'package:json_annotation/json_annotation.dart';

import 'field_choice_item_response.dart';

part 'field_choices_response.g.dart';

@JsonSerializable()
class FieldChoicesResponse {
  @JsonKey(name: 'offer')
  List<FieldChoiceItemResponse>? offer;

  @JsonKey(name: 'realstate')
  List<FieldChoiceItemResponse>? realstate;

  @JsonKey(name: 'job')
  List<FieldChoiceItemResponse>? job;

  FieldChoicesResponse({
    this.offer,
    this.realstate,
    this.job,
  });

  factory FieldChoicesResponse.fromJson(Map<String, dynamic> json) =>
      _$FieldChoicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FieldChoicesResponseToJson(this);
}
