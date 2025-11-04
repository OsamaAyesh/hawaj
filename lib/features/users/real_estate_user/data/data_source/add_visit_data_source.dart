import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../request/add_visit_request.dart';

abstract class AddVisitDataSource {
  Future<WithOutDataResponse> addMyVisit(AddMyVisitRequest request);
}

class AddVisitDataSourceImplement
    implements AddVisitDataSource {
  AppService _appService;

  AddVisitDataSourceImplement(this._appService);

  @override
  Future<WithOutDataResponse> addMyVisit(AddMyVisitRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return WithOutDataResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.addVisitRealEstate(
      request.visitDate,
      request.timeFrom,
      request.timeTo,
      request.visitorMemberId,
      request.propertyId,
      request.visitStatus,
    );
  }
}
