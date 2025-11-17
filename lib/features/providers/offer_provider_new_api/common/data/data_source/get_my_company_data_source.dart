import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../response/get_my_company_response.dart';

abstract class GetMyCompanyDataSource {
  Future<GetMyCompanyResponse> getMyCompany();
}

class GetMyCompanyDataSourceImplement implements GetMyCompanyDataSource {
  AppService _appService;

  GetMyCompanyDataSourceImplement(this._appService);

  @override
  Future<GetMyCompanyResponse> getMyCompany() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyCompanyResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyCompany(
        AppLanguage().getCurrentLocale(), "offers");
  }
}
