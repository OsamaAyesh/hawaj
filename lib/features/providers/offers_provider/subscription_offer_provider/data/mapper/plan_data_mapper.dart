import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/plan_item_mapper.dart';

import '../../domain/model/plan_data_model.dart';
import '../response/plan_data_response.dart';

extension PlanDataMapper on PlanDataResponse {
  PlanDataModel toDomain() {
    return PlanDataModel(
      data: data!.map((e) => e.toDomain()).toList(),
    );
  }
}
