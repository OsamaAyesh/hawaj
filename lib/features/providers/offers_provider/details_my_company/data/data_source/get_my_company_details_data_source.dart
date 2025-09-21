import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../../../core/util/get_app_langauge.dart';
import '../request/get_my_company_details_request.dart';
import '../response/get_my_company_details_response.dart';

abstract class GetMyCompanyDetailsDataSource {
  Future<GetMyCompanyDetailsResponse> getMyCompanyDetails(
      GetMyCompanyDetailsRequest request);
}

class GetMyCompanyDetailsDataSourceImplement
    implements GetMyCompanyDetailsDataSource {
  AppService _appService;

  GetMyCompanyDetailsDataSourceImplement(this._appService);

  @override
  Future<GetMyCompanyDetailsResponse> getMyCompanyDetails(
      GetMyCompanyDetailsRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyCompanyDetailsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyCompanyDetails(
      AppLanguage().getCurrentLocale(),
      request.id,
      request.my,
      request.lat,
      request.lng,
    );
  }
}
