import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_my_real_estates_request.dart';
import '../response/get_my_real_estates_response.dart';

abstract class GetMyRealEstatesDataSource {
  Future<GetMyRealEstatesResponse> getMyRealEstate(
      GetMyRealEstatesRequest request);
}

class GetMyRealEstatesDataSourceImplement
    implements GetMyRealEstatesDataSource {
  AppService _appService;

  GetMyRealEstatesDataSourceImplement(this._appService);

  @override
  Future<GetMyRealEstatesResponse> getMyRealEstate(
      GetMyRealEstatesRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyRealEstatesResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyRealEstate(
      request.lat,
      request.lng,
      request.language,
    );
  }
}
