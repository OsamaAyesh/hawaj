import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/util/screen_util_new.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'constants/constants/constants.dart';
import 'constants/env/env_constants.dart';
import 'core/locale/locales.dart';
import 'core/resources/manager_translation.dart';
import 'core/routes/routes.dart';
import 'core/util/size_util.dart';

void main() async {
  await initModule();
  runApp(
    EasyLocalization(
      supportedLocales: localeSettings.locales,
      path: translationPath,
      fallbackLocale: localeSettings.defaultLocale,
      startLocale: localeSettings.defaultLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtilNew.init(context);
    SizeConfig.init(context);
    return ScreenUtilInit(
      designSize: const Size(Constants.deviceWidth, Constants.deviceHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          defaultGlobalState: dotenv.env[EnvConstants.debug].onNullBool(),
          // locale: const Locale("ar"),
          locale: localeSettings.defaultLocale,
          debugShowCheckedModeBanner:
              dotenv.env[EnvConstants.debug].onNullBool(),
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: Routes.splash,
          navigatorKey: Get.key,
          theme: ThemeData(
            useMaterial3: true,
          ),
        );
      },
    );
  }
}

///flutter pub run build_runner build --delete-conflicting-outputs
///972567450057
