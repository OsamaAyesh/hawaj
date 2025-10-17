import 'package:json_annotation/json_annotation.dart';

part 'field_choice_item_response.g.dart';

@JsonSerializable()
class FieldChoiceItemResponse {
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'choice')
  String? choice;
  @JsonKey(name: 'label')
  String? label;

  FieldChoiceItemResponse({this.name, this.choice, this.label});

  factory FieldChoiceItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FieldChoiceItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FieldChoiceItemResponseToJson(this);
}
