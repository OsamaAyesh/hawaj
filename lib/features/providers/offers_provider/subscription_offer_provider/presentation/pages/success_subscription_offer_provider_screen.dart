import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:flutter/material.dart';

class SuccessSubscriptionOfferProviderScreen extends StatelessWidget {
  const SuccessSubscriptionOfferProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: ManagerHeight.h113,
          ),

          ///========== Image Success Widget Screen ================
          Center(
            child: Image.asset(
              ManagerImages.successSubscriptionImage,
              height: ManagerHeight.h316,
              width: ManagerWidth.w278,
            ),
          ),
          SizedBox(
            height: ManagerHeight.h48,
          ),

          ///======== Title Widget ==============
          Text(
            ManagerStrings.subscriptionSuccessTitle,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.black,
            ),
            maxLines: 1,
          ),
          SizedBox(
            height: ManagerHeight.h4,
          ),

          /// ============= Subtitle Widget =============
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w21),
            child: Text(
              ManagerStrings.subscriptionSuccessDesc,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.colorGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: ManagerHeight.h96,
          ),

          /// ========== Button Continue Widget ===================
          ButtonApp(
            title: ManagerStrings.subscriptionSuccessButton,
            onPressed: () {},
            paddingWidth: ManagerWidth.w24,
          ),
        ],
      ),
    );
  }
}
