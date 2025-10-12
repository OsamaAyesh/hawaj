import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class VisitRequestDialog extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController fromTimeController;
  final TextEditingController toTimeController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const VisitRequestDialog({
    super.key,
    required this.dateController,
    required this.fromTimeController,
    required this.toTimeController,
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
            decoration: BoxDecoration(
              color: ManagerColors.white,
              borderRadius: BorderRadius.circular(ManagerRadius.r8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== العنوان =====
                Text(
                  "طلب زيارة",
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // ===== النص الوصفي =====
                Text(
                  "اختر تاريخ ووقت الزيارة، وسيتم إشعار صاحب العقار تلقائيًا بطلبك.",
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: ManagerColors.greyWithColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                // ===== الحقول =====
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "تاريخ الزيارة",
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s13,
                      color: ManagerColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                _buildInputField(
                  controller: dateController,
                  hintText: "حدد التاريخ الذي ترغب بزيارة العقار فيه",
                  icon: Icons.calendar_today_outlined,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text =
                          "${picked.day}-${picked.month}-${picked.year}";
                    }
                  },
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "من الساعة",
                            style: getMediumTextStyle(
                              fontSize: ManagerFontSize.s13,
                              color: ManagerColors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: fromTimeController,
                            hintText: "مثال: 10:00 ص",
                            icon: Icons.access_time,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                fromTimeController.text =
                                    picked.format(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "إلى الساعة",
                            style: getMediumTextStyle(
                              fontSize: ManagerFontSize.s13,
                              color: ManagerColors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: toTimeController,
                            hintText: "مثال: 11:30 ص",
                            icon: Icons.access_time,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                toTimeController.text = picked.format(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ===== الأزرار =====
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          height: ManagerHeight.h42,
                          decoration: BoxDecoration(
                            color: ManagerColors.redNew.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r6),
                          ),
                          child: Center(
                            child: Text(
                              "إلغاء",
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.redNew,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm,
                        child: Container(
                          height: ManagerHeight.h42,
                          decoration: BoxDecoration(
                            color: ManagerColors.primaryColor,
                            borderRadius:
                                BorderRadius.circular(ManagerRadius.r6),
                          ),
                          child: Center(
                            child: Text(
                              "متابعة",
                              style: getBoldTextStyle(
                                fontSize: ManagerFontSize.s14,
                                color: ManagerColors.white,
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

  // ===== عنصر إدخال قابل لإعادة الاستخدام =====
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      textAlign: TextAlign.right,
      style: getRegularTextStyle(
        fontSize: ManagerFontSize.s12,
        color: ManagerColors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getRegularTextStyle(
          fontSize: ManagerFontSize.s12,
          color: Colors.grey,
        ),
        suffixIcon: Icon(icon, color: ManagerColors.primaryColor, size: 18),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: ManagerColors.primaryColor.withOpacity(0.5),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
