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
  final String price;
  final String area;
  final String type;
  final String usage;

  const RealEstateInfoCardWidget({
    super.key,
    required this.price,
    required this.area,
    required this.type,
    required this.usage,
  });

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
          horizontal: ManagerWidth.w8,
          vertical: ManagerHeight.h8,
        ),
        child: Column(
          children: [
            _buildInfoRow(
              rightIcon: ManagerIcons.informationRealEstateIcon1,
              rightTitle: "السعر",
              rightValue: price.isNotEmpty ? "$price ر.س" : "غير محدد",
              leftIcon: ManagerIcons.informationRealEstateIcon2,
              leftTitle: "المساحة",
              leftValue: area.isNotEmpty ? "$area م²" : "غير محدد",
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              rightIcon: ManagerIcons.informationRealEstateIcon3,
              rightTitle: "النوع",
              rightValue: type.isNotEmpty ? type : "غير محدد",
              leftIcon: ManagerIcons.informationRealEstateIcon8,
              leftTitle: "الغرض",
              leftValue: usage.isNotEmpty ? usage : "غير محدد",
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
        Expanded(
          child: Row(
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
}
