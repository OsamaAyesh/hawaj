import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/profile/data/mapper/get_profile_data_mapper.dart';
import 'package:app_mobile/features/common/profile/data/response/get_profile_response.dart';
import 'package:app_mobile/features/common/profile/domain/model/get_profile_model.dart';

extension GetProfileMapper on GetProfileResponse{
  GetProfileModel toDomain(){
    return GetProfileModel(error: error.onNull(), message: message.onNull(),  data: data!.toDomain());
  }
}