import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_item_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_item_model.dart';

extension PlanItemMapper on PlanItemResponse{
  PlanItemModel toDomain(){
    return PlanItemModel(id: id.onNull(), planName: planName.onNull(),planPrice: planPrice.onNull(), planFeatures: planFeatures.onNull(), days: days.onNull(),);
  }
}