import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_real_estate_user_request.dart';
import '../response/get_real_estate_user_response.dart';

abstract class GetRealEstateUserDataSource {
  Future<GetRealEstateUserResponse> getMyRealUserEstate(
      GetRealEstateUserRequest request);
}

class GetRealEstateUserDataSourceImplement
    implements GetRealEstateUserDataSource {
  AppService _appService;

  GetRealEstateUserDataSourceImplement(this._appService);

  @override
  Future<GetRealEstateUserResponse> getMyRealUserEstate(
      GetRealEstateUserRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetRealEstateUserResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyRealUserEstate(
      request.lat,
      request.id,
      request.lng,
      request.language,
    );
  }
}
