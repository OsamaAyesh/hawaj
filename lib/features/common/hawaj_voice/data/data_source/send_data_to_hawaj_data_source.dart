import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import '../request/send_data_request.dart';
import '../response/send_data_response.dart';

abstract class SendDataToHawajDataSource {
  Future<SendDataResponse> sendData(SendDataRequest request);
}

class SendDataToHawajDataSourceImplement implements SendDataToHawajDataSource {
  AppService _appService;

  SendDataToHawajDataSourceImplement(this._appService);

  @override
  Future<SendDataResponse> sendData(SendDataRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      // Mock response for debugging
      return SendDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login, // Add this to ManagerMokUp
          ),
        ),
      );
    }

    // Real API call using AppService
    return await _appService.sendData(
      request.strl,
      request.lat,
      request.lng,
      request.language,
      request.q,
      request.s,
    );
  }
}
