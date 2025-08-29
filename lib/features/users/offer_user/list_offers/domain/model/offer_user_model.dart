import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_data_model.dart';

import 'offer_user_data_model.dart';

class OfferUserModel {
  bool error;
  String message;
  OfferUserDataModel data;
  OfferUserModel({
    required this.error,
    required this.message,
    required this.data,
});

}