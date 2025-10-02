import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';

class GetOrganizationsModel {
  bool error;
  String message;
  List<OrganizationCompanyDailyOfferItemModel> data;

  GetOrganizationsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
