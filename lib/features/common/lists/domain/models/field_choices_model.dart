import 'package:app_mobile/features/common/lists/domain/models/field_choice_item_model.dart';

class FieldChoicesModel {
  List<FieldChoiceItemModel> offer;

  List<FieldChoiceItemModel> realstate;

  List<FieldChoiceItemModel> job;

  FieldChoicesModel({
    required this.offer,
    required this.realstate,
    required this.job,
  });
}
