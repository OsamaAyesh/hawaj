import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../response/get_settings_base_response.dart';

abstract class JobSettingsDataSource {
  Future<GetSettingsBaseResponse> getJobsSettings();
}

class JobSettingsDataSourceImplement implements JobSettingsDataSource {
  AppService _appService;

  JobSettingsDataSourceImplement(this._appService);

  @override
  Future<GetSettingsBaseResponse> getJobsSettings() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetSettingsBaseResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.jobsSettingsRequest();
  }
}
