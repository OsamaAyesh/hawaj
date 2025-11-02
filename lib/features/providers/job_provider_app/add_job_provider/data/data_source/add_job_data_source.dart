import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/request/add_job_request.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class AddJobDataSource {
  Future<WithOutDataResponse> addJobRequest(AddJobRequest request);
}

class AddJobDataSourceImplement implements AddJobDataSource {
  AppService _appService;

  AddJobDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> addJobRequest(AddJobRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.addJobRequest(
      await request.toFormData(),
    );
  }
}
