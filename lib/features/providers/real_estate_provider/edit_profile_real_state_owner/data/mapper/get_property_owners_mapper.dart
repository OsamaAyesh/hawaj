import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/property_item_owner_mapper.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/response/get_property_owners_response.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/models/get_property_owners_model.dart';

extension GetPropertyOwnersMapper on GetPropertyOwnersResponse {
  GetPropertyOwnersModel toDomain() {
    return GetPropertyOwnersModel(
        error: error.onNull(),
        message: message.onNull(),
        data: data?.map((e) => e.toDomain()).toList() ?? []);
  }
}
