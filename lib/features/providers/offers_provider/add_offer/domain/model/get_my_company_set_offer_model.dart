import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';

class GetMyCompanySetOfferModel {
  bool error;
  String message;
  OrganizationCompanyDailyOfferItemModel data;

  GetMyCompanySetOfferModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
