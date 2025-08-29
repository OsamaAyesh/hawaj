
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/common/profile/data/request/update_avatar_request.dart';
import 'package:app_mobile/features/common/profile/data/request/update_profile_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

abstract class UpdateAvatarDataSource {
  Future<WithOutDataResponse> updateAvatar(
      UpdateAvatarRequest  request
      );
}

class UpdateAvatarDataSourceImplement implements UpdateAvatarDataSource {
  AppService _appService;

  UpdateAvatarDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> updateAvatar(
      UpdateAvatarRequest  request

      ) async {


    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.updateAvatar(await request.prepareFormData(),);
  }
}
