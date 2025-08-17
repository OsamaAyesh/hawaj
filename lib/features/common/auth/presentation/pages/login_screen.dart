import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../core/widgets/labeled_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
        child: SingleChildScrollView(
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
          
              SizedBox(height: ManagerHeight.h48,),
          
              ///Text Field Phone Number
              LabeledTextField(
                widthButton: ManagerWidth.w130,
                label: ManagerStrings.phoneLabel,
                hintText: ManagerStrings.phoneHint,
                controller: TextEditingController(),
                isPhoneField: true,
                textInputAction: TextInputAction.next,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
                    child: Image.asset(ManagerIcons.phoneIcon,height: ManagerHeight.h12,width: ManagerWidth.w14,)),
                minLines: 1,
                maxLines: 1,
              ),
          
              SizedBox(height: ManagerHeight.h28,),
          
              ///Button Login Widget
             ButtonApp(title: ManagerStrings.loginButton, onPressed: (){}, paddingWidth: 0),
          
            ],
          ),
        ),
      ),
    );
  }
}
