import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_styles.dart';
import '../widgets/logo_in_splash_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        alignment: Alignment.center,
        children: [
          const LogoInSplashWidget(),
          Positioned(
            top: ManagerHeight.h710,
            child: const CircularProgressIndicator(
              color: ManagerColors.primaryColor,
            ),
          ),
          Positioned(
            bottom: ManagerHeight.h20,
            child: Text(
              AppConfig.version,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
