import 'package:app_mobile/core/model/get_organization_item_with_out_offer_model.dart';

class GetMyOrganizationModel {
  final bool error;
  final List<GetOrganizationItemWithOutOfferModel> data;
  final String message;

  GetMyOrganizationModel({
    required this.error,
    required this.data,
    required this.message,
  });
}
