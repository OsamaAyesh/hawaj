import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ManagerColors.bariarColor.withOpacity(ManagerOpacity.op0_2),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Container(
            width: double.infinity,
            height: ManagerHeight.h180,
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ManagerHeight.h8),
                    Text(
                      subtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.greyWithColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm,
                        child: Container(
                          height: ManagerHeight.h42,
                          decoration: BoxDecoration(
                              color: ManagerColors.primaryColor,
                              borderRadius:
                                  BorderRadius.circular(ManagerRadius.r4)),
                          child: Center(
                            child: Text(
                              confirmText,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                     SizedBox(width: ManagerWidth.w8),
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          height: ManagerHeight.h42,
                          decoration: BoxDecoration(
                              color: ManagerColors.redNew.withOpacity(0.04),
                              borderRadius:
                              BorderRadius.circular(ManagerRadius.r4)),
                          child: Center(
                            child: Text(
                              cancelText,
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.redNew,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
