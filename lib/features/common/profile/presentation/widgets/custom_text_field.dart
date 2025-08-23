import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_opacity.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import '../../../../../core/resources/manager_font_size.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final bool isPasswordField;
  final bool isRequired;
  final TextEditingController controller;
  final IconData? customPrefixIcon;
  final String? iconPath;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.isPasswordField = true,
    this.isRequired = false,
    this.customPrefixIcon,
    this.iconPath,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}


class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + optional red star
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 4),
          child: RichText(
            text: TextSpan(
              text: widget.label,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.titleTextFieldPassword,
              ),
              children: widget.isRequired
                  ? [
                TextSpan(
                  text: ' *',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.redNew,
                  ),
                )
              ]
                  : [],
            ),
          ),
        ),

        // TextField with controller and icon swap
        TextField(
          controller: widget.controller,
          obscureText: widget.isPasswordField ? obscureText : false,
          style: getRegularTextStyle(fontSize: ManagerFontSize.s14, color: Colors.black),
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: getRegularTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.titleTextFieldPassword.withOpacity(0.5),
            ),
            contentPadding:  EdgeInsets.symmetric(horizontal: ManagerWidth.w8, vertical: ManagerHeight.h12),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ManagerColors.titleTextFieldPassword.withOpacity(ManagerOpacity.op0_4),
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(ManagerRadius.r5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ManagerColors.titleTextFieldPassword.withOpacity(ManagerOpacity.op0_4),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(ManagerRadius.r5),
            ),
            prefixIcon: widget.iconPath != null
                ? Padding(
              padding:  EdgeInsets.symmetric(vertical: ManagerHeight.h16),
              child: Image.asset(
                widget.iconPath!,
                width: ManagerWidth.w16,
                height: ManagerHeight.h16,
                color: ManagerColors.titleTextFieldPassword,
              ),
            )
                : Icon(
              widget.isPasswordField
                  ? Icons.lock_outline
                  : widget.customPrefixIcon ?? Icons.text_fields,
              color: ManagerColors.titleTextFieldPassword,
            ),
            suffixIcon: widget.isPasswordField
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: ManagerColors.titleTextFieldPassword,
              ),
              onPressed: () => setState(() => obscureText = !obscureText),
            )
                : null,
          ),

        )

      ],
    );
  }
}
