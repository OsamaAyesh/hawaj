import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/property_plan_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/property_plan_item_model.dart';

extension PropertyPlanItemMapper on PropertyPlanItemResponse {
  PropertyPlanItemModel toDomain() {
    return PropertyPlanItemModel(
      id: id.onNull(),
      planName: planName.onNull(),
      planPrice: planPrice.onNull(),
      planDescription: planDescription.onNull(),
      planDurationDays: planDurationDays.onNull(),
      planPropertiesLimit: planPropertiesLimit.onNull(),
      planStatus: planStatus.onNull(),
      planStatusLable: planStatusLable.onNull(),
    );
  }
}
