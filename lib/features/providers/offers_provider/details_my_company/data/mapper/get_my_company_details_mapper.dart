import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/orgnization_company_daily_offer_item_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/response/get_my_company_details_response.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/models/get_my_company_details_model.dart';

extension GetMyCompanyDetailsMapper on GetMyCompanyDetailsResponse {
  GetMyCompanyDetailsModel toDomain() {
    return GetMyCompanyDetailsModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
