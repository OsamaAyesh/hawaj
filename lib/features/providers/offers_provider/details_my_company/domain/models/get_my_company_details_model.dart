import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';

class GetMyCompanyDetailsModel {
  bool error;
  String message;
  OrganizationCompanyDailyOfferItemModel data;

  GetMyCompanyDetailsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
