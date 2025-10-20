import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/edit_my_real_estate_request.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';

abstract class EditMyRealEstateDataSource {
  Future<WithOutDataResponse> editRealEstate(EditMyRealEstateRequest request);
}

class EditMyRealEstateDataSourceImplement
    implements EditMyRealEstateDataSource {
  AppService _appService;

  EditMyRealEstateDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> editRealEstate(
      EditMyRealEstateRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.editRealEstate(await request.toFormData());
  }
}
