import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class AccountTypeSelector extends StatefulWidget {
  final Function(String selectedType) onChanged;

  const AccountTypeSelector({super.key, required this.onChanged});

  @override
  State<AccountTypeSelector> createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<AccountTypeSelector> {
  String selectedType = "office"; // "office" or "personal"

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ManagerStrings.accountType,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => selectedType = "office");
            widget.onChanged(selectedType);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedType == "office"
                        ? ManagerColors.primaryColor
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: selectedType == "office"
                    ? Center(
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: ManagerColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                ManagerStrings.officeAccount,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: selectedType == "office"
                      ? ManagerColors.primaryColor
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() => selectedType = "personal");
            widget.onChanged(selectedType);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedType == "personal"
                        ? ManagerColors.primaryColor
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: selectedType == "personal"
                    ? Center(
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: ManagerColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: ManagerWidth.w6),
              Text(
                ManagerStrings.personalAccount,
                style: getMediumTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: selectedType == "personal"
                      ? ManagerColors.primaryColor
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
