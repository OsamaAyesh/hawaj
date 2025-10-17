import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/offer_plan_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/offer_plan_item_model.dart';

extension OfferPlanItemMapper on OfferPlanItemResponse {
  OfferPlanItemModel toDomain() {
    return OfferPlanItemModel(
      id: id.onNull(),
      planName: planName.onNull(),
      planPrice: planPrice.onNull(),
      days: days.onNull(),
      planFeatures: planFeatures.onNull(),
    );
  }
}
