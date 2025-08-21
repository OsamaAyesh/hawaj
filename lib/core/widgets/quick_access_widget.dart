import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';

class QuickAccessWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final double top;
  final double right;
  final double left;
  final double bottom;

  const QuickAccessWidget(
      {super.key,
        required this.iconPath,
        required this.title,
        required this.subtitle,
        this.onTap,
        required this.top,
        required this.right,
        required this.left,
        required this.bottom});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ManagerWidth.w164,
      height: ManagerHeight.h156,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: ManagerHeight.h24,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: ManagerHeight.h8,
                  right: ManagerWidth.w6,
                  left: ManagerWidth.w6,
                  bottom: ManagerHeight.h8,
                ),
                height: ManagerHeight.h58,
                width: ManagerWidth.w58,
                decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(
                      ManagerOpacity.op0_05,
                    ),
                    borderRadius: BorderRadius.circular(ManagerRadius.r12)),
                child: Image.asset(
                  iconPath,
                  width: 48,
                  height: 48,
                  color: ManagerColors.primaryColor,
                ),
              ),
              SizedBox(
                height: ManagerHeight.h8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
                child: Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
                child: Text(
                  subtitle,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s8,
                    color: ManagerColors.greyWithColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
