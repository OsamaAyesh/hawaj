import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/profile/data/response/get_profile_data_response.dart';
import 'package:app_mobile/features/common/profile/data/response/get_profile_response.dart';
import 'package:app_mobile/features/common/profile/domain/model/get_profile_data_model.dart';

extension GetProfileDataMapper on GetProfileDataResponse{
  GetProfileDataModel toDomain() {
  return  GetProfileDataModel(id: id.onNull(),
        name: name.onNull(),
        phone: phone.onNull(),
        createdAt: createdAt.onNull(),
        updatedAt: updatedAt.onNull(),);
  }
}