import 'package:app_mobile/core/model/get_organization_item_with_offer_model.dart';

class GetMyCompanyModel {
  bool error;
  String message;
  List<GetOrganizationItemWithOfferModel> data;

  GetMyCompanyModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
