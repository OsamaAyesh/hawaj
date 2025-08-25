import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

abstract class SendOtpDataSource {
  Future<SendOtpResponse> sendOtp(
      SendOtpRequest  request
      );
}

class SendOtpDataSourceImplement implements SendOtpDataSource {
  AppService _appService;

  SendOtpDataSourceImplement(this._appService);

  @override
  Future<SendOtpResponse> sendOtp(
      SendOtpRequest  request

      ) async {


    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return SendOtpResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.sendOtp(request.phone,);
  }
}
