import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/get_my_organization_offer_provider_data_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/get_my_organization_offer_provider_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_model.dart';

extension GetMyOrganizationOfferProviderMapper on GetMyOrganizationOfferProviderResponse{
  GetMyOrganizationOfferProviderModel toDomain(){
    return GetMyOrganizationOfferProviderModel(error: error.onNull(), message: message.onNull(), data: data!.toDomain());
  }
}