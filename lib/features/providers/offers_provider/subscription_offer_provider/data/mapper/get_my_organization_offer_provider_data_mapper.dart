import 'package:app_mobile/core/mapper/orgnization_company_daily_offer_item_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/get_my_organization_offer_provider_data_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_data_model.dart';

extension GetMyOrganizationOfferProviderDataMapper on GetMyOrganizationOfferProviderDataResponse{
  GetMyOrganizationOfferProviderDataModel toDomain(){
    return GetMyOrganizationOfferProviderDataModel(data: data?.map((e)=>e.toDomain()).toList()??[]);
  }
}