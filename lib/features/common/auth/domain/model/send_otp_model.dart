import 'package:app_mobile/features/common/auth/domain/model/send_otp_data_model.dart';

class SendOtpModel {
  bool error;
  SendOtpDataModel data;
  String message;

  SendOtpModel({
    required this.error,
    required this.data,
    required this.message,
  });
}
