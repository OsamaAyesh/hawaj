import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';

class GetCompanyModel {
  bool error;
  String message;
  OrganizationCompanyDailyOfferItemModel data;

  GetCompanyModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
