import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:get/get.dart';

class LabeledTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final TextInputType keyboardType;

  final Widget? buttonWidget;
  final Widget? prefixIcon;
  final VoidCallback? onButtonTap;
  final double widthButton;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  final bool isPhoneField;
  final bool isEmailField;

  /// 🔹 الحل: أضف هنا onChanged
  final Function(String)? onChanged;

  const LabeledTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.enabled = true,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.buttonWidget,
    this.onButtonTap,
    required this.widthButton,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isPhoneField = false,
    this.isEmailField = false,
    this.onChanged, // ✅ أضفها هنا
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  bool isSaudiNumber = false;
  bool isValidEmail = false;

  bool _validateSaudiNumber(String input) {
    return (input.startsWith('966') && input.length >= 12) ||
        (input.startsWith('05') && input.length >= 10);
  }

  bool _validateEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: ManagerHeight.h8),
            child: Text(
              widget.label!,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
          ),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,

          onChanged: (val) {
            if (widget.isPhoneField) {
              setState(() {
                isSaudiNumber = _validateSaudiNumber(val);
              });
            }
            if (widget.isEmailField) {
              setState(() {
                isValidEmail = _validateEmail(val);
              });
            }

            if (widget.onChanged != null) {
              widget.onChanged!(val); // ✅ يستدعي الفنكشن من الشاشة
            }
          },

          onFieldSubmitted: widget.onFieldSubmitted ??
                  (_) {
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: getRegularTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.greyWithColor,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w8,
              vertical: ManagerHeight.h12,
            ),
            filled: true,
            fillColor: ManagerColors.white,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPhoneField
                ? (isSaudiNumber
                ? const Icon(Icons.check, color: ManagerColors.primaryColor)
                : null)
                : widget.isEmailField
                ? (isValidEmail
                ? const Icon(Icons.check,
                color: ManagerColors.primaryColor)
                : null)
                : (widget.onButtonTap != null
                ? ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: widget.widthButton,
                height: ManagerHeight.h48,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: ManagerHeight.h4,
                  bottom: ManagerHeight.h4,
                  right: Get.locale?.languageCode == 'en'
                      ? ManagerWidth.w4
                      : 0,
                  left: Get.locale?.languageCode == 'ar'
                      ? ManagerWidth.w4
                      : 0,
                ),
                child: ElevatedButton(
                  onPressed: widget.onButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ManagerColors.primaryColor,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft:
                        Get.locale?.languageCode == 'ar'
                            ? Radius.circular(
                            ManagerRadius.r4)
                            : const Radius.circular(0),
                        bottomLeft:
                        Get.locale?.languageCode == 'ar'
                            ? Radius.circular(
                            ManagerRadius.r4)
                            : const Radius.circular(0),
                        topRight:
                        Get.locale?.languageCode == 'en'
                            ? Radius.circular(
                            ManagerRadius.r4)
                            : const Radius.circular(0),
                        bottomRight:
                        Get.locale?.languageCode == 'en'
                            ? Radius.circular(
                            ManagerRadius.r4)
                            : const Radius.circular(0),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: widget.buttonWidget,
                ),
              ),
            )
                : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ManagerRadius.r4),
              borderSide: BorderSide(
                color: ManagerColors.greyWithColor.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ManagerRadius.r4),
              borderSide: BorderSide(
                color: ManagerColors.greyWithColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ManagerRadius.r4),
              borderSide: const BorderSide(
                color: ManagerColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
