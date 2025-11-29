// drawer_menu_data_source.dart
import 'dart:convert';

import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../constants/env/env_constants.dart';
import '../../../../../core/network/app_api.dart';
import '../response/drawer_menu_response.dart';

abstract class DrawerMenuDataSource {
  Future<DrawerMenuResponse> getDrawerMenu();
}

class DrawerMenuDataSourceImplement implements DrawerMenuDataSource {
  final AppService _appService;

  DrawerMenuDataSourceImplement(this._appService);

  @override
  Future<DrawerMenuResponse> getDrawerMenu() async {
    if (dotenv.env[EnvConstants.debug].onNullBool()) {
      // Mock data للتطوير
      return DrawerMenuResponse.fromJson(
        json.decode(
          await rootBundle.rootBundle.loadString(
            'assets/json/drawer_menu.json', // ضع ال JSON هنا
          ),
        ),
      );
    }
    return await _appService.getDrawerMenu(AppLanguage().getCurrentLocale());
  }
}
