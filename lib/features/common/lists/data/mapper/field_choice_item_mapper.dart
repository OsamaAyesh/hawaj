import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/field_choice_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/field_choice_item_model.dart';

extension FieldChoiceItemMapper on FieldChoiceItemResponse {
  FieldChoiceItemModel toDomain() {
    return FieldChoiceItemModel(
      name: name.onNull(),
      choice: choice.onNull(),
      label: label.onNull(),
    );
  }
}
