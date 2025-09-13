import 'dart:async';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/features/common/auth/domain/di/di.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/resources/manager_opacity.dart';
import '../../../../../core/routes/custom_transitions.dart';
import '../widgets/sub_title_text_auth_widget.dart';
import '../widgets/title_auth_text_widget.dart';
import 'complete_information_screen.dart';
import 'login_screen.dart';

class SuccessLoginScreen extends StatelessWidget {
  const SuccessLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body:Column(
        children: [
          SizedBox(
            height: ManagerHeight.h248,
          ),

          ///Success Icon Widget
          Image.asset(
            ManagerIcons.successIcon,
            height: ManagerHeight.h62,
            width: ManagerWidth.w62,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: ManagerHeight.h24,
          ),

          ///Title Text Widget
          TitleAuthTextWidget(
            title: ManagerStrings.verificationSuccessTitle,
          ),
          SizedBox(
            height: ManagerHeight.h6,
          ),

          ///Subtitle Text Widget
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w32),
            child: SubTitleTextAuthWidget(
              subTitle:
              ManagerStrings.verificationSuccessSubtitle,
            ),
          ),
          SizedBox(
            height: ManagerHeight.h45,
          ),

          ///Button Complete Information Widget If Completed Navigate To Home
          ButtonApp(
            title: ManagerStrings.completeProfileButton,
            onPressed: () {
              initCompletedProfile();
              Get.offAll(const CompleteInformationScreen());
            },
            paddingWidth: ManagerWidth.w24,
          ),
          SizedBox(
            height: ManagerHeight.h6,
          ),

          ///Go To Privacy Policy
          Text(
            ManagerStrings.viewPoliciesText,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s10,
              color: ManagerColors.black,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
