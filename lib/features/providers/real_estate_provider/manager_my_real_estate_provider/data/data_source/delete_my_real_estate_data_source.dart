import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/delete_my_real_estate_request.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class DeleteMyRealEstateDataSource {
  Future<WithOutDataResponse> deleteMyRealEstate(
      DeleteMyRealEstateRequest request);
}

class DeleteMyRealEstateDataSourceImplement
    implements DeleteMyRealEstateDataSource {
  AppService _appService;

  DeleteMyRealEstateDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> deleteMyRealEstate(
      DeleteMyRealEstateRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.deleteMyRealEstate(
      request.lat,
      request.id,
      request.lng,
      AppLanguage().getCurrentLocale(),
    );
  }
}
