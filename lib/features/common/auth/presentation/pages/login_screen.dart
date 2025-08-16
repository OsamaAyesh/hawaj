import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ManagerHeight.h96,
            ),

            ///Text Welcome In Login
            Align(
              alignment: Get.locale?.languageCode == 'ar'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Text(
                ManagerStrings.welcomeTitle,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ),

            SizedBox(height: ManagerHeight.h4,),

            ///Sub Title Text Welcome In Login
            Align(
              alignment: Get.locale?.languageCode == 'ar'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: Text(
                ManagerStrings.welcomeSubtitle,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.subtitleLoginTextColor,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
