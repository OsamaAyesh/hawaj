import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

abstract class CompletedProfileDataSource {
  Future<WithOutDataResponse> completedProfile(CompletedProfileRequest request);
}

class CompletedProfileDataSourceImplement
    implements CompletedProfileDataSource {
  AppService _appService;

  CompletedProfileDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> completedProfile(
      CompletedProfileRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.completedProfile(
      request.firstName,
      request.lastName,
      request.gender,
      request.dateOfBirth,
    );
  }
}
