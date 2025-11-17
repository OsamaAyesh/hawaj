import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../constants/env/env_constants.dart';
import '../../../../../../core/network/app_api.dart';
import '../../../../../../core/util/get_app_langauge.dart';
import '../request/get_my_organization_details_request.dart';
import '../response/get_my_organization_details_response.dart';

abstract class GetMyOrganizationDetailsDataSource {
  Future<GetMyOrganizationDetailsResponse> getMyOrganizationWithId(
      GetMyOrganizationDetailsRequest request);
}

class GetMyOrganizationDetailsDataSourceImplement
    implements GetMyOrganizationDetailsDataSource {
  AppService _appService;

  GetMyOrganizationDetailsDataSourceImplement(this._appService);

  @override
  Future<GetMyOrganizationDetailsResponse> getMyOrganizationWithId(
      GetMyOrganizationDetailsRequest request) async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      return await _appService.getMyOrganizationWithId(
          AppLanguage().getCurrentLocale(), request.id, "offers");
    }
    return await _appService.getMyOrganizationWithId(
        AppLanguage().getCurrentLocale(), request.id, "offers");
  }
}
