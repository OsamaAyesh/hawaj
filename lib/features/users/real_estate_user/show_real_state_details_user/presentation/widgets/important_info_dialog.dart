import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class ImportantInfoDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ImportantInfoDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = ManagerColors.primaryColor;
    final Color greyText = Colors.grey.shade700;
    final Color redText = Colors.red.shade600;

    return Material(
      color: ManagerColors.bariarColor.withOpacity(ManagerOpacity.op0_2),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(ManagerRadius.r12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== أيقونة المعلومات =====
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),

                // ===== العنوان =====
                Text(
                  "معلومة مهمة",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // ===== النصوص بطريقة منظمة =====
                Text.rich(
                  TextSpan(
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s13,
                      color: greyText,
                      // height: 1.7,
                    ),
                    children: [
                      const TextSpan(
                        text: "عند إتمام عملية البيع، تُحسب عمولة بنسبة ",
                      ),
                      TextSpan(
                        text: "%1 ",
                        style: TextStyle(
                          color: redText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "من قيمة السعر لصالح ",
                      ),
                      TextSpan(
                        text: "“حواج”",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: "، ويتم تحويلها إلى الحساب رقم ",
                      ),
                      TextSpan(
                        text: "SA12345678901234567",
                        style: TextStyle(
                          color: redText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: " لدى البنك الأهلي السعودي.",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // ===== الأزرار =====
                Row(
                  children: [
                    // زر الإلغاء
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.06),
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r6),
                          ),
                          child: Center(
                            child: Text(
                              "إلغاء",
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // زر المتابعة
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r6),
                          ),
                          child: Center(
                            child: Text(
                              "متابعة التواصل",
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: Colors.white,
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
