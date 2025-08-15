import 'package:flutter/material.dart';

import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_width.dart';
class LogoInSplashWidget extends StatelessWidget {
  const LogoInSplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ManagerImages.logo,
        height: ManagerHeight.h270,
        width: ManagerWidth.w270,
        fit: BoxFit.contain,
      ),
    );
  }
}
