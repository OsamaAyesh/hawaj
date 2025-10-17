import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/add_real_state_request.dart';

abstract class AddRealEstateDataSource {
  Future<WithOutDataResponse> addRalEstate(AddRealStateRequest request);
}

class AddRealEstateDataSourceImplement implements AddRealEstateDataSource {
  AppService _appService;

  AddRealEstateDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> addRalEstate(AddRealStateRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.addRalEstate(
      await request.toFormData(),
    );
  }
}
