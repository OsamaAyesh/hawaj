import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_organizations_request.dart';
import '../response/get_my_organization_offer_provider_response.dart';

abstract class GetMyOrganizationOfferProviderDataSource {
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(
      GetOrganizationsRequest request);
}

class GetMyOrganizationOfferProviderDataSourceImplement
    implements GetMyOrganizationOfferProviderDataSource {
  AppService _appService;

  GetMyOrganizationOfferProviderDataSourceImplement(this._appService);

  @override
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(
      GetOrganizationsRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyOrganizationOfferProviderResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyOrganizations(
      AppLanguage().getCurrentLocale(),
      request.id,
      request.my,
      request.lat,
      request.lng,
    );
  }
}
