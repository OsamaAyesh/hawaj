import 'package:app_mobile/core/model/get_organization_item_with_offer_model.dart';

class GetCompanyModel {
  bool error;
  String message;
  GetOrganizationItemWithOfferModel data;

  GetCompanyModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
