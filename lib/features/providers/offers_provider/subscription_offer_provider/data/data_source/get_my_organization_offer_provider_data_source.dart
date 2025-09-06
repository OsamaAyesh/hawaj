import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../response/get_my_organization_offer_provider_response.dart';

abstract class GetMyOrganizationOfferProviderDataSource {
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(
      );
}

class GetMyOrganizationOfferProviderDataSourceImplement implements GetMyOrganizationOfferProviderDataSource {
  AppService _appService;

  GetMyOrganizationOfferProviderDataSourceImplement(this._appService);

  @override
  Future<GetMyOrganizationOfferProviderResponse> getMyOrganizations(

      ) async {


    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyOrganizationOfferProviderResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyOrganizations();
  }
}
