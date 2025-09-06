import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_data_model.dart';

class GetMyOrganizationOfferProviderModel {
  bool error;
  String message;
  GetMyOrganizationOfferProviderDataModel data;

  GetMyOrganizationOfferProviderModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
