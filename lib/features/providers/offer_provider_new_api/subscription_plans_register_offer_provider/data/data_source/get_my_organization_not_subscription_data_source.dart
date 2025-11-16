import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../../../core/response/get_my_organization_response.dart';
import '../request/get_offer_provider_plans_request.dart';

abstract class GetMyOrganizationNotSubscriptionDataSource {
  Future<GetMyOrganizationResponse> getMyOrganizationsNew(
    GetOfferProviderPlansRequest request,
  );
}

class GetMyOrganizationNotSubscriptionDataSourceImplement
    implements GetMyOrganizationNotSubscriptionDataSource {
  final AppService _appService;

  GetMyOrganizationNotSubscriptionDataSourceImplement(this._appService);

  @override
  Future<GetMyOrganizationResponse> getMyOrganizationsNew(
      GetOfferProviderPlansRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyOrganizationResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }

    return await _appService.getMyOrganizationsNew(
      request.language,
    );
  }
}
