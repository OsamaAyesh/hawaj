import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/profile/data/request/update_profile_request.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';

abstract class UpdateProfileDataSource {
  Future<WithOutDataResponse> updateProfileData(UpdateProfileRequest request);
}

class UpdateProfileDataSourceImplement implements UpdateProfileDataSource {
  AppService _appService;

  UpdateProfileDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> updateProfileData(
      UpdateProfileRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.updateProfile(
      await request.toFormData(),
    );
  }
}
