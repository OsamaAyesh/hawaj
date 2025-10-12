import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/features/users/real_estate_user/show_real_state_details_user/presentation/widgets/verfied_profile_image_widget.dart';
import 'package:flutter/material.dart';

class RealEstateAdvertiserInfoWidget extends StatelessWidget {
  const RealEstateAdvertiserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              VerifiedProfileImageWidget(
                imagePath: ManagerImages.image3remove,
                radius: ManagerHeight.h24,
              ),
              SizedBox(width: ManagerWidth.w8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "صالح عبد الرحمن علي",
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.primaryColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  Text(
                    "مختص في بيع العقارات الثمينة",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: ManagerColors.locationColorText,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ManagerHeight.h16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: ManagerHeight.h24,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ManagerRadius.r4),
                  ),
                  child: Center(
                    child: Text(
                      "إتصال",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ManagerWidth.w8),
              Expanded(
                child: Container(
                  height: ManagerHeight.h24,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ManagerRadius.r4),
                  ),
                  child: Center(
                    child: Text(
                      "تواصل واتس آب",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
