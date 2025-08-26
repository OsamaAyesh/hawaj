import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/plan_data_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';

extension PlanMapper on PlanResponse{
  PlanModel toDomain(){
    return PlanModel(error: error.onNull(), message: message.onNull(), data: data!.toDomain());
  }
}