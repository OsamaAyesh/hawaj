import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/edit_profile_my_property_owner_request.dart';

abstract class EditProfileRealEstateOwnerDataSource {
  Future<WithOutDataResponse> editProfileMyPropertyOwner(
      EditProfileMyPropertyOwnerRequest request);
}

class EditProfileRealEstateOwnerDataSourceImplement
    implements EditProfileRealEstateOwnerDataSource {
  AppService _appService;

  EditProfileRealEstateOwnerDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> editProfileMyPropertyOwner(
      EditProfileMyPropertyOwnerRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.editProfileMyPropertyOwner(
      await request.toFormData(),
    );
  }
}
