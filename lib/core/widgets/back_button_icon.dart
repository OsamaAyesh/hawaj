import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../resources/manager_icons.dart';

class BackButtonIconApp extends StatelessWidget {
  final VoidCallback onPressed;
  const BackButtonIconApp({super.key,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w6),
        height: ManagerHeight.h24,
        width: ManagerWidth.w24,
        decoration: BoxDecoration(
          color: ManagerColors.primaryColor,
          borderRadius: BorderRadius.circular(
            ManagerRadius.r5,
          ),
        ),
        child: Get.locale?.languageCode == 'ar'? Image.asset( ManagerIcons.arrowBackIcon):Image.asset( ManagerIcons.arrowBackForward),
      ),
    );
  }
}
