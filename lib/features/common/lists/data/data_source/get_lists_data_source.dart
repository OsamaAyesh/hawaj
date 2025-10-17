import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_mockup.dart';
import 'package:app_mobile/features/common/lists/data/request/get_lists_request.dart';
import 'package:app_mobile/features/common/lists/data/response/get_lists_response.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';

abstract class GetListsDataSource {
  Future<GetListsResponse> getLists(GetListsRequest request);
}

class GetListsDataSourceImplement implements GetListsDataSource {
  AppService _appService;

  GetListsDataSourceImplement(this._appService);

  @override
  Future<GetListsResponse> getLists(GetListsRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return GetListsResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            ManagerMokUp.login,
          ),
        ),
      );
    }
    return await _appService.getLists(
      request.language,
    );
  }
}
