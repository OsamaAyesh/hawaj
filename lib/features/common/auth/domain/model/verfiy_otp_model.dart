import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_data_model.dart';

class VerfiyOtpModel {
  bool error;
  String message;
  VerfiyOtpDataModel data;

  VerfiyOtpModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
