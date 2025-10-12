import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class RealEstateAdInfoWidget extends StatelessWidget {
  const RealEstateAdInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: ManagerColors.locationColorText.withOpacity(0.3),
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 3],
      strokeWidth: 1.2,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AdInfoItem(
              title: "تاريخ الإضافة",
              value: "14-07-2027",
            ),
            _AdInfoItem(
              title: "رقم الترخيص",
              value: "3928492389482933",
            ),
            _AdInfoItem(
              title: "تاريخ انتهاء الرخصة",
              value: "14-07-2028",
            ),
            _AdInfoItem(
              title: "المساحة على حسب الصك",
              value: "635 م²",
            ),
            _AdInfoItem(
              title: "وقت الزيارات المتاح",
              value: "الأحد - الإثنين - الأربعاء",
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const _AdInfoItem({
    required this.title,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "•",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              height: 0.8,
            ),
          ),
          SizedBox(width: ManagerWidth.w6),
          Text(
            title,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s13,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: ManagerWidth.w4),
          Text(
            value,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s13,
              color: highlight
                  ? ManagerColors.primaryColor
                  : ManagerColors.primaryColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
