import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'user_blur_info.dart'; // استدعاء الWidget تبعتك

class ServiceRequestCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;
  final String title;
  final String description;
  final String date;
  final String applicantsCount;

  const ServiceRequestCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.applicantsCount,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      color: Colors.grey.shade400,
      strokeWidth: 1,
      dashPattern: const [6, 3],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ManagerHeight.h8,
            ),
            Row(
              children: [
                UserBlurInfo(
                  name: name,
                  subtitle: subtitle,
                  imageUrl: imageUrl,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ManagerWidth.w8,
                        vertical: ManagerHeight.h2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ManagerRadius.r4,
                        ),
                        color: ManagerColors.primaryColor.withOpacity(
                          0.1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: ManagerColors.primaryColor,
                          ),
                          SizedBox(width: ManagerWidth.w6),
                          Text(
                            applicantsCount,
                            style: getRegularTextStyle(
                              fontSize: ManagerFontSize.s7,
                              color: ManagerColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ManagerHeight.h2,
                    ),
                    Text(
                      "تاريخ تقديم الطلب $date",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s6,
                        color: ManagerColors.colorDate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: ManagerHeight.h12,
            ),
            Text(
              title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s10,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h4),
            Text(
              description,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s8,
                color: ManagerColors.colorDescription,
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
          ],
        ),
      ),
    );
  }
}
