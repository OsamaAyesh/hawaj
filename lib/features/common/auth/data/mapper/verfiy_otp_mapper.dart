import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/auth/data/mapper/verfiy_otp_data_mapper.dart';
import 'package:app_mobile/features/common/auth/data/response/verfiy_otp_response.dart';
import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_model.dart';

extension VerfiyOtpMapper on VerfiyOtpResponse{
  VerfiyOtpModel toDomain(){
    return VerfiyOtpModel(error: error.onNull(), message: message.onNull(), data: data!.toDomain());
  }
}