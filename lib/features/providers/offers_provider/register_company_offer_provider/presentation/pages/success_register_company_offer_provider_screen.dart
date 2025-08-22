import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/routes/custom_transitions.dart';
import 'package:app_mobile/core/storage/local/app_settings_prefs.dart';
import 'package:app_mobile/core/widgets/button_app.dart';

import '../../../../../../core/widgets/loading_widget.dart';

class SuccessRegisterCompanyOfferProviderScreen extends StatefulWidget {
  const SuccessRegisterCompanyOfferProviderScreen({super.key});

  @override
  State<SuccessRegisterCompanyOfferProviderScreen> createState() =>
      _SuccessVerfiyAccountScreenState();
}

class _SuccessVerfiyAccountScreenState
    extends State<SuccessRegisterCompanyOfferProviderScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child:   Column(
                children: [
                  SizedBox(height: ManagerHeight.h248),
                  /// =========== Icon Success Image In Screen ======
                  Image.asset(
                    ManagerIcons.successIcon,
                    height: ManagerHeight.h62,
                    width: ManagerWidth.w62,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: ManagerHeight.h24),

                  /// =========== Title Screen Text Widget ======
                  Text(
                    ManagerStrings.orgAddedMainTitle,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: ManagerColors.black,
                    ),
                  ),

                  SizedBox(height: ManagerHeight.h4),
                  /// =========== Sub Title Screen Text Widget ======
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w24),
                    child: Text(ManagerStrings.orgAddedSubtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12, color: ManagerColors.gery1OnBoarding,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: ManagerHeight.h48),
                  ButtonApp(
                    title: ManagerStrings.orgAddedPrimaryBtn,
                    onPressed: (){},
                    paddingWidth: ManagerWidth.w24,
                  ),
                  SizedBox(height: ManagerHeight.h8),
                  Text(
                    ManagerStrings.orgAddedSecondaryBtn,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: ManagerColors.black,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) LoadingWidget(),
      ],
    );
  }
}
