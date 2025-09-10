
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/request/get_company_request.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_company_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;



abstract class GetCompanyDataSource{
  Future<GetCompanyResponse> getCompany(
      GetCompanyRequest request);
}

class GetCompanyDataSourceImplement
    implements GetCompanyDataSource {
  AppService _appService;

  GetCompanyDataSourceImplement(this._appService);

  @override
  Future<GetCompanyResponse> getCompany(
      GetCompanyRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetCompanyResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getCompany(
      request.idOrg
    );
  }
}
