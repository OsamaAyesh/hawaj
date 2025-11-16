import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_organization_types_request.dart';
import '../response/get_organization_types_response.dart';

abstract class GetOrganizationTypesDataSource {
  Future<GetOrganizationTypesResponse> getOrganizationTypes(
      GetOrganizationTypesRequest request);
}

class GetOrganizationTypesDataSourceImplement
    implements GetOrganizationTypesDataSource {
  AppService _appService;

  GetOrganizationTypesDataSourceImplement(this._appService);

  @override
  Future<GetOrganizationTypesResponse> getOrganizationTypes(
      GetOrganizationTypesRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetOrganizationTypesResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getOrganizationTypes(
      request.language,
    );
  }
}
