import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/offer_plan_model.dart';
import '../response/offer_plan_response.dart';

extension OfferPlanMapper on OfferPlanResponse {
  OfferPlanModel toDomain() {
    return OfferPlanModel(
      id: id.onNull(),
      planName: planName.onNull(),
      planPrice: planPrice.onNull(),
      days: days.onNull(),
      planFeatures: planFeatures.onNull(),
    );
  }
}
