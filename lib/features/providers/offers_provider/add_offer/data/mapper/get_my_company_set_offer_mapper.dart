import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/orgnization_company_daily_offer_item_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/response/get_my_company_set_offer_response.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/domain/model/get_my_company_set_offer_model.dart';

extension GetMyCompanySetOfferMapper on GetMyCompanySetOfferResponse {
  GetMyCompanySetOfferModel toDomain() {
    return GetMyCompanySetOfferModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
