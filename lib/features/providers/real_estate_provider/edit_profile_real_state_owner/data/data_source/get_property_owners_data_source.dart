import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/response/get_property_owners_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_property_owners_request.dart';

abstract class GetPropertyOwnersDataSource {
  Future<GetPropertyOwnersResponse> getMyPropertyOwners(
      GetPropertyOwnersRequest request);
}

class GetPropertyOwnersDataSourceImplement
    implements GetPropertyOwnersDataSource {
  AppService _appService;

  GetPropertyOwnersDataSourceImplement(this._appService);

  @override
  Future<GetPropertyOwnersResponse> getMyPropertyOwners(
      GetPropertyOwnersRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetPropertyOwnersResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyPropertyOwners(
      request.lat,
      request.lng,
      AppLanguage().getCurrentLocale(),
    );
  }
}
