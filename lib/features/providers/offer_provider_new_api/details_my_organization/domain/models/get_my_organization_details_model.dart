import 'package:app_mobile/core/model/get_organization_item_with_offer_model.dart';

class GetMyOrganizationDetailsModel {
  bool error;
  String message;
  GetOrganizationItemWithOfferModel data;

  GetMyOrganizationDetailsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
