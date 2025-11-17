import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/get_organization_item_with_offer_mappers.dart';

import '../../domain/models/get_my_company_model.dart' show GetMyCompanyModel;
import '../response/get_my_company_response.dart';

extension GetMyCompanyMapper on GetMyCompanyResponse {
  GetMyCompanyModel toDomain() {
    return GetMyCompanyModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
