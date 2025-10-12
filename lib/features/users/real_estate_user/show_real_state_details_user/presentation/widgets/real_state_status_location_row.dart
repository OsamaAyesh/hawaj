import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class RealStateStatusLocationRow extends StatelessWidget {
  const RealStateStatusLocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 18,
              color: ManagerColors.primaryColor,
            ),
            SizedBox(width: ManagerWidth.w2),
            Text(
              "حي عريزة , مدينة الزلفى , منطقة الرياض",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.locationColorText,
              ),
            ),
          ],
        ),
        const Spacer(),
        // ---------------- العقار متاح ----------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(ManagerRadius.r8),
          ),
          child: Text(
            "العقار متاح",
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
