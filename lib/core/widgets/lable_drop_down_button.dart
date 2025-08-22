import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class LabeledDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.black,
          ),
        ),
        SizedBox(height: ManagerHeight.h8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: value,
            hint: Text(
              hint,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.greyWithColor,
              ),
            ),
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.black,
            ),
            items: items,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: ManagerHeight.h48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ManagerRadius.r4),
                border: Border.all(
                  color: ManagerColors.greyWithColor.withOpacity(0.3),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: ManagerWidth.w4),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 48,
            ),
          ),
        ),
      ],
    );
  }
}
