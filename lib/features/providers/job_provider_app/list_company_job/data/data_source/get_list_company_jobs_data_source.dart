import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/response/get_list_company_jobs_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class GetListCompanyJobsDataSource {
  Future<GetListCompanyJobsResponse> getListCompanyJobs();
}

class GetListCompanyJobsDataSourceImplement
    implements GetListCompanyJobsDataSource {
  AppService _appService;

  GetListCompanyJobsDataSourceImplement(this._appService);

  @override
  Future<GetListCompanyJobsResponse> getListCompanyJobs() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetListCompanyJobsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getListCompanyJobs();
  }
}
