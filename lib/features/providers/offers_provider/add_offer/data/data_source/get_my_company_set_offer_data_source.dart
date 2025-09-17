import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../../../core/util/get_app_langauge.dart';
import '../request/get_my_company_set_offer_request.dart';
import '../response/get_my_company_set_offer_response.dart';

abstract class GetMyCompanySetOfferDataSource {
  Future<GetMyCompanySetOfferResponse> getMyCompanySetOffer(
      GetMyOrganizationSetOfferRequest request);
}

class GetMyCompanySetOfferDataSourceImplement
    implements GetMyCompanySetOfferDataSource {
  AppService _appService;

  GetMyCompanySetOfferDataSourceImplement(this._appService);

  @override
  Future<GetMyCompanySetOfferResponse> getMyCompanySetOffer(
      GetMyOrganizationSetOfferRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetMyCompanySetOfferResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getMyCompanySetOffer(
      AppLanguage().getCurrentLocale(),
      request.id,
      request.my,
      request.lat,
      request.lng,
    );
  }
}
