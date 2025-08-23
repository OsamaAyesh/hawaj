import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_opacity.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;

  const SettingsTileWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r6),
          border: Border.all(
              color:
                  ManagerColors.strokColor.withOpacity(ManagerOpacity.op0_34)),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: ManagerHeight.h24,
              width: ManagerWidth.w24,
            ),
            SizedBox(
              width: ManagerWidth.w4,
            ),
            Expanded(
              child: Text(
                title,
                style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s10, color: ManagerColors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
