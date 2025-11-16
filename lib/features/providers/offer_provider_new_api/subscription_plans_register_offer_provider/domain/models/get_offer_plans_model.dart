import 'offer_plan_model.dart';

class GetOfferPlansModel {
  bool error;
  List<OfferPlanModel> data;
  String message;

  GetOfferPlansModel({
    required this.error,
    required this.data,
    required this.message,
  });
}
