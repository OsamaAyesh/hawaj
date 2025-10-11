import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/orgnization_company_daily_offer_item_mapper.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_company_response.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';

extension GetCompanyMapper on GetCompanyResponse {
  GetCompanyModel toDomain() {
    return GetCompanyModel(
        error: error.onNull(),
        message: message.onNull(),
        data: data!.toDomain());
  }
}
