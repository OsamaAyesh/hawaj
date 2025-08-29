import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/mapper/offer_data_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_response.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_model.dart';

extension OfferMapper on OfferResponse {
  OfferModel toDomain() {
    return OfferModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
