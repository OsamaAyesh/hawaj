import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_data_model.dart';

class PlanModel {
  bool error;
  String message;
  PlanDataModel data;

  PlanModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
