import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';

class UrgentSaleInfoDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const UrgentSaleInfoDialog({
    super.key,
    required this.onConfirm,
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
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(ManagerRadius.r12),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ManagerHeight.h20,
              horizontal: ManagerWidth.w16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ===== أيقونة =====
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: ManagerColors.primaryColor,
                    size: 32,
                  ),
                ),
                SizedBox(height: ManagerHeight.h16),

                /// ===== العنوان =====
                Text(
                  "تنبيه هام",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.primaryColor,
                  ),
                ),
                SizedBox(height: ManagerHeight.h12),

                /// ===== النص =====
                Text(
                  "عند اختيارك خيار البيع العاجل، سيتم دفع مبلغ 1000 ريال سعودي مرة واحدة، "
                      "وذلك لضمان تسريع عملية البيع ومنح إعلانك أقصى درجات الظهور والتميّز.",
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: ManagerColors.greyWithColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ManagerHeight.h24),

                /// ===== زر المتابعة =====
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    width: double.infinity,
                    height: ManagerHeight.h44,
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      borderRadius: BorderRadius.circular(ManagerRadius.r6),
                    ),
                    child: Center(
                      child: Text(
                        "متابعة",
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
