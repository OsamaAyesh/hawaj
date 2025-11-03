import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/data/request/add_offer_new_request.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class AddOfferNewDataSource {
  Future<WithOutDataResponse> addOfferNewRequest(AddOfferNewRequest request);
}

class AddOfferNewDataSourceImplement implements AddOfferNewDataSource {
  AppService _appService;

  AddOfferNewDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> addOfferNewRequest(
      AddOfferNewRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.addOfferNewRequest(
      await request.toFormData(),
    );
  }
}
