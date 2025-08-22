import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadProfileImageField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? note;
  final VoidCallback? onTap;

  const UploadProfileImageField({
    super.key,
    this.label,
    this.hint,
    this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        if (label != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: ManagerHeight.h8),
            child: Text(
              label!,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
          ),
        ],

        /// Upload Box with dotted border
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            color: ManagerColors.greyWithColor.withOpacity(0.6),
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: Radius.circular(ManagerRadius.r4),
            dashPattern: const [6, 4],
            child: Container(
              width: double.infinity,
              height: ManagerHeight.h42,
              color: ManagerColors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: ManagerHeight.h10),
                      child: Image.asset(
                        ManagerIcons.uploadIcon,
                        height: ManagerHeight.h16,
                        width: ManagerWidth.w16,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w4),
                    Text(
                      hint ?? "رفع صورة",
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.greyWithColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// Note
        if (note != null) ...[
          SizedBox(height: ManagerHeight.h4),
          Text(
            note!,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s8,
              color: ManagerColors.greyWithColor,
            ),
          ),
        ],
      ],
    );
  }
}
