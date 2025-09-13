import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/auth/data/response/verfiy_otp_data_response.dart';
import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_data_model.dart';

extension VerfiyOtpDataMapper on VerfiyOtpDataResponse {
  VerfiyOtpDataModel toDomain() {
    return VerfiyOtpDataModel(
      token: token.onNull(),
      completeProfile: completeProfile.onNull(),
    );
  }
}
