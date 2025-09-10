import 'package:app_mobile/features/users/offer_user/company_with_offer/data/mapper/get_offer_item_mapper.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/mapper/get_organization_item_mapper.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_company_data_response.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_data_model.dart';

extension GetCompanyDataMapper on GetCompanyDataResponse {
  GetCompanyDataModel toDomain() {
    return GetCompanyDataModel(
      data: data!.toDomain(),
      offers: offers!.map((e) => e.toDomain()).toList(),
    );
  }
}
