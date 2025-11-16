import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/get_offer_provider_plans_request.dart';
import '../response/get_offer_plans_response.dart';

abstract class GetOfferPlansDataSource {
  Future<GetOfferPlansResponse> getOfferProviderPlans(
    GetOfferProviderPlansRequest request,
  );
}

class GetOfferPlansDataSourceImplement implements GetOfferPlansDataSource {
  final AppService _appService;

  GetOfferPlansDataSourceImplement(this._appService);

  @override
  Future<GetOfferPlansResponse> getOfferProviderPlans(
      GetOfferProviderPlansRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetOfferPlansResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }

    return await _appService.getOfferProviderPlans(
      request.language,
    );
  }
}
