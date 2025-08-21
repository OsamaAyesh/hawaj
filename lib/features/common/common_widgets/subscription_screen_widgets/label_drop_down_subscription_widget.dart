import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart'; // لاستعمال Get.locale في RTL/LTR

class LabelDropDownSubscriptionWidget<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const LabelDropDownSubscriptionWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          /// ===== Label =====
          Text(
            label,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s10,
              color: ManagerColors.titleDropDownSubscriptionWidget,
            ),
          ),
           SizedBox(height: ManagerHeight.h8),

          /// ===== Dropdown =====
          DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              value: value,
              hint: Align(
                alignment:
                    isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  hint,
                  style:
                 getRegularTextStyle(fontSize: ManagerFontSize.s14, color: ManagerColors.titleDropDownSubscriptionWidget)
                ),
              ),
              items: items,
              onChanged: onChanged,

              /// ===== Style of Button =====
              buttonStyleData: ButtonStyleData(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              /// ===== Dropdown Style =====
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),

              /// ===== Icon Style =====
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.deepPurple,
                ),
                iconSize: 24,
                openMenuIcon: AnimatedRotation(
                  turns: 0.5,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

              /// ===== Menu Item Style =====
              menuItemStyleData: const MenuItemStyleData(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
