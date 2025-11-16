import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/get_organization_item_with_out_offer_mapper.dart';
import 'package:app_mobile/core/model/get_my_organization_model.dart';
import 'package:app_mobile/core/response/get_my_organization_response.dart';

extension GetMyOrganizationMapper on GetMyOrganizationResponse {
  GetMyOrganizationModel toDomain() {
    return GetMyOrganizationModel(
      message: message.onNull(),
      error: error.onNull(),
      data: data?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
