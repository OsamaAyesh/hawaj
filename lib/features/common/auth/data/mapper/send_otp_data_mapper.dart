import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_data_response.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_data_model.dart';

extension SendOtpDataMapper on SendOtpDataResponse{
  SendOtpDataModel toDomain(){
    return SendOtpDataModel(code: code.onNull());
  }
}