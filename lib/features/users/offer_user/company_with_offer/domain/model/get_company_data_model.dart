import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_offer_item_model.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_organization_item_model.dart';

class GetCompanyDataModel {
  GetOrganizationItemModel data;
  List<GetOfferItemModel> offers;

  GetCompanyDataModel({
    required this.data,
    required this.offers,
  });
}
