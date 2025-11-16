import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/data/mapper/offer_plan_mapper.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/data/response/get_offer_plans_response.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/domain/models/get_offer_plans_model.dart';

extension GetOfferPlansMapper on GetOfferPlansResponse {
  GetOfferPlansModel toDomain() {
    return GetOfferPlansModel(
      error: error.onNull(),
      message: message.onNull(),
      data: (data ?? []).map((plan) => plan.toDomain()).toList(),
    );
  }
}
