import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class RealEstateAdInfoWidget extends StatelessWidget {
  final String advertiserRole;
  final String saleType;
  final String visitDays;
  final String visitTimeFrom;
  final String visitTimeTo;

  const RealEstateAdInfoWidget({
    super.key,
    required this.advertiserRole,
    required this.saleType,
    required this.visitDays,
    required this.visitTimeFrom,
    required this.visitTimeTo,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: ManagerColors.locationColorText.withOpacity(0.3),
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 3],
      strokeWidth: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AdInfoItem(
              title: "دور المعلن",
              value: advertiserRole.isNotEmpty ? advertiserRole : "غير محدد",
            ),
            _AdInfoItem(
              title: "نوع البيع",
              value: saleType.isNotEmpty ? saleType : "غير محدد",
            ),
            _AdInfoItem(
              title: "أيام الزيارة",
              value: visitDays.isNotEmpty ? visitDays : "غير محدد",
            ),
            _AdInfoItem(
              title: "وقت الزيارة من",
              value: visitTimeFrom.isNotEmpty ? visitTimeFrom : "غير محدد",
            ),
            _AdInfoItem(
              title: "وقت الزيارة إلى",
              value: visitTimeTo.isNotEmpty ? visitTimeTo : "غير محدد",
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
          Flexible(
            child: Text(
              value,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s13,
                color: highlight
                    ? ManagerColors.primaryColor
                    : ManagerColors.primaryColor.withOpacity(0.9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
