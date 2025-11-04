import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';

class SuccessRegisterCompanyOfferProviderScreen extends StatefulWidget {
  const SuccessRegisterCompanyOfferProviderScreen({super.key});

  @override
  State<SuccessRegisterCompanyOfferProviderScreen> createState() =>
      _SuccessRegisterCompanyOfferProviderScreenState();
}

class _SuccessRegisterCompanyOfferProviderScreenState
    extends State<SuccessRegisterCompanyOfferProviderScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: ManagerHeight.h200),

                  /// ===== Success Icon =====
                  Container(
                    padding: EdgeInsets.all(ManagerWidth.w20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ManagerColors.primaryColor.withOpacity(0.1),
                    ),
                    child: Image.asset(
                      ManagerIcons.successIcon,
                      height: ManagerHeight.h62,
                      width: ManagerWidth.w62,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: ManagerHeight.h24),

                  /// ===== Title =====
                  Text(
                    ManagerStrings.completeSubscriptionTitle,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s18,
                      color: ManagerColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ManagerHeight.h8),

                  /// ===== Subtitle =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w32),
                    child: Text(
                      ManagerStrings.completeSubscriptionSubtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.gery1OnBoarding,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: ManagerHeight.h48),

                  /// ===== Primary Button: Go to Subscription Plans =====
                  ButtonApp(
                    title: ManagerStrings.completeSubscriptionButton,
                    paddingWidth: ManagerWidth.w24,
                    onPressed: () {
                      Get.off(ManagerProductsOfferProviderScreen());
                    },
                  ),

                  SizedBox(height: ManagerHeight.h12),

                  /// ===== Secondary Text =====
                  Text(
                    ManagerStrings.completeSubscriptionLater,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        /// ===== Loading Overlay =====
        if (_isLoading) const LoadingWidget(),
      ],
    );
  }
}
