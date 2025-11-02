import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/response/get_list_jobs_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class GetListJobsDataSource {
  Future<GetListJobsResponse> getListJobs();
}

class GetListJobsDataSourceImplement implements GetListJobsDataSource {
  AppService _appService;

  GetListJobsDataSourceImplement(this._appService);

  @override
  Future<GetListJobsResponse> getListJobs() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetListJobsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getListJobsRequest();
  }
}
