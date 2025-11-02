import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_job_applications_request.dart';
import '../response/get_job_applications_response.dart';

abstract class GetJobApplicationsDataSource {
  Future<GetJobApplicationsResponse> getJobApplications(
      GetJobApplicationRequest request);
}

class GetJobApplicationsDataSourceImplement
    implements GetJobApplicationsDataSource {
  AppService _appService;

  GetJobApplicationsDataSourceImplement(this._appService);

  @override
  Future<GetJobApplicationsResponse> getJobApplications(
      GetJobApplicationRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetJobApplicationsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getJobApplications(
      request.jobId,
    );
  }
}
