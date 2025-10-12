import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class RealEstateInfoCardWidget extends StatelessWidget {
  const RealEstateInfoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: ManagerColors.locationColorText.withOpacity(0.3),
      borderType: BorderType.RRect,
      radius: Radius.circular(ManagerRadius.r4),
      dashPattern: const [6, 3],
      strokeWidth: 1.2,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ManagerWidth.w8, vertical: ManagerHeight.h8),
        child: Column(
          children: [
            _buildInfoRow(
              rightIcon: ManagerIcons.informationRealEstateIcon1,
              rightTitle: "المساحة",
              rightValue: "651 م²",
              leftIcon: ManagerIcons.informationRealEstateIcon5,
              leftTitle: "دورات المياه",
              leftValue: "10",
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              rightIcon: ManagerIcons.informationRealEstateIcon2,
              rightTitle: "الواجهة",
              rightValue: "شمالي غربي",
              leftIcon: ManagerIcons.informationRealEstateIcon6,
              leftTitle: "عرض الشارع",
              leftValue: "12 م²",
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              rightIcon: ManagerIcons.informationRealEstateIcon3,
              rightTitle: "غرف النوم",
              rightValue: "7",
              leftIcon: ManagerIcons.informationRealEstateIcon7,
              leftTitle: "عمر العقار",
              leftValue: "10 سنوات",
            ),
            const SizedBox(height: 8),
            _buildSingleInfoItem(
              ManagerIcons.informationRealEstateIcon8,
              "الغرض",
              "سكني",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String rightIcon,
    required String rightTitle,
    required String rightValue,
    required String leftIcon,
    required String leftTitle,
    required String leftValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                rightIcon,
                width: ManagerWidth.w20,
                height: ManagerHeight.h20,
                color: ManagerColors.primaryColor,
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                rightTitle,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                rightValue,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: ManagerWidth.w12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                leftIcon,
                width: 20,
                height: 20,
                color: ManagerColors.primaryColor,
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                leftTitle,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                leftValue,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInfoItem(String icon, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          icon,
          width: ManagerWidth.w20,
          height: ManagerHeight.h20,
          color: ManagerColors.primaryColor,
        ),
        SizedBox(width: ManagerWidth.w6),
        Text(
          title,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s13,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: ManagerWidth.w6),
        Text(
          value,
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s13,
            color: ManagerColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
