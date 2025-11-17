// delete_offer_data_source.dart
import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/delete_my_offer_request.dart';

abstract class DeleteOfferDataSource {
  Future<WithOutDataResponse> deleteMyOfferRequest(DeleteOfferRequest request);
}

class DeleteOfferDataSourceImplement implements DeleteOfferDataSource {
  final AppService _appService;

  DeleteOfferDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> deleteMyOfferRequest(
      DeleteOfferRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.deleteMyOfferRequest(request.id);
  }
}
