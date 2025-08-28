import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/response/send_otp_response.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/response/plan_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../request/set_subscription_offer_provider_request.dart';

abstract class SetSubscriptionOfferProviderDataSource {
  Future<WithOutDataResponse> setSubscriptionOfferProvider(
      SetSubscriptionOfferProviderRequest request);
}

class SetSubscriptionOfferProviderDataSourceImplement
    implements SetSubscriptionOfferProviderDataSource {
  AppService _appService;

  SetSubscriptionOfferProviderDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> setSubscriptionOfferProvider(
      SetSubscriptionOfferProviderRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.setSubscriptionOfferProvider(
      request.organizationsId,
      request.plansId,
    );
  }
}
