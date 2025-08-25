import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_data_mapper.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';

extension SendOtpMapper on SendOtpResponse{
  SendOtpModel toDomain(){
    return SendOtpModel(error: error.onNull(), data: data!.toDomain(), message: message.onNull());
  }
}