import 'package:app_mobile/features/common/lists/data/mapper/field_choice_item_mapper.dart';
import 'package:app_mobile/features/common/lists/data/response/field_choices_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/field_choices_model.dart';

extension FieldChoicesMapper on FieldChoicesResponse {
  FieldChoicesModel toDomain() {
    return FieldChoicesModel(
      offer: offer?.map((e) => e.toDomain()).toList() ?? [],
      realstate: realstate?.map((e) => e.toDomain()).toList() ?? [],
      job: job?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
