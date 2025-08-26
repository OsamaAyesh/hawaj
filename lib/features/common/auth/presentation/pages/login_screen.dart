import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/labeled_text_field.dart';
import '../controller/send_otp_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Phone text controller
  final TextEditingController phoneController = TextEditingController();

  /// GetX Controller
  final SendOtpController controller = Get.find<SendOtpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      body: Stack(
        children: [
         ///Main Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ManagerHeight.h96),

                  /// Welcome Title
                  Align(
                    alignment: Get.locale?.languageCode == 'ar'
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      ManagerStrings.welcomeTitle,
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.primaryColor,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.1, end: 0, duration: 500.ms),
                  ),

                  SizedBox(height: ManagerHeight.h4),

                  /// Welcome Subtitle
                  Align(
                    alignment: Get.locale?.languageCode == 'ar'
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      ManagerStrings.welcomeSubtitle,
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.subtitleLoginTextColor,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 150.ms)
                        .slideY(begin: -0.05, end: 0, duration: 500.ms),
                  ),

                  SizedBox(height: ManagerHeight.h48),

                  /// Phone Number Field
                  LabeledTextField(
                    widthButton: ManagerWidth.w130,
                    label: ManagerStrings.phoneLabel,
                    hintText: ManagerStrings.phoneHint,
                    controller: phoneController,
                    isPhoneField: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ManagerHeight.h12),
                      child: Image.asset(
                        ManagerIcons.phoneIcon,
                        height: ManagerHeight.h12,
                        width: ManagerWidth.w14,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 1,
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 300.ms)
                      .slideX(begin: 0.1, end: 0, duration: 500.ms),

                  SizedBox(height: ManagerHeight.h28),

                  /// Login Button
                ButtonApp(
                  title: ManagerStrings.loginButton,
                  onPressed: () {
                    controller.sendOtp(phoneController.text);
                  },
                  paddingWidth: 0,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 450.ms)
                    .slideY(begin: 0.1, end: 0, duration: 500.ms),

                  SizedBox(height: ManagerHeight.h16),

                  /// Error Message
                  Obx(() {
                    if (controller.errorMessage.isNotEmpty) {
                      return Text(
                        controller.errorMessage.value,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: Colors.red,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),

          /// Overlay Loading
          Obx(() {
            if (controller.isLoading.value) {
              return LoadingWidget();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
