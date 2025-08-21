import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../response/on_boarding_response.dart';

abstract class GetOnBoardingDataSource {
  Future<OnBoardingResponse> getOnBoardingData();
}

class GetOnBoardingDataSourceImplement implements GetOnBoardingDataSource {
  AppService _appService;

  GetOnBoardingDataSourceImplement(this._appService);

  @override
  Future<OnBoardingResponse> getOnBoardingData() async {


    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return OnBoardingResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getOnBoardingData();
  }
}
