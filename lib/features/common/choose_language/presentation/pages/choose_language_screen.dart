import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: ManagerHeight.h130,
          ),
          Center(
            child: Image.asset(
              ManagerImages.logoSecondWithPrimaryColor,
              height: ManagerHeight.h156,
              width: ManagerWidth.w180,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: ManagerHeight.h42,
          ),
          Text(
            ManagerStrings.chooseLanguageTitle,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color: ManagerColors.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
