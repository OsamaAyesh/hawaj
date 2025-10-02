import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
import '../response/get_organizations_response.dart';

abstract class GetOrganizationsDataSource {
  Future<GetOrganizationsResponse> getOrganizations(
      GetOrganizationsRequest request);
}

class GetOrganizationsDataSourceImplement
    implements GetOrganizationsDataSource {
  AppService _appService;

  GetOrganizationsDataSourceImplement(this._appService);

  @override
  Future<GetOrganizationsResponse> getOrganizations(
      GetOrganizationsRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetOrganizationsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getOrganizations(
      request.lat,
      request.lng,
      request.language,
    );
  }
}
