import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_data_model.dart';

class OfferModel {
  bool error;
  String message;
  OfferDataModel data;
  OfferModel({
    required this.error,
    required this.message,
    required this.data,
});

}